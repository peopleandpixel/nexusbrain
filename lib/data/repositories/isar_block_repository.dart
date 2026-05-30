import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../../core/ai/embedding_service.dart';
import '../../core/database/fts_service.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/query_engine.dart';
import '../../domain/models/block.dart';
import '../../domain/models/page.dart';
import '../../domain/models/tag.dart';
import '../../domain/models/template.dart';

/// Repository für den Zugriff auf [Block], [Page] und [Tag] Objekte in der Isar-Datenbank.
///
/// Diese Klasse bietet Methoden zum Erstellen, Lesen, Aktualisieren und Löschen (CRUD)
/// von Daten sowie spezielle Abfragen wie die Suche über FTS5.
class IsarBlockRepository {
  final Isar? isar;
  QueryEngine? _queryEngine;

  IsarBlockRepository({this.isar});

  /// Gibt die aktuelle Isar-Datenbankinstanz zurück.
  Future<Isar> get _db async => isar ?? await IsarService.instance;

  Future<QueryEngine> get _qe async {
    if (_queryEngine != null) return _queryEngine!;
    _queryEngine = QueryEngine(await _db);
    return _queryEngine!;
  }

  // ===================== PAGES =====================

  /// Ruft alle verfügbaren Seiten ab, sortiert nach dem letzten Änderungsdatum absteigend.
  Future<List<Page>> getAllPages() async {
    final db = await _db;
    return db.pages.where().sortByUpdatedAtDesc().findAll();
  }

  /// Sucht eine Seite anhand ihrer eindeutigen [pageId].
  Future<Page?> getPageByPageId(String pageId) async {
    final db = await _db;
    return db.pages.filter().pageIdEqualTo(pageId).findFirst();
  }

  /// Sucht eine Journal-Seite für ein spezifisches [date].
  ///
  /// Eine Journal-Seite ist eine spezielle Seite, die für einen bestimmten Tag erstellt wurde.
  Future<Page?> getJournalPageForDate(DateTime date) async {
    final db = await _db;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return db.pages
        .filter()
        .isJournalEqualTo(true)
        .createdAtBetween(startOfDay, endOfDay)
        .findFirst();
  }

  /// Erstellt eine neue Seite mit dem angegebenen [title].
  ///
  /// Falls [isJournal] auf `true` gesetzt ist, wird die Seite als Journal-Seite markiert.
  /// Der Titel der Seite wird automatisch in den FTS-Suchindex synchronisiert.
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
    // Sync the page title to FTS as a "virtual block"
    await FtsService.syncBlock('page_${page.pageId}', page.pageId, page.title);
    return page;
  }

  /// Aktualisiert eine bestehende [page] in der Datenbank.
  ///
  /// Aktualisiert das [updatedAt] Feld und synchronisiert den Titel mit dem FTS-Index.
  Future<Page> updatePage(Page page) async {
    final db = await _db;
    page.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.pages.put(page);
    });
    // Sync the page title to FTS as a "virtual block"
    await FtsService.syncBlock('page_${page.pageId}', page.pageId, page.title);
    return page;
  }

  /// Verknüpft einen PDF-Pfad mit einer Seite.
  Future<Page> updatePagePdf(String pageId, String? pdfPath) async {
    final db = await _db;
    final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (page == null) throw Exception('Page not found');
    
    page.pdfPath = pdfPath;
    page.updatedAt = DateTime.now();
    
    await db.writeTxn(() async {
      await db.pages.put(page);
    });
    return page;
  }

  /// Löscht eine Seite und alle zugehörigen Blöcke anhand der [pageId].
  ///
  /// Entfernt die Seite auch aus dem FTS-Suchindex.
  Future<void> deletePage(String pageId) async {
    final db = await _db;
    final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
    if (page != null) {
      await db.writeTxn(() async {
        await db.blocks.filter().pageIdEqualTo(pageId).deleteAll();
        await db.pages.delete(page.id);
      });
      await FtsService.deletePage(pageId);
    }
  }

  /// Sucht nach Seiten, die den [query] String enthalten.
  ///
  /// Die Suche erfolgt über den FTS-Index (Volltextsuche) sowohl in Seitentiteln
  /// als auch in Blockinhalten.
  Future<List<Page>> searchPages(String query) async {
    final db = await _db;
    
    // FTS Search for everything (blocks and virtual page title blocks)
    final ftsResults = await searchBlocks(query);
    final pageIdsFromFts = ftsResults.map((b) => b.pageId).toSet();
    
    if (pageIdsFromFts.isEmpty) return [];
    
    return db.pages.filter()
        .anyOf(pageIdsFromFts.toList(), (q, String id) => q.pageIdEqualTo(id))
        .sortByUpdatedAtDesc()
        .findAll();
  }

  // ===================== ADVANCED QUERY =====================

  /// Führt eine fortgeschrittene Abfrage über die [QueryEngine] aus.
  /// 
  /// Unterstützt strukturierte Abfragen (Map) oder String-basierte Abfragen.
  Future<List<Block>> executeQuery(dynamic query) async {
    final qe = await _qe;
    if (query is String) {
      return qe.executeStringQuery(query);
    } else if (query is Map<String, dynamic>) {
      return qe.findBlocks(query);
    } else {
      throw ArgumentError('Query must be either String or Map<String, dynamic>');
    }
  }

  // ===================== BLOCKS =====================

  /// Ruft alle Blöcke einer Seite ab, sortiert nach ihrem [orderIndex].
  Future<List<Block>> getBlocksForPage(String pageId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .sortByOrderIndex()
        .findAll();
  }

  /// Ruft nur die Wurzel-Blöcke (Blöcke ohne [parentId]) einer Seite ab.
  Future<List<Block>> getRootBlocksForPage(String pageId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .pageIdEqualTo(pageId)
        .parentIdIsNull()
        .sortByOrderIndex()
        .findAll();
  }

  /// Ruft die direkten Kind-Blöcke eines Blocks ab.
  Future<List<Block>> getChildBlocks(String parentId) async {
    final db = await _db;
    return db.blocks
        .filter()
        .parentIdEqualTo(parentId)
        .sortByOrderIndex()
        .findAll();
  }

  /// Ruft alle Blöcke einer Seite ab (linearisiert).
  Future<List<Block>> getBlockTreeForPage(String pageId) async {
    return getBlocksForPage(pageId);
  }

  /// Sucht einen Block anhand seiner eindeutigen [blockId].
  Future<Block?> getBlockByBlockId(String blockId) async {
    final db = await _db;
    return db.blocks.filter().blockIdEqualTo(blockId).findFirst();
  }

  /// Erstellt einen neuen Block für eine Seite.
  ///
  /// [pageId] ist die ID der Seite, zu der der Block gehört.
  /// [parentId] kann optional angegeben werden, um den Block als Kind eines anderen Blocks zu erstellen.
  /// [content] ist der Textinhalt des Blocks.
  /// [orderIndex] bestimmt die Position des Blocks in der Liste. Falls null, wird der Block am Ende angehängt.
  /// [indentLevel] bestimmt die Einrückungsebene des Blocks.
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
    
    // Trigger onBlockCreate hook
    // Note: We don't have easy access to PluginManager here without ref
    // But since this is a repository, we might want to inject it or use a service
    
    await db.writeTxn(() async {
      await db.blocks.put(block);
      final page = await db.pages.filter().pageIdEqualTo(pageId).findFirst();
      if (page != null) {
        page.updatedAt = now;
        await db.pages.put(page);
      }
    });
    
    // Extract and sync tags
    await _syncTagsForBlock(block);

    await FtsService.syncBlock(block.blockId, block.pageId, block.content);
    
    // Berechne Embedding asynchron (optional: im Hintergrund)
    await _updateBlockEmbedding(block.blockId, block.content);
    
    return block;
  }

  Future<void> _syncTagsForBlock(Block block) async {
    final tags = _extractTags(block.content);
    if (tags.isEmpty) return;
    
    for (final tagName in tags) {
      await addTagToPage(block.pageId, tagName);
    }
  }

  List<String> _extractTags(String content) {
    final regExp = RegExp(r'#(\w+)');
    final matches = regExp.allMatches(content);
    return matches.map((m) => m.group(1)!).toSet().toList();
  }

  Future<void> _updateBlockEmbedding(String blockId, String content) async {
    if (content.trim().isEmpty) return;
    try {
      final embedding = await EmbeddingService.instance.getEmbedding(content);
      final db = await _db;
      final block = await db.blocks.filter().blockIdEqualTo(blockId).findFirst();
      if (block != null) {
        block.embedding = embedding;
        await db.writeTxn(() async {
          await db.blocks.put(block);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating embedding: $e');
      }
    }
  }

  /// Aktualisiert einen bestehenden [block].
  ///
  /// Setzt [updatedAt] auf den aktuellen Zeitpunkt und synchronisiert den Inhalt mit FTS.
  Future<Block> updateBlock(Block block) async {
    final db = await _db;
    block.updatedAt = DateTime.now();
    await db.writeTxn(() async {
      await db.blocks.put(block);
    });

    // Extract and sync tags
    await _syncTagsForBlock(block);

    await FtsService.syncBlock(block.blockId, block.pageId, block.content);
    
    // Berechne Embedding asynchron
    await _updateBlockEmbedding(block.blockId, block.content);
    
    return block;
  }

  /// Initialisiert alle fehlenden Embeddings für bestehende Blöcke.
  Future<void> computeMissingEmbeddings() async {
    final db = await _db;
    final blocks = await db.blocks.filter().embeddingIsNull().findAll();
    for (final block in blocks) {
      if (block.content.trim().isNotEmpty) {
        await _updateBlockEmbedding(block.blockId, block.content);
      }
    }
  }

  /// Löscht einen Block anhand seiner [blockId] aus der Datenbank und dem FTS-Index.
  Future<void> deleteBlock(String blockId) async {
    final db = await _db;
    final block =
        await db.blocks.filter().blockIdEqualTo(blockId).findFirst();
    if (block != null) {
      await db.writeTxn(() async {
        await db.blocks.delete(block.id);
      });
      await FtsService.deleteBlock(blockId);
    }
  }

  /// Berechnet den nächsten verfügbaren [orderIndex] für eine Seite.
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

  /// Aktualisiert die Reihenfolge der Blöcke basierend auf einer Liste von [blockIds].
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

  /// Ruft alle offenen Aufgaben (Status 'TODO' oder 'DOING') ab.
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

  /// Ruft alle Aufgaben mit einem spezifischen [state] ab.
  Future<List<Block>> getTasksByState(String state) async {
    final db = await _db;
    return db.blocks
        .filter()
        .taskStateEqualTo(state)
        .sortByCreatedAt()
        .findAll();
  }

  /// Ruft alle Aufgaben ab, deren Frist ([deadlineAt]) überschritten ist.
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

  /// Ruft Aufgaben ab, die für den heutigen Tag geplant sind.
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

  /// Ruft abgeschlossene Aufgaben (Status 'DONE') ab.
  ///
  /// Optional kann ein Zeitraum [since] angegeben werden.
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

  /// Durchsucht Aufgaben nach einem [query] String.
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

  /// Initialisiert den FTS-Suchindex mit allen existierenden Blöcken und Seitentiteln.
  ///
  /// Diese Methode sollte beim ersten Start oder bei einer Index-Wiederherstellung aufgerufen werden.
  Future<void> initializeFts() async {
    final db = await _db;
    
    // Check if we already have data in FTS (simplified check)
    final ftsResults = await FtsService.search('*');
    if (ftsResults.isNotEmpty) return; // Already initialized or has data

    final allBlocks = await db.blocks.where().findAll();
    final ftsDb = await FtsService.instance;
    
    // Use a transaction for batch initialization
    ftsDb.execute('BEGIN TRANSACTION');
    try {
      for (final block in allBlocks) {
        ftsDb.execute(
          'INSERT OR REPLACE INTO search_index (blockId, pageId, content) VALUES (?, ?, ?)',
          [block.blockId, block.pageId, block.content],
        );
      }
      
      // Also index page titles as "virtual blocks" to have everything in FTS
      final allPages = await db.pages.where().findAll();
      for (final page in allPages) {
        ftsDb.execute(
          'INSERT OR REPLACE INTO search_index (blockId, pageId, content) VALUES (?, ?, ?)',
          ['page_${page.pageId}', page.pageId, page.title],
        );
      }
      ftsDb.execute('COMMIT');
    } catch (e) {
      ftsDb.execute('ROLLBACK');
      rethrow;
    }
  }

  /// Führt eine Volltextsuche über den FTS-Index aus.
  ///
  /// Gibt eine Liste von [Block] Objekten zurück, die dem [query] entsprechen.
  /// Auch Seitentitel werden als virtuelle Blöcke berücksichtigt.
  Future<List<Block>> searchBlocks(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final ftsResults = await FtsService.search(query);
      if (ftsResults.isEmpty) return [];

      final db = await _db;
      final blockIds = ftsResults.map((r) => r['blockId']!).toList();
      
      // Isar filter for the found blockIds
      // We filter out 'page_' prefix results as they don't exist as blocks in Isar
      final realBlockIds = blockIds.where((id) => !id.startsWith('page_')).toList();
      
      if (realBlockIds.isEmpty) {
        // If we only found pages, we return virtual blocks with highlights
        return ftsResults.map((r) => Block(
              blockId: r['blockId']!,
              pageId: r['pageId']!,
              content: r['highlight'] ?? '',
            ),).toList();
      }

      final blocks = await db.blocks.filter()
          .anyOf(realBlockIds, (q, String id) => q.blockIdEqualTo(id))
          .findAll();
          
      // Add "virtual" blocks for pages so searchPages can extract the pageId
      final pageVirtualBlocks = ftsResults
          .where((r) => r['blockId']!.startsWith('page_'))
          .map((r) => Block(
                blockId: r['blockId']!,
                pageId: r['pageId']!,
                content: r['highlight'] ?? '',
              ),);
      
      return [...blocks, ...pageVirtualBlocks];
    } catch (e) {
      // Fallback to simple contains if Fts fails (e.g. syntax error in query)
      final db = await _db;
      final lowerQuery = query.toLowerCase();
      final blocks = await db.blocks
          .filter()
          .contentContains(lowerQuery, caseSensitive: false)
          .findAll();
      
      final pages = await db.pages
          .filter()
          .titleContains(lowerQuery, caseSensitive: false)
          .findAll();
      
      final pageVirtualBlocks = pages.map((p) => Block(blockId: 'page_${p.pageId}', pageId: p.pageId));
      
      return [...blocks, ...pageVirtualBlocks];
    }
  }

  Future<List<String>> searchBlockIds(String query) async {
    final blocks = await searchBlocks(query);
    return blocks.map((b) => b.blockId).toList();
  }

  /// Führt eine semantische Vektor-Suche über alle Blöcke aus.
  Future<List<(Block, double)>> vectorSearch(String query, {int limit = 10}) async {
    final db = await _db;
    // Wir holen uns alle Blöcke, die ein Embedding haben.
    // Bei großen Datenmengen sollte dies optimiert werden (z.B. durch Vorfilterung via FTS).
    final candidates = await db.blocks.filter().not().embeddingIsNull().findAll();
    
    return EmbeddingService.instance.findSimilarBlocks(query, candidates, limit: limit);
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
            },)
        .toList();
  }

  // ===================== LINKS =====================

  /// Ruft die ausgehenden Verlinkungen einer Seite ab.
  ///
  /// Analysiert Blockinhalte nach Wikilinks (`[[Titel]]`).
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
          ),);
        }
      }
    }
    return links;
  }

  /// Ruft die Rückverlinkungen (Backlinks) für eine Seite ab.
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
        ),);
      }
    }
    return links;
  }

  Future<void> createPageLink(String sourcePageId, String targetPageId,
      {String? sourceBlockId,}) async {
    // Links are derived from [[wikilink]] syntax in block content
  }

  Future<void> createBlockReference(
      String sourceBlockId, String targetBlockId,) async {
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

  // ===================== TEMPLATES =====================

  /// Ruft alle verfügbaren Templates ab.
  Future<List<Template>> getAllTemplates() async {
    final db = await _db;
    return db.templates.where().sortByUpdatedAtDesc().findAll();
  }

  /// Sucht ein Template anhand seiner [templateId].
  Future<Template?> getTemplateByTemplateId(String templateId) async {
    final db = await _db;
    return db.templates.filter().templateIdEqualTo(templateId).findFirst();
  }

  /// Speichert oder aktualisiert ein Template.
  Future<Template> saveTemplate(Template template) async {
    final db = await _db;
    final now = DateTime.now();
    template.createdAt ??= now;
    template.updatedAt = now;
    
    await db.writeTxn(() async {
      await db.templates.put(template);
    });
    return template;
  }

  /// Löscht ein Template anhand seiner [templateId].
  Future<void> deleteTemplate(String templateId) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.templates.filter().templateIdEqualTo(templateId).deleteFirst();
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
