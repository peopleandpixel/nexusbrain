import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/isar_block_repository.dart';
import '../../domain/models/block.dart';
import '../../domain/models/page.dart' as domain;
import '../../domain/models/sync_conflict.dart';
import '../../presentation/state/notes_state.dart';
import '../../presentation/state/sync_state.dart';
import '../database/isar_service.dart';
import 'git_sync_service.dart';
import 'sync_service.dart';
import 'webdav_sync_service.dart';

part 'sync_manager.g.dart';

/// Verwaltet die Synchronisation von Daten zwischen der lokalen Datenbank und einem Remote-Service.
///
/// Implementiert eine bidirektionale Synchronisation mit Zeitstempel-basierter Konfliktauflösung.
class SyncManager {
  final IsarBlockRepository repository;
  final SyncService? syncService;
  final Isar? isar;
  final bool e2eeEnabled;
  final String? e2eePassword;
  final DateTime? lastSyncTime;
  final Future<bool?> Function(SyncConflict)? onConflict;

  SyncManager({
    required this.repository,
    this.syncService,
    this.isar,
    this.e2eeEnabled = false,
    this.e2eePassword,
    this.lastSyncTime,
    this.onConflict,
  });

  Future<Isar> get _db async => isar ?? await IsarService.instance;

  /// Führt den Synchronisationsvorgang aus.
  ///
  /// 1. Lädt Remote-Daten herunter.
  /// 2. Sammelt lokale Daten.
  /// 3. Führt einen bidirektionalen Merge durch.
  /// 4. Lädt das konsolidierte Ergebnis wieder hoch.
  Future<DateTime?> sync() async {
    if (syncService == null) return null;
    
    final connected = await syncService!.connect();
    if (!connected) {
      throw Exception('Could not connect to WebDAV server');
    }

    // 1. Download existing remote data
    List<Map<String, dynamic>> remoteData = [];
    final remoteBytes = await syncService!.downloadFile('nexusbrain_sync.json');
    if (remoteBytes != null) {
      try {
        List<int> decryptedBytes = remoteBytes;
        if (e2eeEnabled && e2eePassword != null && e2eePassword!.isNotEmpty) {
          decryptedBytes = _decrypt(remoteBytes, e2eePassword!);
        }
        
        final decoded = jsonDecode(utf8.decode(decryptedBytes));
        if (decoded is List) {
          remoteData = List<Map<String, dynamic>>.from(decoded);
        }
      } catch (e) {
        // Corrupted remote file, wrong password or old format, continue with empty remote data
      }
    }

    // 2. Fetch local data
    final localPages = await repository.getAllPages();
    final Map<String, Map<String, dynamic>> localDataMap = {};
    
    for (final page in localPages) {
      final blocks = await repository.getBlocksForPage(page.pageId);
      localDataMap[page.pageId] = {
        'page': {
          'pageId': page.pageId,
          'title': page.title,
          'isJournal': page.isJournal,
          'createdAt': page.createdAt?.toIso8601String(),
          'updatedAt': page.updatedAt?.toIso8601String(),
        },
        'blocks': blocks.map((b) => {
          'blockId': b.blockId,
          'content': b.content,
          'parentId': b.parentId,
          'orderIndex': b.orderIndex,
          'indentLevel': b.indentLevel,
          'isCollapsed': b.isCollapsed,
          'taskState': b.taskState,
          'scheduledAt': b.scheduledAt?.toIso8601String(),
          'deadlineAt': b.deadlineAt?.toIso8601String(),
          'completedAt': b.completedAt?.toIso8601String(),
          'createdAt': b.createdAt?.toIso8601String(),
          'updatedAt': b.updatedAt?.toIso8601String(),
        },).toList(),
      };
    }

    // 3. Bidirectional Merge
    final Map<String, Map<String, dynamic>> mergedDataMap = Map.from(localDataMap);
    final now = DateTime.now();

    for (final remoteEntry in remoteData) {
      final remotePageData = remoteEntry['page'];
      final String pageId = remotePageData['pageId'];
      final DateTime remotePageUpdatedAt = DateTime.parse(remotePageData['updatedAt']);

      if (!mergedDataMap.containsKey(pageId)) {
        // Remote page is missing locally, add it
        mergedDataMap[pageId] = remoteEntry;
        await _applyRemoteToLocal(remoteEntry);
      } else {
        // Page exists in both, check timestamps and for conflicts
        final localEntry = mergedDataMap[pageId]!;
        final localPageData = localEntry['page'];
        final DateTime localPageUpdatedAt = DateTime.parse(localPageData['updatedAt']);

        bool conflictDetected = false;
        if (lastSyncTime != null) {
          // If both versions were updated since last sync, we have a potential conflict
          if (localPageUpdatedAt.isAfter(lastSyncTime!) && remotePageUpdatedAt.isAfter(lastSyncTime!)) {
            // Check if they actually differ in content (title or blocks)
            if (_hasDifferences(localEntry, remoteEntry)) {
              conflictDetected = true;
            }
          }
        }

        if (conflictDetected && onConflict != null) {
          final conflict = SyncConflict(
            pageId: pageId,
            localPage: _mapToPage(localPageData),
            remotePage: _mapToPage(remotePageData),
            localBlocks: (localEntry['blocks'] as List).map((b) => _mapToBlock(pageId, b)).toList(),
            remoteBlocks: (remoteEntry['blocks'] as List).map((b) => _mapToBlock(pageId, b)).toList(),
            lastSyncTime: lastSyncTime!,
          );
          
          final useLocal = await onConflict!(conflict);
          if (useLocal == true) {
            // Keep local version (already in mergedDataMap)
          } else if (useLocal == false) {
            // Use remote version
            mergedDataMap[pageId] = remoteEntry;
            await _applyRemoteToLocal(remoteEntry);
          } else {
            // Skip/Abort or handle later - for now keep local
          }
        } else if (remotePageUpdatedAt.isAfter(localPageUpdatedAt)) {
          // Remote page is newer, update local
          mergedDataMap[pageId] = remoteEntry;
          await _applyRemoteToLocal(remoteEntry);
        } else if (localPageUpdatedAt.isAfter(remotePageUpdatedAt)) {
          // Local page is newer, will be uploaded later
        } else {
          // Same timestamp, check blocks
          await _syncBlocks(pageId, List<Map<String, dynamic>>.from(remoteEntry['blocks']));
        }
      }
    }

    // 4. Final consolidated export & upload
    final List<Map<String, dynamic>> finalExportData = mergedDataMap.values.toList();
    final jsonString = jsonEncode(finalExportData);
    List<int> bytesToUpload = utf8.encode(jsonString);

    if (e2eeEnabled && e2eePassword != null && e2eePassword!.isNotEmpty) {
      bytesToUpload = _encrypt(bytesToUpload, e2eePassword!);
    }

    await syncService!.uploadFile('nexusbrain_sync.json', bytesToUpload);
    return now;
  }

  bool _hasDifferences(Map<String, dynamic> local, Map<String, dynamic> remote) {
    if (local['page']['title'] != remote['page']['title']) return true;
    
    final localBlocks = local['blocks'] as List;
    final remoteBlocks = remote['blocks'] as List;
    
    if (localBlocks.length != remoteBlocks.length) return true;
    
    for (int i = 0; i < localBlocks.length; i++) {
      if (localBlocks[i]['content'] != remoteBlocks[i]['content']) return true;
      if (localBlocks[i]['blockId'] != remoteBlocks[i]['blockId']) return true;
      if (localBlocks[i]['parentId'] != remoteBlocks[i]['parentId']) return true;
      if (localBlocks[i]['orderIndex'] != remoteBlocks[i]['orderIndex']) return true;
    }
    
    return false;
  }

  domain.Page _mapToPage(Map<String, dynamic> data) {
    return domain.Page(
      pageId: data['pageId'],
      title: data['title'],
      isJournal: data['isJournal'] ?? false,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  Block _mapToBlock(String pageId, Map<String, dynamic> data) {
    return Block(
      blockId: data['blockId'],
      pageId: pageId,
      parentId: data['parentId'],
      content: data['content'] ?? '',
      orderIndex: data['orderIndex'] ?? 0,
      indentLevel: data['indentLevel'] ?? 0,
      isCollapsed: data['isCollapsed'] ?? false,
      taskState: data['taskState'],
      scheduledAt: data['scheduledAt'] != null ? DateTime.parse(data['scheduledAt']) : null,
      deadlineAt: data['deadlineAt'] != null ? DateTime.parse(data['deadlineAt']) : null,
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  /// Verschlüsselt Daten mit AES-GCM.
  List<int> _encrypt(List<int> data, String password) {
    final key = _deriveKey(password);
    final iv = encrypt.IV.fromSecureRandom(12);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm, padding: null));
    
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    
    // Ergebnis: IV (12 Bytes) + Encrypted Data
    final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
    result.setAll(0, iv.bytes);
    result.setAll(iv.bytes.length, encrypted.bytes);
    return result;
  }

  /// Entschlüsselt Daten mit AES-GCM.
  List<int> _decrypt(List<int> encryptedData, String password) {
    if (encryptedData.length < 12) throw Exception('Invalid encrypted data');
    
    final key = _deriveKey(password);
    final iv = encrypt.IV(Uint8List.fromList(encryptedData.sublist(0, 12)));
    final ciphertext = Uint8List.fromList(encryptedData.sublist(12));
    
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm, padding: null));
    return encrypter.decryptBytes(encrypt.Encrypted(ciphertext), iv: iv);
  }

  /// Leitet einen 32-Byte Key aus dem Passwort ab.
  encrypt.Key _deriveKey(String password) {
    final passwordBytes = utf8.encode(password);
    final hash = sha256.convert(passwordBytes);
    return encrypt.Key(Uint8List.fromList(hash.bytes));
  }

  /// Wendet Remote-Daten auf die lokale Datenbank an.
  Future<void> _applyRemoteToLocal(Map<String, dynamic> remoteEntry) async {
    final pageData = remoteEntry['page'];
    final List<dynamic> blocksData = remoteEntry['blocks'];

    // 1. Create or Update Page
    domain.Page? existingPage = await repository.getPageByPageId(pageData['pageId']);
    if (existingPage == null) {
      // Need a way to create with specific ID and timestamps
      // For now we use a simpler approach if repository doesn't support it directly
      await _forceSavePage(pageData);
    } else {
      final DateTime remoteUpdatedAt = DateTime.parse(pageData['updatedAt']);
      if (existingPage.updatedAt == null || remoteUpdatedAt.isAfter(existingPage.updatedAt!)) {
        await _forceSavePage(pageData);
      }
    }

    // 2. Sync Blocks
    await _syncBlocks(pageData['pageId'], List<Map<String, dynamic>>.from(blocksData));
  }

  /// Synchronisiert eine Liste von Blöcken einer Seite.
  Future<void> _syncBlocks(String pageId, List<Map<String, dynamic>> remoteBlocks) async {
    final localBlocks = await repository.getBlocksForPage(pageId);
    final localBlocksMap = {for (var b in localBlocks) b.blockId: b};

    for (final rb in remoteBlocks) {
      final String blockId = rb['blockId'];
      final DateTime remoteUpdatedAt = DateTime.parse(rb['updatedAt']);

      if (!localBlocksMap.containsKey(blockId)) {
        await _forceSaveBlock(pageId, rb);
      } else {
        final lb = localBlocksMap[blockId]!;
        if (lb.updatedAt == null || remoteUpdatedAt.isAfter(lb.updatedAt!)) {
          await _forceSaveBlock(pageId, rb);
        }
      }
    }
  }

  /// Erzwingt das Speichern einer Seite mit spezifischen Zeitstempeln.
  Future<void> _forceSavePage(Map<String, dynamic> data) async {
    final db = await _db;
    final page = domain.Page(
      pageId: data['pageId'],
      title: data['title'],
      isJournal: data['isJournal'] ?? false,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );

    await db.writeTxn(() async {
      final matches = await db.pages.where().findAll();
      final domain.Page existing = matches.firstWhere((p) => p.pageId == page.pageId, orElse: () => page);
      if (existing != page) {
        page.id = existing.id;
      }
      await db.pages.put(page);
    });
  }

  /// Erzwingt das Speichern eines Blocks mit spezifischen Zeitstempeln.
  Future<void> _forceSaveBlock(String pageId, Map<String, dynamic> data) async {
    final db = await _db;
    final block = Block(
      blockId: data['blockId'],
      pageId: pageId,
      parentId: data['parentId'],
      content: data['content'] ?? '',
      orderIndex: data['orderIndex'] ?? 0,
      indentLevel: data['indentLevel'] ?? 0,
      isCollapsed: data['isCollapsed'] ?? false,
      taskState: data['taskState'],
      scheduledAt: data['scheduledAt'] != null ? DateTime.parse(data['scheduledAt']) : null,
      deadlineAt: data['deadlineAt'] != null ? DateTime.parse(data['deadlineAt']) : null,
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );

    await db.writeTxn(() async {
      final matches = await db.blocks.where().blockIdEqualTo(block.blockId).findAll();
      if (matches.isNotEmpty) {
        block.id = matches.first.id;
      }
      await db.blocks.put(block);
    });
  }
}

@riverpod
SyncManager syncManager(Ref ref) {
  final settings = ref.watch(syncSettingsProvider);
  
  SyncService? service;
  if (settings.enabled && settings.url.isNotEmpty) {
    if (settings.type == SyncType.webdav) {
      try {
        final uri = Uri.parse(settings.url);
        service = WebDavSyncService(
          host: uri.host,
          user: settings.user,
          password: settings.password,
          path: uri.path.isEmpty ? '/' : uri.path,
          port: uri.port == 0 ? (uri.scheme == 'https' ? 443 : 80) : uri.port,
          secure: uri.scheme == 'https',
        );
      } catch (_) {
        // Invalid URL
      }
    } else if (settings.type == SyncType.git) {
      service = GitSyncService(
        repoUrl: settings.url,
        branch: settings.gitBranch,
        user: settings.user.isNotEmpty ? settings.user : null,
        password: settings.password.isNotEmpty ? settings.password : null,
      );
    }
  }

  return SyncManager(
    repository: ref.read(blockRepositoryProvider),
    syncService: service,
    e2eeEnabled: settings.enabled && settings.e2eeEnabled,
    e2eePassword: settings.e2eePassword,
    lastSyncTime: settings.lastSyncTime,
  );
}
