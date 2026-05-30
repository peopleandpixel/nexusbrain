import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nexusbrain/core/database/fts_service.dart';
import 'package:nexusbrain/data/repositories/isar_block_repository.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/tag.dart';

void main() {
  late IsarBlockRepository repository;
  late Isar isar;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [domain.PageSchema, BlockSchema, TagSchema],
      directory: Directory.systemTemp.path,
      name: 'test_repository_db_${DateTime.now().millisecondsSinceEpoch}',
    );
    repository = IsarBlockRepository(isar: isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    await FtsService.close();
  });

  group('IsarBlockRepository CRUD', () {
    test('should create and retrieve a page', () async {
      final page = await repository.createPage('Test Page');
      
      expect(page.title, 'Test Page');
      expect(page.pageId, isNotNull);
      
      final retrieved = await repository.getPageByPageId(page.pageId);
      expect(retrieved, isNotNull);
      expect(retrieved!.title, 'Test Page');
    });

    test('should create a block for a page', () async {
      final page = await repository.createPage('Test Page');
      final block = await repository.createBlock(page.pageId, content: 'Hello World');
      
      expect(block.content, 'Hello World');
      expect(block.pageId, page.pageId);
      
      final blocks = await repository.getBlocksForPage(page.pageId);
      expect(blocks.length, 1);
      expect(blocks.first.content, 'Hello World');
    });

    test('should delete a page and its blocks', () async {
      final page = await repository.createPage('To Delete');
      await repository.createBlock(page.pageId, content: 'Block 1');
      await repository.createBlock(page.pageId, content: 'Block 2');
      
      await repository.deletePage(page.pageId);
      
      final retrievedPage = await repository.getPageByPageId(page.pageId);
      expect(retrievedPage, isNull);
      
      final blocks = await repository.getBlocksForPage(page.pageId);
      expect(blocks, isEmpty);
    });
  });

  group('IsarBlockRepository - Search (FTS)', () {
    test('should find content via search', () async {
      final page = await repository.createPage('Searchable Page');
      await repository.createBlock(page.pageId, content: 'Unique keyword zebra');
      
      final results = await repository.searchPages('zebra');
      expect(results, isNotEmpty);
      expect(results.first.pageId, page.pageId);
    });

    test('should find page by block content search', () async {
      final page1 = await repository.createPage('Page 1');
      final page2 = await repository.createPage('Page 2');
      
      await repository.createBlock(page1.pageId, content: 'This block has secret content');
      await repository.createBlock(page2.pageId, content: 'This block is ordinary');
      
      final results = await repository.searchPages('secret');
      
      expect(results.length, 1);
      expect(results.first.pageId, page1.pageId);
      expect(results.first.title, 'Page 1');
    });

    test('should find page by title search (virtual block)', () async {
      final page = await repository.createPage('SpecialTitle');
      
      final results = await repository.searchPages('SpecialTitle');
      
      expect(results, isNotEmpty);
      expect(results.any((p) => p.pageId == page.pageId), isTrue);
    });
  });

  group('IsarBlockRepository - Tags', () {
    test('should automatically extract and associate tags from block content', () async {
      final page = await repository.createPage('Tag Page');
      
      // Create block with tag
      await repository.createBlock(page.pageId, content: 'Learning about #flutter and #dart');
      
      final retrievedPage = await repository.getPageByPageId(page.pageId);
      expect(retrievedPage, isNotNull);
      
      // Need to load links
      await retrievedPage!.tags.load();
      final tagNames = retrievedPage.tags.map((t) => t.name).toList();
      
      expect(tagNames, containsAll(['flutter', 'dart']));
    });

    test('should update tags when block content changes', () async {
      final page = await repository.createPage('Tag Update Page');
      final block = await repository.createBlock(page.pageId, content: 'Initial #tag1');
      
      block.content = 'Updated with #tag2';
      await repository.updateBlock(block);
      
      final retrievedPage = await repository.getPageByPageId(page.pageId);
      await retrievedPage!.tags.load();
      final tagNames = retrievedPage.tags.map((t) => t.name).toList();
      
      expect(tagNames, contains('tag2'));
      expect(tagNames, contains('tag1')); // Currently we don't remove old tags, which is acceptable for now
    });
  });
}
