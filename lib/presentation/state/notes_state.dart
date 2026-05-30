import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/isar_block_repository.dart';
import '../../data/repositories/isar_task_repository.dart';
import '../../domain/models/block.dart';
import '../../domain/models/page.dart' as domain;
import '../../domain/models/template.dart';

part 'notes_state.g.dart';

@riverpod
IsarBlockRepository blockRepository(Ref ref) {
  return IsarBlockRepository();
}

// Pages list
@riverpod
class Pages extends _$Pages {
  @override
  Future<List<domain.Page>> build() async {
    final repo = ref.read(blockRepositoryProvider);
    await _autoCreateJournalIfNeeded(repo);
    await repo.initializeFts();
    return repo.getAllPages();
  }

  Future<void> _autoCreateJournalIfNeeded(IsarBlockRepository repo) async {
    final now = DateTime.now();
    final existingJournal = await repo.getJournalPageForDate(now);
    
    if (existingJournal == null) {
      final title = DateFormat('yyyy-MM-dd').format(now);
      await repo.createPage(title, isJournal: true);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(blockRepositoryProvider);
      // Ensure FTS is initialized on first load
      await repo.initializeFts();
      return repo.getAllPages();
    });
  }

  Future<domain.Page> createPage(String title) async {
    final repo = ref.read(blockRepositoryProvider);
    final page = await repo.createPage(title);
    await refresh();
    return page;
  }

  Future<void> deletePage(String id) async {
    final repo = ref.read(blockRepositoryProvider);
    await repo.deletePage(id);
    await refresh();
  }

  Future<void> updatePdfPath(String pageId, String? pdfPath) async {
    final repo = ref.read(blockRepositoryProvider);
    await repo.updatePagePdf(pageId, pdfPath);
    await refresh();
  }
}

// Current page blocks
@riverpod
Future<List<Block>> currentPageBlocks(Ref ref, String pageId) async {
  final repo = ref.read(blockRepositoryProvider);
  return repo.getBlockTreeForPage(pageId);
}

// Search
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<domain.Page>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final repo = ref.read(blockRepositoryProvider);
  
  // Kombiniere FTS-Suche mit Vektor-Suche
  final ftsPages = await repo.searchPages(query);
  final vectorResults = await repo.vectorSearch(query, limit: 5);
  
  // Extrahiere Seiten aus Vektor-Ergebnissen
  final vectorPages = <domain.Page>[];
  for (final res in vectorResults) {
    final page = await repo.getPageByPageId(res.$1.pageId);
    if (page != null) {
      vectorPages.add(page);
    }
  }
  
  // Zusammenführen und Duplikate entfernen
  final allPages = [...ftsPages];
  final seenIds = allPages.map((p) => p.pageId).toSet();
  
  for (final vp in vectorPages) {
    if (!seenIds.contains(vp.pageId)) {
      allPages.add(vp);
      seenIds.add(vp.pageId);
    }
  }
  
  return allPages;
}

// Task repository
@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskRepository(ref.read(blockRepositoryProvider));
}

// Open tasks
@riverpod
Future<List<Block>> openTasks(Ref ref) async {
  return ref.read(taskRepositoryProvider).getOpenTasks();
}

// Today tasks
@riverpod
Future<List<Block>> todayTasks(Ref ref) async {
  return ref.read(taskRepositoryProvider).getTodayTasks();
}

// Advanced Query
@riverpod
class AdvancedQueryString extends _$AdvancedQueryString {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<Block>> advancedQueryResults(Ref ref) async {
  final query = ref.watch(advancedQueryStringProvider);
  if (query.trim().isEmpty) return [];
  final repo = ref.read(blockRepositoryProvider);
  return repo.executeQuery(query);
}

@riverpod
class Templates extends _$Templates {
  @override
  Future<List<Template>> build() async {
    final repo = ref.read(blockRepositoryProvider);
    return repo.getAllTemplates();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(blockRepositoryProvider);
      return repo.getAllTemplates();
    });
  }

  Future<void> saveTemplate(Template template) async {
    final repo = ref.read(blockRepositoryProvider);
    await repo.saveTemplate(template);
    await refresh();
  }

  Future<void> deleteTemplate(String templateId) async {
    final repo = ref.read(blockRepositoryProvider);
    await repo.deleteTemplate(templateId);
    await refresh();
  }
}
