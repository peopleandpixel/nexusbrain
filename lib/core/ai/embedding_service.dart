import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart';

/// Local embedding service for semantic search and topic extraction.
/// TODO: Re-enable after Isar migration is complete
class LocalEmbeddingService {
  Map<String, double> embed(String text) => {};
  double similarity(Map<String, double> vec1, Map<String, double> vec2) => 0.0;

  List<(Block, double)> findSimilarBlocks(String query, List<Block> candidates, {int limit = 10, double minScore = 0.1}) {
    return [];
  }

  List<(String, double)> extractTopics(String text, {int maxTopics = 10}) {
    return [];
  }

  List<(String, double)> extractTopicsFromBlocks(List<Block> blocks, {int maxTopics = 15}) {
    return [];
  }

  List<(Page, Page, double)> findHiddenConnections(List<Page> pages, Map<String, List<Block>> pageBlocks, {double minScore = 0.15}) {
    return [];
  }
}

extension TaskBlockExtension on Block {
  String? parseTaskStateFromContent() {
    final upper = content.trim().toUpperCase();
    if (upper.startsWith('TODO')) return 'TODO';
    if (upper.startsWith('DOING')) return 'DOING';
    if (upper.startsWith('DONE')) return 'DONE';
    if (upper.startsWith('CANCELLED')) return 'CANCELLED';
    return null;
  }

  bool get hasTaskMarker => parseTaskStateFromContent() != null;
}
