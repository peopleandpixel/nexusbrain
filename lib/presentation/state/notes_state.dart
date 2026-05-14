import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/core/database/database.dart' as db;
import 'package:nexusbrain/data/repositories/drift_block_repository.dart';
import 'package:nexusbrain/data/services/webdav_sync_service.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/block.dart';

// Database provider
final databaseProvider = Provider<db.NexusBrainDatabase>((ref) {
  final database = db.NexusBrainDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// Repository provider
final blockRepositoryProvider = Provider<DriftBlockRepository>((ref) {
  return DriftBlockRepository(ref.read(databaseProvider));
});

// Pages list
final pagesProvider = AsyncNotifierProvider<PagesNotifier, List<domain.MdBombPage>>(() {
  return PagesNotifier();
});

class PagesNotifier extends AsyncNotifier<List<domain.MdBombPage>> {
  @override
  Future<List<domain.MdBombPage>> build() async {
    final repo = ref.read(blockRepositoryProvider);
    return repo.getAllPages();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(blockRepositoryProvider);
      return repo.getAllPages();
    });
  }

  Future<domain.MdBombPage> createPage(String title) async {
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
}

// Current page blocks
final currentPageBlocksProvider = FutureProvider.family<List<Block>, String>((ref, pageId) async {
  final repo = ref.read(blockRepositoryProvider);
  return repo.getBlockTreeForPage(pageId);
});

// Search
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<domain.MdBombPage>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final repo = ref.read(blockRepositoryProvider);
  return repo.searchPages(query);
});

// WebDAV Sync
final webDavSyncProvider = Provider.family<WebDavSyncService, WebDavConfig>((ref, config) {
  return WebDavSyncService(
    repo: ref.read(blockRepositoryProvider),
    baseUrl: config.baseUrl,
    username: config.username,
    password: config.password,
    remotePath: config.remotePath,
  );
});


// Task repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(databaseProvider), ref.read(blockRepositoryProvider));
});

// Open tasks
final openTasksProvider = FutureProvider<List<Block>>((ref) async {
  return ref.read(taskRepositoryProvider).getOpenTasks();
});

// Today tasks
final todayTasksProvider = FutureProvider<List<Block>>((ref) async {
  return ref.read(taskRepositoryProvider).getTodayTasks();
});
