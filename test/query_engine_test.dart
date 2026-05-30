import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nexusbrain/core/database/query_engine.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/tag.dart';

void main() {
  late Isar isar;
  late QueryEngine queryEngine;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [domain.PageSchema, BlockSchema, TagSchema],
      directory: Directory.systemTemp.path,
      name: 'test_query_engine_db_${DateTime.now().millisecondsSinceEpoch}',
    );
    queryEngine = QueryEngine(isar);

    // Seed data
    await isar.writeTxn(() async {
      final blocks = [
        Block(blockId: '1', pageId: 'p1', content: 'Task 1', taskState: 'TODO'),
        Block(blockId: '2', pageId: 'p1', content: 'Task 2', taskState: 'DONE'),
        Block(blockId: '3', pageId: 'p2', content: 'Note about Flutter'),
        Block(blockId: '4', pageId: 'p2', content: 'Important Task', taskState: 'DOING', deadlineAt: DateTime.now().subtract(const Duration(days: 1))),
      ];
      await isar.blocks.putAll(blocks);
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('QueryEngine - findBlocks', () {
    test('should filter by task state', () async {
      final results = await queryEngine.findBlocks({'task': 'TODO'});
      expect(results.length, 1);
      expect(results.first.content, 'Task 1');
    });

    test('should filter by content', () async {
      final results = await queryEngine.findBlocks({'content': 'Flutter'});
      expect(results.length, 1);
      expect(results.first.blockId, '3');
    });

    test('should filter by pageId', () async {
      final results = await queryEngine.findBlocks({'pageId': 'p1'});
      expect(results.length, 2);
    });

    test('should find overdue tasks', () async {
      final results = await queryEngine.findBlocks({'isOverdue': true});
      expect(results.length, 1);
      expect(results.first.blockId, '4');
    });
  });

  group('QueryEngine - executeStringQuery', () {
    test('should parse and execute task query', () async {
      final results = await queryEngine.executeStringQuery('(task DONE)');
      expect(results.length, 1);
      expect(results.first.blockId, '2');
    });

    test('should parse and execute content query', () async {
      final results = await queryEngine.executeStringQuery('(content Flutter)');
      expect(results.length, 1);
      expect(results.first.blockId, '3');
    });

    test('should handle raw string as content search', () async {
      final results = await queryEngine.executeStringQuery('Important');
      expect(results.length, 1);
      expect(results.first.blockId, '4');
    });

    test('should parse multiple filters', () async {
      final results = await queryEngine.executeStringQuery('(page p1) (task TODO)');
      expect(results.length, 1);
      expect(results.first.blockId, '1');
    });
  });
}
