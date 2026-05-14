import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ===================== TABLES =====================

/// Pages are the top-level containers (like Logseq pages).
/// Each page has a title and contains multiple blocks.
class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get filePath => text().nullable()();
  BoolColumn get isJournal => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Blocks are the fundamental content units (like Logseq blocks).
/// Each block belongs to a page and can have a parent block (for nesting).
/// Blocks can also be tasks with TODO/DOING/DONE states.
class Blocks extends Table {
  TextColumn get id => text()();
  TextColumn get pageId => text().references(Pages, #id, onDelete: KeyAction.cascade)();
  TextColumn get parentId => text().nullable().references(Blocks, #id, onDelete: KeyAction.setNull)();
  TextColumn get content => text().withDefault(const Constant(''))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  IntColumn get indentLevel => integer().withDefault(const Constant(0))();
  BoolColumn get isCollapsed => boolean().withDefault(const Constant(false))();
  // Task management
  TextColumn get taskState => text().nullable()(); // 'TODO', 'DOING', 'DONE', 'CANCELLED', null
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  DateTimeColumn get deadlineAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tags for pages
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class PageTags extends Table {
  TextColumn get pageId => text().references(Pages, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId => text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {pageId, tagId};
}

/// Links between pages (page-level links like [[Page Title]])
class PageLinks extends Table {
  TextColumn get sourcePageId => text().references(Pages, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetPageId => text().references(Pages, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceBlockId => text().nullable().references(Blocks, #id, onDelete: KeyAction.setNull)();
  TextColumn get linkType => text().withDefault(const Constant('wikilink'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {sourcePageId, targetPageId, sourceBlockId};
}

/// Block references ((block-id))
class BlockReferences extends Table {
  TextColumn get sourceBlockId => text().references(Blocks, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetBlockId => text().references(Blocks, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {sourceBlockId, targetBlockId};
}

// ===================== DATABASE =====================

@DriftDatabase(tables: [Pages, Blocks, Tags, PageTags, PageLinks, BlockReferences])
class NexusBrainDatabase extends _$NexusBrainDatabase {
  NexusBrainDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Migrated from v1 (Notes) to v2 (Pages + Blocks)

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE VIRTUAL TABLE IF NOT EXISTS blocks_fts USING fts5(block_id, content)',
      );
      await customStatement(
        'CREATE TRIGGER IF NOT EXISTS blocks_ai AFTER INSERT ON blocks BEGIN '
        'INSERT INTO blocks_fts(block_id, content) VALUES (new.id, new.content); '
        'END',
      );
      await customStatement(
        'CREATE TRIGGER IF NOT EXISTS blocks_ad AFTER DELETE ON blocks BEGIN '
        'INSERT INTO blocks_fts(blocks_fts, block_id, content) VALUES(\'delete\', old.id, old.content); '
        'END',
      );
      await customStatement(
        'CREATE TRIGGER IF NOT EXISTS blocks_au AFTER UPDATE ON blocks BEGIN '
        'INSERT INTO blocks_fts(blocks_fts, block_id, content) VALUES(\'delete\', old.id, old.content); '
        'INSERT INTO blocks_fts(block_id, content) VALUES (new.id, new.content); '
        'END',
      );
    },
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        // Migrate from Notes to Pages + Blocks
        await m.createTable(pages);
        await m.createTable(blocks);
        await m.createTable(pageLinks);
        await m.createTable(blockReferences);
        // Migrate existing notes
        final oldNotes = await customSelect('SELECT * FROM notes').get();
        for (final row in oldNotes) {
          final noteId = row.read<String>('id');
          final title = row.read<String>('title');
          final content = row.read<String?>('content') ?? '';
          final filePath = row.read<String?>('file_path');
          final createdAt = row.read<DateTime>('created_at');
          final updatedAt = row.read<DateTime>('updated_at');

          await into(pages).insert(PagesCompanion(
            id: Value(noteId),
            title: Value(title),
            filePath: Value(filePath),
            createdAt: Value(createdAt),
            updatedAt: Value(updatedAt),
          ));

          if (content.isNotEmpty) {
            await into(blocks).insert(BlocksCompanion(
              id: Value('${noteId}_block_0'),
              pageId: Value(noteId),
              content: Value(content),
              orderIndex: const Value(0),
              indentLevel: const Value(0),
              createdAt: Value(createdAt),
              updatedAt: Value(updatedAt),
            ));
          }
        }
        // Drop old tables
        await customStatement('DROP TABLE IF EXISTS note_tags');
        await customStatement('DROP TABLE IF EXISTS note_topics');
        await customStatement('DROP TABLE IF EXISTS note_links');
        await customStatement('DROP TABLE IF EXISTS notes_fts');
        await customStatement('DROP TABLE IF EXISTS notes');
        await customStatement('DROP TABLE IF EXISTS topics');
        // Rename tags table if it exists
        await customStatement('ALTER TABLE tags RENAME TO tags_old');
        await m.createTable(tags);
        await customStatement('INSERT OR IGNORE INTO tags SELECT * FROM tags_old');
        await customStatement('DROP TABLE IF EXISTS tags_old');
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'nexusbrain');
  }

  // ===================== PAGE QUERIES =====================

  Future<List<Page>> getAllPages() => (select(pages)
    ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)])).get();

  Future<Page?> getPageById(String id) =>
      (select(pages)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> insertPage(PagesCompanion page) => into(pages).insert(page);
  Future<bool> updatePage(PagesCompanion page) => update(pages).replace(page);
  Future<int> deletePage(String id) =>
      (delete(pages)..where((p) => p.id.equals(id))).go();

  Future<List<Map<String, dynamic>>> searchPagesRaw(String query) async {
    final result = await customSelect(
      'SELECT DISTINCT p.* FROM pages p '
      'LEFT JOIN blocks b ON b.page_id = p.id '
      'LEFT JOIN blocks_fts fts ON fts.block_id = b.id '
      'WHERE p.title LIKE ? OR fts.blocks_fts MATCH ? '
      'ORDER BY p.updated_at DESC',
      variables: [Variable<String>('%$query%'), Variable<String>(query)],
    ).get();
    return result.map((row) => {
      'id': row.read<String>('id'),
      'title': row.read<String>('title'),
      'file_path': row.read<String?>('file_path'),
      'is_journal': row.read<bool>('is_journal'),
      'created_at': row.read<DateTime>('created_at'),
      'updated_at': row.read<DateTime>('updated_at'),
    }).toList();
  }

  // ===================== BLOCK QUERIES =====================

  Future<List<Block>> getBlocksForPage(String pageId) => (select(blocks)
    ..where((b) => b.pageId.equals(pageId))
    ..orderBy([(b) => OrderingTerm.asc(b.orderIndex)])).get();

  Future<List<Block>> getRootBlocksForPage(String pageId) => (select(blocks)
    ..where((b) => b.pageId.equals(pageId) & b.parentId.isNull())
    ..orderBy([(b) => OrderingTerm.asc(b.orderIndex)])).get();

  Future<List<Block>> getChildBlocks(String parentId) => (select(blocks)
    ..where((b) => b.parentId.equals(parentId))
    ..orderBy([(b) => OrderingTerm.asc(b.orderIndex)])).get();

  Future<Block?> getBlockById(String id) =>
      (select(blocks)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBlock(BlocksCompanion block) => into(blocks).insert(block);
  Future<int> updateBlock(BlocksCompanion block) async {
    return customUpdate(
      'UPDATE blocks SET page_id = ?, parent_id = ?, content = ?, order_index = ?, '
      'indent_level = ?, is_collapsed = ?, task_state = ?, scheduled_at = ?, '
      'deadline_at = ?, completed_at = ?, created_at = ?, updated_at = ? '
      'WHERE id = ?',
      variables: <Variable<Object>>[
        Variable<Object>(block.pageId.value),
        Variable<Object>(block.parentId.value),
        Variable<Object>(block.content.value),
        Variable<Object>(block.orderIndex.value),
        Variable<Object>(block.indentLevel.value),
        Variable<Object>(block.isCollapsed.value),
        Variable<Object>(block.taskState.value),
        Variable<Object>(block.scheduledAt.value),
        Variable<Object>(block.deadlineAt.value),
        Variable<Object>(block.completedAt.value),
        Variable<Object>(block.createdAt.value),
        Variable<Object>(block.updatedAt.value),
        Variable<Object>(block.id.value),
      ],
      updates: {blocks},
    );
  }
  Future<int> deleteBlock(String id) =>
      (delete(blocks)..where((b) => b.id.equals(id))).go();

  Future<void> deleteBlocksForPage(String pageId) =>
      (delete(blocks)..where((b) => b.pageId.equals(pageId))).go();

  Future<int> getNextOrderIndex(String pageId) async {
    final result = await customSelect(
      'SELECT MAX(order_index) as max_idx FROM blocks WHERE page_id = ?',
      variables: [Variable<String>(pageId)],
    ).getSingle();
    final maxIdx = result.read<int?>('max_idx') ?? -1;
    return maxIdx + 1;
  }

  Future<void> reorderBlocks(String pageId, List<String> blockIds) async {
    for (int i = 0; i < blockIds.length; i++) {
      await (update(blocks)..where((b) => b.id.equals(blockIds[i])))
          .write(BlocksCompanion(orderIndex: Value(i)));
    }
  }

  // ===================== TASK QUERIES =====================

  /// Get all open tasks (TODO + DOING) across all pages
  Future<List<Block>> getOpenTasks() => (select(blocks)
    ..where((b) => b.taskState.isIn(['TODO', 'DOING']))
    ..orderBy([(b) => OrderingTerm.asc(b.createdAt)])).get();

  /// Get tasks by state
  Future<List<Block>> getTasksByState(String state) => (select(blocks)
    ..where((b) => b.taskState.equals(state))
    ..orderBy([(b) => OrderingTerm.asc(b.createdAt)])).get();

  /// Get tasks for a specific page
  Future<List<Block>> getTasksForPage(String pageId) => (select(blocks)
    ..where((b) => b.pageId.equals(pageId) & b.taskState.isNotNull())
    ..orderBy([(b) => OrderingTerm.asc(b.orderIndex)])).get();

  /// Get overdue tasks (deadline in the past, not completed)
  Future<List<Block>> getOverdueTasks() async {
    final now = DateTime.now();
    return (select(blocks)
      ..where((b) => b.taskState.isIn(['TODO', 'DOING']) &
          b.deadlineAt.isNotNull() &
          b.deadlineAt.isSmallerThanValue(now))
      ..orderBy([(b) => OrderingTerm.asc(b.deadlineAt)])).get();
  }

  /// Get tasks scheduled for today
  Future<List<Block>> getTodayTasks() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(blocks)
      ..where((b) => b.taskState.isIn(['TODO', 'DOING']) &
          b.scheduledAt.isNotNull() &
          b.scheduledAt.isBiggerOrEqualValue(startOfDay) &
          b.scheduledAt.isSmallerThanValue(endOfDay))
      ..orderBy([(b) => OrderingTerm.asc(b.scheduledAt)])).get();
  }

  /// Get completed tasks (optionally filtered by date range)
  Future<List<Block>> getCompletedTasks({DateTime? since}) async {
    if (since != null) {
      return (select(blocks)
        ..where((b) => b.taskState.equals('DONE') &
            b.completedAt.isNotNull() &
            b.completedAt.isBiggerOrEqualValue(since))
        ..orderBy([(b) => OrderingTerm.desc(b.completedAt)])).get();
    }
    return (select(blocks)
      ..where((b) => b.taskState.equals('DONE'))
      ..orderBy([(b) => OrderingTerm.desc(b.completedAt)])).get();
  }

  /// Search tasks by content
  Future<List<Block>> searchTasks(String query) async {
    final result = await customSelect(
      'SELECT b.* FROM blocks b '
      'INNER JOIN blocks_fts fts ON fts.block_id = b.id '
      'WHERE fts.blocks_fts MATCH ? AND b.task_state IS NOT NULL '
      'ORDER BY b.created_at DESC',
      variables: [Variable<String>(query)],
    ).get();
    return result.map((row) => Block(
      id: row.read<String>('id'),
      pageId: row.read<String>('page_id'),
      parentId: row.read<String?>('parent_id'),
      content: row.read<String?>('content') ?? '',
      orderIndex: row.read<int>('order_index'),
      indentLevel: row.read<int>('indent_level'),
      isCollapsed: row.read<bool>('is_collapsed'),
      taskState: row.read<String?>('task_state'),
      scheduledAt: row.read<DateTime?>('scheduled_at'),
      deadlineAt: row.read<DateTime?>('deadline_at'),
      completedAt: row.read<DateTime?>('completed_at'),
      createdAt: row.read<DateTime>('created_at'),
      updatedAt: row.read<DateTime>('updated_at'),
    )).toList();
  }

  // ===================== TAG QUERIES =====================

  Future<List<Tag>> getAllTags() => select(tags).get();
  Future<int> insertTag(Tag tag) => into(tags).insert(tag, mode: InsertMode.insertOrIgnore);
  Future<int> insertPageTag(PageTagsCompanion pt) =>
      into(pageTags).insert(pt, mode: InsertMode.insertOrIgnore);

  Future<List<Tag>> getTagsForPage(String pageId) async {
    final query = select(tags).join([
      innerJoin(pageTags, pageTags.tagId.equalsExp(tags.id)),
    ])..where(pageTags.pageId.equals(pageId));
    final result = await query.get();
    return result.map((row) => row.readTable(tags)).toList();
  }

  // ===================== LINK QUERIES =====================

  Future<List<PageLink>> getLinksForPage(String pageId) =>
      (select(pageLinks)..where((l) => l.sourcePageId.equals(pageId))).get();

  Future<List<PageLink>> getBacklinksForPage(String pageId) =>
      (select(pageLinks)..where((l) => l.targetPageId.equals(pageId))).get();

  Future<int> insertPageLink(PageLinksCompanion link) =>
      into(pageLinks).insert(link, mode: InsertMode.insertOrReplace);

  Future<int> deletePageLink(String sourceId, String targetId) =>
      (delete(pageLinks)..where((l) => l.sourcePageId.equals(sourceId) & l.targetPageId.equals(targetId))).go();

  // ===================== BLOCK REFERENCE QUERIES =====================

  Future<List<BlockReference>> getBlockReferences(String blockId) =>
      (select(blockReferences)..where((r) => r.sourceBlockId.equals(blockId))).get();

  Future<List<BlockReference>> getBlockBacklinks(String blockId) =>
      (select(blockReferences)..where((r) => r.targetBlockId.equals(blockId))).get();

  Future<int> insertBlockReference(BlockReferencesCompanion ref) =>
      into(blockReferences).insert(ref, mode: InsertMode.insertOrReplace);

  // ===================== FULL-TEXT SEARCH =====================

  Future<List<String>> searchBlockIds(String query) async {
    final result = await customSelect(
      'SELECT block_id FROM blocks_fts WHERE blocks_fts MATCH ?',
      variables: [Variable<String>(query)],
    ).get();
    return result.map((row) => row.read<String>('block_id')).toList();
  }
}
