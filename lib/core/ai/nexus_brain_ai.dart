import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart';

/// AI-powered features for NexusBrain.
/// TODO: Re-enable after Isar migration is complete
class NexusBrainAi {
  List<(String, double)> extractTopics(List<Block> blocks, {int maxTopics = 10}) {
    return [];
  }

  List<(Block, double)> findSimilar(String query, List<Block> candidates) {
    return [];
  }

  List<(Page, Page, double)> discoverConnections(
    List<Page> pages,
    Map<String, List<Block>> pageBlocks,
  ) {
    return [];
  }

  List<TaskSuggestion> suggestTaskStates(List<Block> blocks) {
    return [];
  }

  String generateSummary(List<Block> blocks, {int maxSentences = 3}) {
    if (blocks.isEmpty) return 'Empty page.';
    return '${blocks.length} blocks.';
  }

  List<(Page, double)> suggestRelatedPages(
    Page sourcePage,
    List<Block> sourceBlocks,
    List<Page> allPages,
    Map<String, List<Block>> allPageBlocks,
  ) {
    return [];
  }
}

class TaskSuggestion {
  final String blockId;
  final String suggestedState;
  final String reason;

  TaskSuggestion({
    required this.blockId,
    required this.suggestedState,
    required this.reason,
  });
}
