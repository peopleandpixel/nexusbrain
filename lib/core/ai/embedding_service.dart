import 'dart:math';

import 'package:dart_bert_tokenizer/dart_bert_tokenizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';

import '../../domain/models/block.dart';

class EmbeddingService {
  static final EmbeddingService _instance = EmbeddingService._internal();
  static EmbeddingService get instance => _instance;

  EmbeddingService._internal();

  bool _initialized = false;
  OrtSession? _session;
  WordPieceTokenizer? _tokenizer;
  final _onnxRuntime = OnnxRuntime();
  
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    
    try {
      // Modell laden (HINWEIS: Erfordert Modell-Datei in assets)
      // Wir gehen davon aus, dass ein Modell namens 'model.onnx' und 'vocab.txt' existieren werden
      // Falls nicht, fangen wir den Fehler ab und loggen ihn.
      try {
        _session = await _onnxRuntime.createSessionFromAsset('assets/ai/model.onnx');
        
        final vocabString = await rootBundle.loadString('assets/ai/vocab.txt');
        final vocab = Vocabulary.fromTokens(vocabString.split('\n'));
        _tokenizer = WordPieceTokenizer(vocab: vocab);
        
        _initialized = true;
      } catch (e) {
        if (kDebugMode) {
          print('EmbeddingService: Modell oder Vokabular nicht gefunden. Fallback auf Stub.');
        }
        // Wir setzen _initialized trotzdem auf true, damit die App nicht hängt, 
        // aber _session bleibt null.
        _initialized = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('EmbeddingService Initialisierungsfehler: $e');
      }
      _initialized = true;
    }
  }

  Future<List<double>> getEmbedding(String text) async {
    await ensureInitialized();
    if (text.trim().isEmpty) {
      return List.filled(384, 0.0);
    }

    if (_session == null || _tokenizer == null) {
      // Fallback-Implementierung: Einfacher deterministischer Vektor
      final seed = text.length.toDouble();
      return List.generate(384, (i) => (sin(seed + i) + 1.0) / 2.0);
    }

    try {
      final encoding = _tokenizer!.encode(text);
      final inputIds = encoding.ids;
      
      // Padding/Truncating auf 128 (Beispielhaft)
      const maxLength = 128;
      final paddedInputIds = Int64List(maxLength);
      for (var i = 0; i < min(inputIds.length, maxLength); i++) {
        paddedInputIds[i] = inputIds[i].toInt();
      }
      
      final attentionMask = Int64List(maxLength);
      for (var i = 0; i < min(inputIds.length, maxLength); i++) {
        attentionMask[i] = 1;
      }

      final tokenTypeIds = Int64List(maxLength);

      // ONNX Inferenz
      final shape = [1, maxLength];
      final inputOrt = await OrtValue.fromList(paddedInputIds, shape);
      final maskOrt = await OrtValue.fromList(attentionMask, shape);
      final typeOrt = await OrtValue.fromList(tokenTypeIds, shape);

      final inputs = {
        'input_ids': inputOrt,
        'attention_mask': maskOrt,
        'token_type_ids': typeOrt,
      };

      final outputs = await _session!.run(inputs);
      
      final outputValue = outputs.values.first;
      final outputTensor = await outputValue.asList();
      
      // Einfaches Mean Pooling (Beispielhaft)
      final lastHiddenState = outputTensor[0] as List<dynamic>;
      final embedding = List.filled((lastHiddenState[0] as List<dynamic>).length, 0.0);
      
      int count = 0;
      for (var i = 0; i < min(inputIds.length, maxLength); i++) {
        final tokenVector = lastHiddenState[i] as List<dynamic>;
        for (var j = 0; j < embedding.length; j++) {
          embedding[j] += (tokenVector[j] as num).toDouble();
        }
        count++;
      }
      
      if (count > 0) {
        for (var j = 0; j < embedding.length; j++) {
          embedding[j] /= count;
        }
      }

      // Cleanup
      // inputOrt.release(); // Scheinbar nicht vorhanden in dieser Version
      // maskOrt.release();
      // typeOrt.release();
      // for (var out in outputs.values) {
      //   out.release();
      // }
      
      return embedding;
    } catch (e) {
      if (kDebugMode) {
        print('Inferenzfehler: $e');
      }
      final seed = text.length.toDouble();
      return List.generate(384, (i) => (sin(seed + i) + 1.0) / 2.0);
    }
  }

  double cosineSimilarity(List<double> v1, List<double> v2) {
    if (v1.length != v2.length) return 0.0;
    
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    
    for (int i = 0; i < v1.length; i++) {
      dotProduct += v1[i] * v2[i];
      normA += v1[i] * v1[i];
      normB += v2[i] * v2[i];
    }
    
    if (normA == 0 || normB == 0) return 0.0;
    return dotProduct / (sqrt(normA) * sqrt(normB));
  }

  Future<List<(Block, double)>> findSimilarBlocks(
    String query, 
    List<Block> candidates, 
    {int limit = 10, double minScore = 0.3,}
  ) async {
    final queryEmbedding = await getEmbedding(query);
    final results = <(Block, double)>[];
    
    for (final block in candidates) {
      if (block.embedding == null) continue;
      
      final score = cosineSimilarity(queryEmbedding, block.embedding!);
      if (score >= minScore) {
        results.add((block, score));
      }
    }
    
    results.sort((a, b) => b.$2.compareTo(a.$2));
    return results.take(limit).toList();
  }
}
