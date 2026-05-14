import 'package:nexusbrain/core/ai/embedding_service.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;

/// AI-powered features for NexusBrain.
class NexusBrainAi {
  final LocalEmbeddingService _embedding = LocalEmbeddingService();

  /// Extract topics from a page's blocks.
  List<(String, double)> extractTopics(List<Block> blocks, {int maxTopics = 10}) {
    return _embedding.extractTopicsFromBlocks(blocks, maxTopics: maxTopics);
  }

  /// Find semantically similar blocks to a query.
  List<(Block, double)> findSimilar(String query, List<Block> candidates) {
    return _embedding.findSimilarBlocks(query, candidates);
  }

  /// Discover hidden connections between pages.
  List<(domain.MdBombPage, domain.MdBombPage, double)> discoverConnections(
    List<domain.MdBombPage> pages,
    Map<String, List<Block>> pageBlocks,
  ) {
    return _embedding.findHiddenConnections(pages, pageBlocks);
  }

  /// Auto-detect task blocks and suggest task state.
  List<TaskSuggestion> suggestTaskStates(List<Block> blocks) {
    final suggestions = <TaskSuggestion>[];

    for (final block in blocks) {
      if (block.taskState == null) {
        final detected = block.parseTaskStateFromContent();
        if (detected != null) {
          suggestions.add(TaskSuggestion(
            blockId: block.id,
            suggestedState: detected,
            reason: 'Detected task marker in content',
          ));
        }
      }

      if (block.taskState == 'TODO') {
        final age = DateTime.now().difference(block.updatedAt);
        if (age.inHours < 24) {
          suggestions.add(TaskSuggestion(
            blockId: block.id,
            suggestedState: 'DOING',
            reason: 'Recently active TODO',
          ));
        }
      }
    }

    return suggestions;
  }

  /// Generate a summary of a page based on its blocks.
  String generateSummary(List<Block> blocks, {int maxSentences = 3}) {
    if (blocks.isEmpty) return 'Empty page.';

    final allText = blocks.map((b) => b.content).join('. ');
    final topics = _embedding.extractTopics(allText, maxTopics: 5);

    if (topics.isEmpty) return blocks.first.preview;

    final topicNames = topics.map((t) => t.$1).take(3).join(', ');
    return 'Topics: $topicNames. ${blocks.length} blocks.';
  }

  /// Suggest related pages based on content similarity.
  List<(domain.MdBombPage, double)> suggestRelatedPages(
    domain.MdBombPage sourcePage,
    List<Block> sourceBlocks,
    List<domain.MdBombPage> allPages,
    Map<String, List<Block>> allPageBlocks,
  ) {
    final sourceText = sourceBlocks.map((b) => b.content).join(' ');
    final sourceVec = _embedding.embed(sourceText);

    final suggestions = <(domain.MdBombPage, double)>[];

    for (final page in allPages) {
      if (page.id == sourcePage.id) continue;

      final blocks = allPageBlocks[page.id] ?? [];
      final pageText = blocks.map((b) => b.content).join(' ');
      if (pageText.isEmpty) continue;

      final pageVec = _embedding.embed(pageText);
      final score = _embedding.similarity(sourceVec, pageVec);

      if (score > 0.1) {
        suggestions.add((page, score));
      }
    }

    suggestions.sort((a, b) => b.$2.compareTo(a.$2));
    return suggestions.take(5).toList();
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
