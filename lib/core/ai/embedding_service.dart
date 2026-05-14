import 'dart:math';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;

/// Local embedding service for semantic search and topic extraction.
///
/// Uses TF-IDF (Term Frequency - Inverse Document Frequency) for vectorization.
/// This runs entirely locally, no API calls needed.
class LocalEmbeddingService {
  /// Common stop words to filter out (Portuguese + English, no duplicates)
  static final _stopWords = <String>{
    // Portuguese-specific
    'de', 'do', 'da', 'dos', 'das', 'dum', 'duma', 'no', 'na', 'nos', 'nas',
    'num', 'numa', 'pelo', 'pela', 'pelos', 'pelas', 'ao', 'aos', 'à', 'às',
    'em', 'um', 'uma', 'uns', 'umas', 'que', 'se', 'lhe', 'lhes', 'meu', 'minha',
    'meus', 'minhas', 'teu', 'tua', 'teus', 'tuas', 'seu', 'sua', 'seus', 'suas',
    'nosso', 'nossa', 'nossos', 'nossas', 'dele', 'dela', 'deles', 'delas',
    'este', 'esta', 'estes', 'estas', 'esse', 'essa', 'esses', 'essas',
    'aquele', 'aquela', 'aqueles', 'aquelas', 'isto', 'isso', 'aquilo',
    'muito', 'muita', 'muitos', 'muitas', 'pouco', 'pouca', 'poucos', 'poucas',
    'todo', 'toda', 'todos', 'todas', 'cada', 'qualquer', 'outro', 'outra',
    'outros', 'outras', 'mesmo', 'mesma', 'mesmos', 'mesmas', 'próprio',
    'própria', 'próprios', 'próprias', 'tal', 'tais', 'quem', 'onde', 'como',
    'quando', 'porque', 'porquê', 'pois', 'mas', 'porém', 'contudo', 'todavia',
    'entretanto', 'nem', 'ou', 'e', 'também', 'ainda', 'já', 'sempre', 'nunca',
    'aqui', 'aí', 'ali', 'lá', 'cá', 'acima', 'abaixo', 'dentro', 'fora',
    'sob', 'sobre', 'ante', 'após', 'até', 'desde', 'durante', 'entre',
    'perante', 'sem', 'com', 'para', 'por', 'contra', 'segundo', 'trás',
    'há', 'foi', 'era', 'ser', 'está', 'tem', 'ter', 'fazer', 'dar', 'ir',
    'ver', 'saber', 'poder', 'querer', 'dizer', 'vir', 'ficar', 'haver',
    'não', 'sim', 'só', 'bem', 'mal', 'assim', 'algo', 'alguém',
    'ninguém', 'nada', 'tudo', 'qual', 'quais', 'quanto', 'quanta',
    // English-specific (avoiding duplicates from Portuguese section above)
    'the', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
    'of', 'with', 'by', 'from', 'is', 'are', 'was', 'were', 'be', 'been',
    'being', 'have', 'has', 'had', 'does', 'did', 'will', 'would',
    'could', 'should', 'may', 'might', 'shall', 'can', 'this', 'that',
    'these', 'those', 'it', 'its', 'i', 'you', 'he', 'she', 'we', 'they',
    'me', 'him', 'her', 'us', 'them', 'my', 'your', 'his', 'our', 'their',
    'what', 'which', 'who', 'whom', 'when', 'where', 'why', 'how', 'all',
    'each', 'every', 'both', 'few', 'more', 'most', 'other', 'some', 'such',
    'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very',
    'just', 'now', 'here', 'there', 'then', 'once', 'if', 'else',
  };

  /// Generate a TF-IDF embedding vector for the given text.
  Map<String, double> embed(String text) {
    final tokens = _tokenize(text);
    return _computeTF(tokens);
  }

  /// Compute cosine similarity between two sparse vectors.
  double similarity(Map<String, double> vec1, Map<String, double> vec2) {
    if (vec1.isEmpty || vec2.isEmpty) return 0.0;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (final entry in vec1.entries) {
      norm1 += entry.value * entry.value;
      final v2 = vec2[entry.key];
      if (v2 != null) {
        dotProduct += entry.value * v2;
      }
    }

    for (final entry in vec2.entries) {
      norm2 += entry.value * entry.value;
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;
    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }

  /// Find semantically similar blocks from a list.
  List<(Block, double)> findSimilarBlocks(
    String query,
    List<Block> candidates, {
    int limit = 10,
    double minScore = 0.1,
  }) {
    final queryVec = embed(query);
    final results = <(Block, double)>[];

    for (final block in candidates) {
      final blockVec = embed(block.content);
      final score = similarity(queryVec, blockVec);
      if (score >= minScore) {
        results.add((block, score));
      }
    }

    results.sort((a, b) => b.$2.compareTo(a.$2));
    return results.take(limit).toList();
  }

  /// Extract key topics/keywords from text.
  List<(String, double)> extractTopics(String text, {int maxTopics = 10}) {
    final tokens = _tokenize(text);
    final tf = _computeTF(tokens);
    final sorted = tf.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(maxTopics).map((e) => (e.key, e.value)).toList();
  }

  /// Extract topics from multiple blocks.
  List<(String, double)> extractTopicsFromBlocks(List<Block> blocks, {int maxTopics = 15}) {
    final allText = blocks.map((b) => b.content).join(' ');
    return extractTopics(allText, maxTopics: maxTopics);
  }

  /// Find hidden connections between pages based on content similarity.
  List<(domain.MdBombPage, domain.MdBombPage, double)> findHiddenConnections(
    List<domain.MdBombPage> pages,
    Map<String, List<Block>> pageBlocks, {
    double minScore = 0.15,
  }) {
    final results = <(domain.MdBombPage, domain.MdBombPage, double)>[];
    final pageEmbeddings = <String, Map<String, double>>{};

    for (final page in pages) {
      final blocks = pageBlocks[page.id] ?? [];
      final allText = blocks.map((b) => b.content).join(' ');
      if (allText.isNotEmpty) {
        pageEmbeddings[page.id] = embed(allText);
      }
    }

    for (int i = 0; i < pages.length; i++) {
      for (int j = i + 1; j < pages.length; j++) {
        final p1 = pages[i];
        final p2 = pages[j];
        final e1 = pageEmbeddings[p1.id];
        final e2 = pageEmbeddings[p2.id];
        if (e1 != null && e2 != null) {
          final score = similarity(e1, e2);
          if (score >= minScore) {
            results.add((p1, p2, score));
          }
        }
      }
    }

    results.sort((a, b) => b.$3.compareTo(a.$3));
    return results;
  }

  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length > 2 && !_stopWords.contains(t))
        .toList();
  }

  Map<String, double> _computeTF(List<String> tokens) {
    final tf = <String, int>{};
    for (final token in tokens) {
      tf[token] = (tf[token] ?? 0) + 1;
    }
    final total = tokens.length.toDouble();
    return tf.map((k, v) => MapEntry(k, v / total));
  }
}

/// Extension methods for Block to support task syntax.
extension TaskBlockExtension on Block {
  /// Parse task state from content if using Logseq-style syntax.
  String? parseTaskStateFromContent() {
    final upper = content.trim().toUpperCase();
    if (upper.startsWith('TODO')) return 'TODO';
    if (upper.startsWith('DOING')) return 'DOING';
    if (upper.startsWith('DONE')) return 'DONE';
    if (upper.startsWith('CANCELLED')) return 'CANCELLED';
    if (upper.startsWith('WAITING')) return 'WAITING';
    return null;
  }

  bool get hasTaskMarker => parseTaskStateFromContent() != null;
}
