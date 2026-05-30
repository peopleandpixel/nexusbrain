import '../../domain/models/block.dart';
import '../../domain/models/page.dart' as domain;

class SyncConflict {
  final String pageId;
  final domain.Page localPage;
  final domain.Page remotePage;
  final List<Block> localBlocks;
  final List<Block> remoteBlocks;
  final DateTime lastSyncTime;

  SyncConflict({
    required this.pageId,
    required this.localPage,
    required this.remotePage,
    required this.localBlocks,
    required this.remoteBlocks,
    required this.lastSyncTime,
  });
}
