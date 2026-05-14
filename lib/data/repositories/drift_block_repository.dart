import 'package:drift/drift.dart';
import 'package:nexusbrain/core/database/database.dart' as db;
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/block.dart';

class DriftBlockRepository {
  final db.NexusBrainDatabase _database;
  DriftBlockRepository(this._database);

  // ===================== PAGES =====================

  Future<List<domain.MdBombPage>> getAllPages() async {
    final driftPages = await _database.getAllPages();
    final pages = <domain.MdBombPage>[];
    for (final dp in driftPages) {
      final tags = await _database.getTagsForPage(dp.id);
      pages.add(domain.MdBombPage.fromDrift(dp, tags.map((t) => t.name).toList()));
    }
    return pages;
  }

  Future<domain.MdBombPage?> getPageById(String id) async {
    final dp = await _database.getPageById(id);
    if (dp == null) return null;
    final tags = await _database.getTagsForPage(id);
    return domain.MdBombPage.fromDrift(dp, tags.map((t) => t.name).toList());
  }

  Future<domain.MdBombPage> createPage(String title, {bool isJournal = false}) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    await _database.insertPage(db.PagesCompanion(
      id: Value(id),
      title: Value(title),
      isJournal: Value(isJournal),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return getPageById(id).then((p) => p!);
  }

  Future<domain.MdBombPage> updatePage(domain.MdBombPage page) async {
    await _database.updatePage(db.PagesCompanion(
      id: Value(page.id),
      title: Value(page.title),
      filePath: Value(page.filePath),
      isJournal: Value(page.isJournal),
      createdAt: Value(page.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
    return getPageById(page.id).then((p) => p!);
  }

  Future<void> deletePage(String id) async {
    await _database.deletePage(id);
  }

  Future<List<domain.MdBombPage>> searchPages(String query) async {
    final raw = await _database.searchPagesRaw(query);
    return raw.map((r) => domain.MdBombPage(
      id: r['id'] as String,
      title: r['title'] as String,
      filePath: r['file_path'] as String?,
      isJournal: r['is_journal'] as bool,
      createdAt: r['created_at'] as DateTime,
      updatedAt: r['updated_at'] as DateTime,
    )).toList();
  }

  // ===================== BLOCKS =====================

  Future<List<Block>> getBlocksForPage(String pageId) async {
    final driftBlocks = await _database.getBlocksForPage(pageId);
    return driftBlocks.map((b) => Block.fromDrift(b)).toList();
  }

  Future<List<Block>> getBlockTreeForPage(String pageId) async {
    final rootBlocks = await _database.getRootBlocksForPage(pageId);
    final tree = <Block>[];
    for (final root in rootBlocks) {
      tree.add(await _buildBlockTree(root));
    }
    return tree;
  }

  Future<Block> _buildBlockTree(db.Block driftBlock) async {
    final block = Block.fromDrift(driftBlock);
    final children = await _database.getChildBlocks(driftBlock.id);
    final childBlocks = <Block>[];
    for (final child in children) {
      childBlocks.add(await _buildBlockTree(child));
    }
    return block.copyWith(children: childBlocks);
  }

  Future<Block?> getBlockById(String id) async {
    final b = await _database.getBlockById(id);
    if (b == null) return null;
    return Block.fromDrift(b);
  }

  Future<Block> createBlock(String pageId, {
    String? parentId,
    String content = '',
    int? orderIndex,
    int indentLevel = 0,
  }) async {
    final now = DateTime.now();
    final id = '${pageId}_${now.millisecondsSinceEpoch}_${now.microsecond}';
    final idx = orderIndex ?? await _database.getNextOrderIndex(pageId);

    await _database.insertBlock(db.BlocksCompanion(
      id: Value(id),
      pageId: Value(pageId),
      parentId: Value(parentId),
      content: Value(content),
      orderIndex: Value(idx),
      indentLevel: Value(indentLevel),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return getBlockById(id).then((b) => b!);
  }

  Future<Block> updateBlock(Block block) async {
    await _database.updateBlock(db.BlocksCompanion(
      id: Value(block.id),
      pageId: Value(block.pageId),
      parentId: Value(block.parentId),
      content: Value(block.content),
      orderIndex: Value(block.orderIndex),
      indentLevel: Value(block.indentLevel),
      isCollapsed: Value(block.isCollapsed),
      taskState: Value(block.taskState),
      scheduledAt: Value(block.scheduledAt),
      deadlineAt: Value(block.deadlineAt),
      completedAt: Value(block.completedAt),
      createdAt: Value(block.createdAt),
      updatedAt: Value(DateTime.now()),
    ));
    return getBlockById(block.id).then((b) => b!);
  }

  Future<void> deleteBlock(String id) async {
    await _database.deleteBlock(id);
  }

  Future<void> moveBlock(String blockId, String? newParentId, int newOrderIndex) async {
    final block = await getBlockById(blockId);
    if (block == null) return;

    int newIndent = 0;
    if (newParentId != null) {
      final parent = await getBlockById(newParentId);
      if (parent != null) {
        newIndent = parent.indentLevel + 1;
      }
    }

    await _database.updateBlock(blockId, db.BlocksCompanion(
      parentId: Value(newParentId),
      orderIndex: Value(newOrderIndex),
      indentLevel: Value(newIndent),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> reorderBlocks(String pageId, List<String> blockIds) async {
    await _database.reorderBlocks(pageId, blockIds);
  }

  // ===================== LINKS =====================

  Future<List<PageLink>> getLinksForPage(String pageId) async {
    final driftLinks = await _database.getLinksForPage(pageId);
    return driftLinks.map((l) => PageLink.fromDrift(l)).toList();
  }

  Future<List<PageLink>> getBacklinksForPage(String pageId) async {
    final driftLinks = await _database.getBacklinksForPage(pageId);
    return driftLinks.map((l) => PageLink.fromDrift(l)).toList();
  }

  Future<void> createPageLink(String sourcePageId, String targetPageId, {String? sourceBlockId}) async {
    await _database.insertPageLink(db.PageLinksCompanion(
      sourcePageId: Value(sourcePageId),
      targetPageId: Value(targetPageId),
      sourceBlockId: Value(sourceBlockId),
      linkType: const Value('wikilink'),
      createdAt: Value(DateTime.now()),
    ));
  }

  Future<void> createBlockReference(String sourceBlockId, String targetBlockId) async {
    await _database.insertBlockReference(db.BlockReferencesCompanion(
      sourceBlockId: Value(sourceBlockId),
      targetBlockId: Value(targetBlockId),
      createdAt: Value(DateTime.now()),
    ));
  }

  // ===================== SEARCH =====================

  Future<List<Block>> searchBlocks(String query) async {
    final blockIds = await _database.searchBlockIds(query);
    final blocks = <Block>[];
    for (final id in blockIds) {
      final block = await getBlockById(id);
      if (block != null) blocks.add(block);
    }
    return blocks;
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

  factory PageLink.fromDrift(dynamic driftLink) {
    return PageLink(
      sourcePageId: driftLink.sourcePageId as String,
      targetPageId: driftLink.targetPageId as String,
      sourceBlockId: driftLink.sourceBlockId as String?,
      linkType: driftLink.linkType as String,
      createdAt: driftLink.createdAt as DateTime,
    );
  }
}


// ===================== TASK REPOSITORY =====================

class TaskRepository {
  final dynamic _database;
  final DriftBlockRepository _blocks;

  TaskRepository(this._database, this._blocks);

  Future<List<Block>> getOpenTasks() async {
    final db = _database;
    return db.getOpenTasks();
  }

  Future<List<Block>> getTasksByState(String state) => _database.getTasksByState(state);
  Future<List<Block>> getOverdueTasks() => _database.getOverdueTasks();
  Future<List<Block>> getTodayTasks() => _database.getTodayTasks();
  Future<List<Block>> getCompletedTasks({DateTime? since}) => _database.getCompletedTasks(since: since);
  Future<List<Block>> searchTasks(String query) => _database.searchTasks(query);

  Future<Block> createTask(String pageId, String content, {String state = 'TODO'}) async {
    final block = await _blocks.createBlock(pageId, content: content);
    return _blocks.updateBlock(block.copyWith(taskState: state));
  }

  Future<Block> updateTaskState(String blockId, String? newState) async {
    final block = await _blocks.getBlockById(blockId);
    if (block == null) throw Exception('Block not found: $blockId');
    final completedAt = newState == 'DONE' ? DateTime.now() : null;
    return _blocks.updateBlock(block.copyWith(
      taskState: newState,
      completedAt: completedAt,
    ));
  }

  Future<Block> cycleTaskState(String blockId) async {
    final block = await _blocks.getBlockById(blockId);
    if (block == null) throw Exception('Block not found: $blockId');
    final nextState = _getNextTaskState(block.taskState);
    return updateTaskState(blockId, nextState);
  }

  String? _getNextTaskState(String? current) {
    switch (current) {
      case 'TODO': return 'DOING';
      case 'DOING': return 'DONE';
      case 'DONE': return 'TODO';
      case 'CANCELLED': return 'TODO';
      default: return 'TODO';
    }
  }
}
