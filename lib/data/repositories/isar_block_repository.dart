import 'package:isar_community/isar.dart';
import '../../core/database/isar_service.dart';
import '../../domain/models/block.dart';
import '../../domain/models/page.dart';
import '../../domain/models/tag.dart';

class IsarBlockRepository {
  Future<Isar> get _db => IsarService.instance;

  // ===================== PAGES =====================

  Future<List<Page>> getAllPages() async {
    final db = await _db;
    return db.pages.where().sortByUpdatedAtDesc().findAll();
  }

  Future<Page?> getPageByPageId(String pageId) async {
    final db = await _db;
    return db.pages.filter().pageIdEqualTo(pageId).findFirst();
  }

  Future<Page> createPage(String title, {bool isJournal = false}) async {
    final db = await _db;
    final now = DateTime.now();
    final page = Page(
      pageId: now.millisecondsSinceEpoch.toString(),
      title: title,
      isJournal: isJournal,
      createdAt: now,
      updatedAt: now,
    );
    await db.writeTxn(() async {
      await db.pages.put(page);
    });
    return page;
  }

  Future<Page> updatePage(Page page) async {
    final db = await _db;
    page.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.pages.put(page);
    });
    return page;
  }

  Future<void> deletePage(String pageId) async {
    final db = await _db;
    final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (page != null) {
      await db.writeTxn(() async {
        await db.blocks.filter().pageIdEqualTo(pageId).deleteAll();
        await db.pages.delete(page.id);
      });
    }
  }

  Future<List<Page>> searchPages(String query) async {
    final db = await _db;
    final lowerQuery = query.toLowerCase();
    return db.pages
        .filter()
        .titleContains(lowerQuery, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .findAll();
  }

  // ===================== BLOCKS =====================

  Future<List<Block>> getBlocksForPage(String pageId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .sortByOrderIndex()
        .findAll();
  }

  Future<List<Block>> getRootBlocksForPage(String pageId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .parentIdIsNull()
        .sortByOrderIndex()
        .findAll();
  }

  Future<List<Block>> getChildBlocks(String parentId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .parentIdEqualTo(parentId)
        .sortByOrderIndex()
        .findAll();
  }

  Future<List<Block>> getBlockTreeForPage(String pageId) async {
    return getBlocksForPage(pageId);
  }

  Future<Block?> getBlockByBlockId(String blockId) async {
    final db = await _db;
    return db.blocks.filter().blockIdEqualTo(blockId).findFirst();
  }

  Future<Block> createBlock(
    String pageId, {
    String? parentId,
    String content = '',
    int? orderIndex,
    int indentLevel = 0,
  }) async {
    final db = await _db;
    final now = DateTime.now();
    final idx = orderIndex ?? await _getNextOrderIndex(pageId);
    final block = Block(
      blockId: '${pageId}_${now.millisecondsSinceEpoch}_${now.microsecond}',
      pageId: pageId,
      parentId: parentId,
      content: content,
      orderIndex: idx,
      indentLevel: indentLevel,
      createdAt: now,
      updatedAt: now,
    );
    await db.writeTxn(() async {
      await db.blocks.put(block);
      final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
      if (page != null) {
        page.updatedAt = now;
        await db.pages.put(page);
      }
    });
    return block;
  }

  Future<Block> updateBlock(Block block) async {
    final db = await _db;
    block.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.blocks.put(block);
    });
    return block;
  }

  Future<void> deleteBlock(String blockId) async {
    final db = await _db;
    final block =
        await db.blocks.filter().blockIdEqualTo(blockId).findFirst();
    if (block != null) {
      await db.writeTxn(() async {
        await db.blocks.delete(block.id);
      });
    }
  }

  Future<int> _getNextOrderIndex(String pageId) async {
    final db = await _db;
    final blocks = await db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .sortByOrderIndexDesc()
        .findAll();
    if (blocks.isEmpty) return 0;
    return blocks.first.orderIndex + 1;
  }

  Future<void> reorderBlocks(String pageId, List<String> blockIds) async {
    final db = await _db;
    await db.writeTxn(() async {
      for (int i = 0; i < blockIds.length; i++) {
        final block = await db.blocks
            .filter()
            .blockIdEqualTo(blockIds[i])
            .findFirst();
        if (block != null) {
          block.orderIndex = i;
          await db.blocks.put(block);
        }
      }
    });
  }

  // ===================== TASKS =====================

  Future<List<Block>> getOpenTasks() async {
    final db = await _db;
    return db.blocks
        .filter()
        .taskStateEqualTo('TODO')
        .or()
        .taskStateEqualTo('DOING')
        .sortByCreatedAt()
        .findAll();
  }

  Future<List<Block>> getTasksByState(String state) async {
    final db = await _db;
    return db.blocks
        .filter()
        .taskStateEqualTo(state)
        .sortByCreatedAt()
        .findAll();
  }

  Future<List<Block>> getOverdueTasks() async {
    final db = await _db;
    final now = DateTime.now();
    return db.blocks
        .filter()
        .taskStateEqualTo('TODO')
        .or()
        .taskStateEqualTo('DOING')
        .deadlineAtIsNotNull()
        .deadlineAtLessThan(now)
        .sortByDeadlineAt()
        .findAll();
  }

  Future<List<Block>> getTodayTasks() async {
    final db = await _db;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return db.blocks
        .filter()
        .taskStateEqualTo('TODO')
        .or()
        .taskStateEqualTo('DOING')
        .scheduledAtIsNotNull()
        .scheduledAtGreaterThan(startOfDay)
        .scheduledAtLessThan(endOfDay)
        .sortByScheduledAt()
        .findAll();
  }

  Future<List<Block>> getCompletedTasks({DateTime? since}) async {
    final db = await _db;
    if (since != null) {
      return db.blocks
          .filter()
          .taskStateEqualTo('DONE')
          .completedAtIsNotNull()
          .completedAtGreaterThan(since)
          .sortByCompletedAtDesc()
          .findAll();
    }
    return db.blocks
        .filter()
        .taskStateEqualTo('DONE')
        .sortByCompletedAtDesc()
        .findAll();
  }

  Future<List<Block>> searchTasks(String query) async {
    final db = await _db;
    final lowerQuery = query.toLowerCase();
    return db.blocks
        .filter()
        .taskStateIsNotNull()
        .contentContains(lowerQuery, caseSensitive: false)
        .sortByCreatedAt()
        .findAll();
  }

  // ===================== SEARCH =====================

  Future<List<Block>> searchBlocks(String query) async {
    final db = await _db;
    final lowerQuery = query.toLowerCase();
    return db.blocks
        .filter()
        .contentContains(lowerQuery, caseSensitive: false)
        .findAll();
  }

  Future<List<String>> searchBlockIds(String query) async {
    final blocks = await searchBlocks(query);
    return blocks.map((b) => b.blockId).toList();
  }

  Future<List<Map<String, dynamic>>> searchPagesRaw(String query) async {
    final pages = await searchPages(query);
    return pages
        .map((p) => {
              'id': p.pageId,
              'title': p.title,
              'file_path': p.filePath,
              'is_journal': p.isJournal,
              'created_at': p.createdAt,
              'updated_at': p.updatedAt,
            })
        .toList();
  }

  // ===================== LINKS =====================

  Future<List<PageLink>> getLinksForPage(String pageId) async {
    final db = await _db;
    final blocks = await db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .contentContains('[[')
        .findAll();
    final links = <PageLink>[];
    for (final block in blocks) {
      for (final title in block.linkedPageTitles) {
        final targetPage =
            await db.pages.filter().titleEqualTo(title).findFirst();
        if (targetPage != null) {
          links.add(PageLink(
            sourcePageId: pageId,
            targetPageId: targetPage.pageId,
            sourceBlockId: block.blockId,
            linkType: 'wikilink',
            createdAt: block.createdAt ?? DateTime.now(),
          ));
        }
      }
    }
    return links;
  }

  Future<List<PageLink>> getBacklinksForPage(String pageId) async {
    final db = await _db;
    final targetPage =
        await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (targetPage == null) return [];
    final allBlocks = await db.blocks.where().findAll();
    final links = <PageLink>[];
    for (final block in allBlocks) {
      if (block.linkedPageTitles.contains(targetPage.title)) {
        links.add(PageLink(
          sourcePageId: block.pageId,
          targetPageId: pageId,
          sourceBlockId: block.blockId,
          linkType: 'wikilink',
          createdAt: block.createdAt ?? DateTime.now(),
        ));
      }
    }
    return links;
  }

  Future<void> createPageLink(String sourcePageId, String targetPageId,
      {String? sourceBlockId}) async {
    // Links are derived from [[wikilink]] syntax in block content
  }

  Future<void> createBlockReference(
      String sourceBlockId, String targetBlockId) async {
    // References are derived from ((block-id)) syntax in block content
  }

  // ===================== TAGS =====================

  Future<List<Tag>> getAllTags() async {
    final db = await _db;
    return db.tags.where().findAll();
  }

  Future<Tag> createTag(String name, {String? color}) async {
    final db = await _db;
    final tag = Tag(name: name, color: color);
    await db.writeTxn(() async {
      await db.tags.put(tag);
    });
    return tag;
  }

  Future<List<Tag>> getTagsForPage(String pageId) async {
    final db = await _db;
    final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (page == null) return [];
    await page.tags.load();
    return page.tags.toList();
  }

  Future<void> addTagToPage(String pageId, String tagName) async {
    final db = await _db;
    final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (page == null) return;
    var tag = await db.tags.filter().nameEqualTo(tagName).findFirst();
    tag ??= await createTag(tagName);
    await db.writeTxn(() async {
      page.tags.add(tag!);
      await page.tags.save();
    });
  }
}

class PageLink {
  final String sourcePageId;
  final String targetPageId;
  final String? sourceBlockId;
  final String linkType;
  final DateTime createdAt;

  PageLink({
    required this.sourcePageId,
    required this.targetPageId,
    this.sourceBlockId,
    required this.linkType,
    required this.createdAt,
  });
}
