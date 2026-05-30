import '../../domain/models/block.dart';
import '../../domain/models/page.dart';
import 'embedding_service.dart';

/// AI-powered features for NexusBrain.
/// Currently implemented using heuristics and NLP-lite patterns.
class NexusBrainAi {
  final EmbeddingService _embeddingService = EmbeddingService.instance;

  // A simple list of common English/German stop words to filter out.
  static const Set<String> _stopWords = {
    'the', 'is', 'at', 'which', 'on', 'and', 'a', 'to', 'of', 'for', 'with', 'it', 'as', 'by', 'are', 'be', 'this', 'that', 'from', 'but', 'not', 'or', 'if', 'up', 'out', 'can', 'will', 'was', 'were', 'been', 'has', 'have', 'had', 'do', 'does', 'did', 'about', 'some', 'any', 'my', 'your', 'his', 'her', 'its', 'our', 'their', 'me', 'you', 'him', 'us', 'them',
    'der', 'die', 'das', 'ein', 'eine', 'einer', 'eines', 'einem', 'einen', 'und', 'ist', 'sind', 'war', 'waren', 'auf', 'aus', 'bei', 'bis', 'da', 'durch', 'für', 'gegen', 'im', 'in', 'mit', 'nach', 'von', 'zu', 'zum', 'zur', 'als', 'auch', 'wie', 'noch', 'nur', 'schon', 'wenn', 'oder', 'aber', 'um', 'über', 'unter', 'vor', 'zwischen', 'an', 'am', 'es', 'er', 'sie', 'wir', 'ihr', 'mich', 'dich', 'sich', 'uns', 'euch', 'mein', 'dein', 'sein', 'unser', 'euer', 'man', 'wer', 'wo', 'wann', 'warum', 'weshalb',
  };

  /// Extracts potential topics from a list of blocks using term frequency analysis.
  List<(String, double)> extractTopics(List<Block> blocks, {int maxTopics = 10}) {
    if (blocks.isEmpty) return [];

    final Map<String, int> termFrequency = {};
    for (final block in blocks) {
      final words = block.content
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s\u00C0-\u00FF]'), ' ')
          .split(RegExp(r'\s+'));

      for (final word in words) {
        if (word.length > 2 && !_stopWords.contains(word)) {
          termFrequency[word] = (termFrequency[word] ?? 0) + 1;
        }
      }
    }

    final sortedEntries = termFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final int totalHits = termFrequency.values.fold(0, (sum, val) => sum + val);

    return sortedEntries
        .take(maxTopics)
        .map((e) => (e.key, e.value / totalHits))
        .toList();
  }

  /// Finds blocks similar to the given query using simple term overlap.
  List<(Block, double)> findSimilar(String query, List<Block> candidates) {
    if (query.isEmpty || candidates.isEmpty) return [];

    final queryWords = query.toLowerCase().split(RegExp(r'\s+')).toSet();
    final List<(Block, double)> scored = [];

    for (final block in candidates) {
      final blockWords = block.content.toLowerCase().split(RegExp(r'\s+')).toSet();
      final intersection = queryWords.intersection(blockWords).length;
      if (intersection > 0) {
        scored.add((block, intersection / queryWords.length));
      }
    }

    return scored..sort((a, b) => b.$2.compareTo(a.$2));
  }

  /// Discovers potential connections between pages that don't have explicit links yet.
  Future<List<(Page, Page, double)>> discoverConnections(
    List<Page> pages,
    Map<String, List<Block>> pageBlocks,
  ) async {
    final List<(Page, Page, double)> connections = [];
    if (pages.length < 2) return [];

    // Pre-calculate average embeddings for each page
    final Map<String, List<double>> pageEmbeddings = {};
    for (final page in pages) {
      final blocks = pageBlocks[page.pageId] ?? [];
      final embeddings = blocks
          .where((b) => b.embedding != null)
          .map((b) => b.embedding!)
          .toList();
      
      if (embeddings.isNotEmpty) {
        // Average embedding
        final avg = List.filled(embeddings.first.length, 0.0);
        for (final emb in embeddings) {
          for (int i = 0; i < emb.length; i++) {
            avg[i] += emb[i];
          }
        }
        for (int i = 0; i < avg.length; i++) {
          avg[i] /= embeddings.length;
        }
        pageEmbeddings[page.pageId] = avg;
      }
    }

    for (int i = 0; i < pages.length; i++) {
      for (int j = i + 1; j < pages.length; j++) {
        final pageA = pages[i];
        final pageB = pages[j];

        final embA = pageEmbeddings[pageA.pageId];
        final embB = pageEmbeddings[pageB.pageId];

        if (embA == null || embB == null) continue;

        final score = _embeddingService.cosineSimilarity(embA, embB);

        if (score > 0.6) { // Höherer Schwellenwert für Vektor-Ähnlichkeit
          connections.add((pageA, pageB, score));
        }
      }
    }

    return connections..sort((a, b) => b.$3.compareTo(a.$3));
  }

  /// Suggests task states based on content (e.g., lines starting with action verbs).
  List<TaskSuggestion> suggestTaskStates(List<Block> blocks) {
    final List<TaskSuggestion> suggestions = [];
    final actionVerbs = {'kaufen', 'anrufen', 'schreiben', 'lesen', 'machen', 'buy', 'call', 'write', 'read', 'check'};

    for (final block in blocks) {
      if (block.taskState != null) continue;

      final firstWord = block.content.trim().split(RegExp(r'\s+')).first.toLowerCase();
      if (actionVerbs.contains(firstWord)) {
        suggestions.add(TaskSuggestion(
          blockId: block.blockId,
          suggestedState: 'TODO',
          reason: 'Starts with an action verb',
        ),);
      }
    }

    return suggestions;
  }

  /// Generates a summary by picking the most "representative" sentences.
  String generateSummary(List<Block> blocks, {int maxSentences = 3}) {
    if (blocks.isEmpty) return 'Empty page.';
    
    // For now, take the first N non-empty blocks as a summary.
    final summaryBlocks = blocks
        .where((b) => b.content.trim().isNotEmpty)
        .take(maxSentences)
        .map((b) => b.preview)
        .toList();

    if (summaryBlocks.isEmpty) return 'No content to summarize.';
    return summaryBlocks.join(' ');
  }

  /// Suggests related pages for a given page.
  Future<List<(Page, double)>> suggestRelatedPages(
    Page sourcePage,
    List<Block> sourceBlocks,
    List<Page> allPages,
    Map<String, List<Block>> allPageBlocks,
  ) async {
    final sourceEmbeddings = sourceBlocks
        .where((b) => b.embedding != null)
        .map((b) => b.embedding!)
        .toList();
    
    if (sourceEmbeddings.isEmpty) return [];

    // Average embedding for source
    final sourceAvg = List.filled(sourceEmbeddings.first.length, 0.0);
    for (final emb in sourceEmbeddings) {
      for (int i = 0; i < emb.length; i++) {
        sourceAvg[i] += emb[i];
      }
    }
    for (int i = 0; i < sourceAvg.length; i++) {
      sourceAvg[i] /= sourceEmbeddings.length;
    }

    final List<(Page, double)> related = [];

    for (final page in allPages) {
      if (page.pageId == sourcePage.pageId) continue;

      final targetBlocks = allPageBlocks[page.pageId] ?? [];
      final targetEmbeddings = targetBlocks
          .where((b) => b.embedding != null)
          .map((b) => b.embedding!)
          .toList();
      
      if (targetEmbeddings.isEmpty) continue;

      // Average embedding for target
      final targetAvg = List.filled(targetEmbeddings.first.length, 0.0);
      for (final emb in targetEmbeddings) {
        for (int i = 0; i < emb.length; i++) {
          targetAvg[i] += emb[i];
        }
      }
      for (int i = 0; i < targetAvg.length; i++) {
        targetAvg[i] /= targetEmbeddings.length;
      }

      final score = _embeddingService.cosineSimilarity(sourceAvg, targetAvg);
      if (score > 0.5) {
        related.add((page, score));
      }
    }

    return related..sort((a, b) => b.$2.compareTo(a.$2));
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
