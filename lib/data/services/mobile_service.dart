import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/state/notes_state.dart';
import '../repositories/isar_block_repository.dart';

part 'mobile_service.g.dart';

@riverpod
class MobileService extends _$MobileService {
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void build() {
    // Initialisierung der Mobile-Dienste
    _initSharing();
    _initHomeWidget();
    
    ref.onDispose(() {
      _intentDataStreamSubscription?.cancel();
    });
  }

  void _initSharing() {
    // Für Texte, die geteilt werden, während die App läuft
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      if (value.isNotEmpty) {
        _handleSharedMedia(value);
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    },);

    // Für Texte, die geteilt wurden, bevor die App gestartet wurde
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        _handleSharedMedia(value);
      }
    });
  }

  void _initHomeWidget() {
    HomeWidget.setAppGroupId('group.nexusbrain');
    HomeWidget.registerInteractivityCallback(backgroundCallback);
  }

  Future<void> _handleSharedMedia(List<SharedMediaFile> media) async {
    final repo = ref.read(blockRepositoryProvider);
    
    for (var file in media) {
      if (file.type == SharedMediaType.text || file.type == SharedMediaType.url) {
        final content = file.path;
        if (content.isNotEmpty) {
          await _createQuickNote(repo, content);
        }
      }
    }
    
    // UI aktualisieren
    await ref.read(pagesProvider.notifier).refresh();
  }

  Future<void> _createQuickNote(IsarBlockRepository repo, String content) async {
    // Erstelle eine neue Seite für den geteilten Inhalt oder füge es zum Journal hinzu
    final now = DateTime.now();
    final journalPage = await repo.getJournalPageForDate(now);
    
    if (journalPage != null) {
      await repo.createBlock(journalPage.pageId, content: content);
    } else {
      final newPage = await repo.createPage("Shared ${now.hour}:${now.minute}");
      await repo.createBlock(newPage.pageId, content: content);
    }
  }
}

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'quickentry') {
    final content = uri?.queryParameters['content'];
    if (content != null) {
      final repo = IsarBlockRepository();
      final now = DateTime.now();
      final journalPage = await repo.getJournalPageForDate(now);
      
      if (journalPage != null) {
        await repo.createBlock(journalPage.pageId, content: content);
      } else {
        final newPage = await repo.createPage("Quick Note ${now.hour}:${now.minute}");
        await repo.createBlock(newPage.pageId, content: content);
      }
    }
  }
}
