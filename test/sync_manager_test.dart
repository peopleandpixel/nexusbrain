import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nexusbrain/core/sync/sync_manager.dart';
import 'package:nexusbrain/core/sync/sync_service.dart';
import 'package:nexusbrain/data/repositories/isar_block_repository.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/tag.dart';

class MockIsarBlockRepository extends Mock implements IsarBlockRepository {}
class MockSyncService extends Mock implements SyncService {}

void main() {
  late SyncManager syncManager;
  late MockIsarBlockRepository mockRepository;
  late MockSyncService mockSyncService;
  late Isar isar;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    mockRepository = MockIsarBlockRepository();
    mockSyncService = MockSyncService();
    
    isar = await Isar.open(
      [domain.PageSchema, BlockSchema, TagSchema],
      directory: Directory.systemTemp.path,
      name: 'test_db_${DateTime.now().millisecondsSinceEpoch}',
    );

    syncManager = SyncManager(
      repository: mockRepository,
      syncService: mockSyncService,
      isar: isar,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('SyncManager - sync() logic (Partially Mocked)', () {
    test('should connect and upload local data if no remote data exists', () async {
      // Arrange
      when(() => mockSyncService.connect()).thenAnswer((_) async => true);
      when(() => mockSyncService.downloadFile(any())).thenAnswer((_) async => null);
      when(() => mockRepository.getAllPages()).thenAnswer((_) async => []);
      when(() => mockSyncService.uploadFile(any(), any())).thenAnswer((_) async {});

      // Act
      await syncManager.sync();

      // Assert
      verify(() => mockSyncService.connect()).called(1);
      verify(() => mockSyncService.downloadFile('nexusbrain_sync.json')).called(1);
      verify(() => mockSyncService.uploadFile('nexusbrain_sync.json', any())).called(1);
    });

    test('should not sync if service is null', () async {
      final manager = SyncManager(repository: mockRepository, syncService: null);
      await manager.sync();
      verifyNever(() => mockRepository.getAllPages());
    });
    
    test('should throw exception if connection fails', () async {
       when(() => mockSyncService.connect()).thenAnswer((_) async => false);
       
       expect(() => syncManager.sync(), throwsException);
    });

    test('should download remote page and save it if it does not exist locally', () async {
      // Arrange
      const remotePageId = 'remote_1';
      final remoteUpdatedAt = DateTime(2023, 1, 1).toIso8601String();
      final remoteData = [{
        'page': {
          'pageId': remotePageId,
          'title': 'Remote Page',
          'isJournal': false,
          'createdAt': remoteUpdatedAt,
          'updatedAt': remoteUpdatedAt,
        },
        'blocks': [],
      }];

      when(() => mockSyncService.connect()).thenAnswer((_) async => true);
      when(() => mockSyncService.downloadFile(any())).thenAnswer((_) async => utf8.encode(jsonEncode(remoteData)));
      when(() => mockRepository.getAllPages()).thenAnswer((_) async => []);
      when(() => mockRepository.getPageByPageId(remotePageId)).thenAnswer((_) async => null);
      when(() => mockRepository.getBlocksForPage(remotePageId)).thenAnswer((_) async => []);
      when(() => mockSyncService.uploadFile(any(), any())).thenAnswer((_) async {});

      // Act
      await syncManager.sync();

      // Assert
      final savedPage = await isar.pages.filter().pageIdEqualTo(remotePageId).findFirst();
      expect(savedPage, isNotNull);
      expect(savedPage!.title, 'Remote Page');
      verify(() => mockSyncService.uploadFile('nexusbrain_sync.json', any())).called(1);
    });

    test('should update local page if remote is newer', () async {
      // Arrange
      const pageId = 'page_1';
      final localUpdatedAt = DateTime(2023, 1, 1);
      final remoteUpdatedAt = DateTime(2023, 1, 2);
      
      final localPage = domain.Page(
        pageId: pageId,
        title: 'Local Title',
        updatedAt: localUpdatedAt,
        createdAt: localUpdatedAt,
      );
      
      // Save initial local page to Isar
      await isar.writeTxn(() => isar.pages.put(localPage));

      final remoteData = [{
        'page': {
          'pageId': pageId,
          'title': 'Remote Title (Newer)',
          'isJournal': false,
          'createdAt': remoteUpdatedAt.toIso8601String(),
          'updatedAt': remoteUpdatedAt.toIso8601String(),
        },
        'blocks': [],
      }];

      when(() => mockSyncService.connect()).thenAnswer((_) async => true);
      when(() => mockSyncService.downloadFile(any())).thenAnswer((_) async => utf8.encode(jsonEncode(remoteData)));
      when(() => mockRepository.getAllPages()).thenAnswer((_) async => [localPage]);
      when(() => mockRepository.getPageByPageId(pageId)).thenAnswer((_) async => localPage);
      when(() => mockRepository.getBlocksForPage(pageId)).thenAnswer((_) async => []);
      when(() => mockSyncService.uploadFile(any(), any())).thenAnswer((_) async {});

      // Act
      await syncManager.sync();

      // Assert
      final updatedPage = await isar.pages.filter().pageIdEqualTo(pageId).findFirst();
      expect(updatedPage!.title, 'Remote Title (Newer)');
      expect(updatedPage.updatedAt, remoteUpdatedAt);
    });
  });
}
