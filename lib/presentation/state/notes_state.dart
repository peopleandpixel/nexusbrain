import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/isar_block_repository.dart';
import '../../data/repositories/isar_task_repository.dart';
import '../../domain/models/page.dart' as domain;
import '../../domain/models/block.dart';

final blockRepositoryProvider = Provider<IsarBlockRepository>((ref) {
  return IsarBlockRepository();
});

// Pages list
final pagesProvider =
    AsyncNotifierProvider<PagesNotifier, List<domain.Page>>(() {
  return PagesNotifier();
});

class PagesNotifier extends AsyncNotifier<List<domain.Page>> {
  @override
  Future<List<domain.Page>> build() async {
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
}

// Current page blocks
final currentPageBlocksProvider =
    FutureProvider.family<List<Block>, String>((ref, pageId) async {
  final repo = ref.read(blockRepositoryProvider);
  return repo.getBlockTreeForPage(pageId);
});

// Search
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<domain.Page>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final repo = ref.read(blockRepositoryProvider);
  return repo.searchPages(query);
});

// Task repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(blockRepositoryProvider));
});

// Open tasks
final openTasksProvider = FutureProvider<List<Block>>((ref) async {
  return ref.read(taskRepositoryProvider).getOpenTasks();
});

// Today tasks
final todayTasksProvider = FutureProvider<List<Block>>((ref) async {
  return ref.read(taskRepositoryProvider).getTodayTasks();
});
