import 'package:flutter_test/flutter_test.dart';
import 'package:nexusbrain/core/ai/nexus_brain_ai.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart';

void main() {
  late NexusBrainAi ai;

  setUp(() {
    ai = NexusBrainAi();
  });

  group('NexusBrainAi', () {
    test('extractTopics filters stop words and finds frequent terms', () {
      final blocks = [
        Block(blockId: '1', pageId: 'p1', content: 'Flutter is great for mobile development'),
        Block(blockId: '2', pageId: 'p1', content: 'Mobile apps with Flutter are fast'),
        Block(blockId: '3', pageId: 'p1', content: 'Development of mobile software'),
      ];

      final topics = ai.extractTopics(blocks);
      final topicNames = topics.map((t) => t.$1).toList();

      expect(topicNames, contains('mobile'));
      expect(topicNames, contains('flutter'));
      expect(topicNames, isNot(contains('is')));
      expect(topicNames, isNot(contains('for')));
    });

    test('generateSummary takes first few blocks', () {
      final blocks = [
        Block(blockId: '1', pageId: 'p1', content: 'First line of content'),
        Block(blockId: '2', pageId: 'p1', content: 'Second line of content'),
        Block(blockId: '3', pageId: 'p1', content: 'Third line'),
        Block(blockId: '4', pageId: 'p1', content: 'Fourth line'),
      ];

      final summary = ai.generateSummary(blocks, maxSentences: 2);
      expect(summary, contains('First line of content'));
      expect(summary, contains('Second line of content'));
      expect(summary, isNot(contains('Third line')));
    });

    test('suggestTaskStates identifies action verbs', () {
      final blocks = [
        Block(blockId: '1', pageId: 'p1', content: 'Kaufen Milch'),
        Block(blockId: '2', pageId: 'p1', content: 'Just some text'),
        Block(blockId: '3', pageId: 'p1', content: 'Call mom'),
      ];

      final suggestions = ai.suggestTaskStates(blocks);
      expect(suggestions.length, equals(2));
      expect(suggestions.any((s) => s.blockId == '1'), isTrue);
      expect(suggestions.any((s) => s.blockId == '3'), isTrue);
      expect(suggestions.every((s) => s.suggestedState == 'TODO'), isTrue);
    });

    test('suggestRelatedPages finds pages with common topics', () async {
      final page1 = Page(pageId: 'p1', title: 'Flutter');
      final blocks1 = [Block(blockId: 'b1', pageId: 'p1', content: 'Flutter mobile development')];

      final page2 = Page(pageId: 'p2', title: 'Dart');
      final blocks2 = [Block(blockId: 'b2', pageId: 'p2', content: 'Dart for mobile development')];

      final page3 = Page(pageId: 'p3', title: 'Cooking');
      final blocks3 = [Block(blockId: 'b3', pageId: 'p3', content: 'How to cook pasta')];

      final allPages = [page1, page2, page3];
      final allBlocks = {
        'p1': blocks1,
        'p2': blocks2,
        'p3': blocks3,
      };

      final related = await ai.suggestRelatedPages(page1, blocks1, allPages, allBlocks);
      
      expect(related.length, equals(1));
      expect(related.first.$1.pageId, equals('p2'));
    });
  });
}
