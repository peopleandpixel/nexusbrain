import '../../domain/models/block.dart';
import 'isar_block_repository.dart';

class TaskRepository {
  final IsarBlockRepository _repo;

  TaskRepository(this._repo);

  Future<List<Block>> getOpenTasks() => _repo.getOpenTasks();
  Future<List<Block>> getTasksByState(String state) =>
      _repo.getTasksByState(state);
  Future<List<Block>> getOverdueTasks() => _repo.getOverdueTasks();
  Future<List<Block>> getTodayTasks() => _repo.getTodayTasks();
  Future<List<Block>> getCompletedTasks({DateTime? since}) =>
      _repo.getCompletedTasks(since: since);
  Future<List<Block>> searchTasks(String query) => _repo.searchTasks(query);

  Future<Block> createTask(String pageId, String content,
      {String state = 'TODO'}) async {
    final block = await _repo.createBlock(pageId, content: content);
    block.taskState = state;
    return _repo.updateBlock(block);
  }

  Future<Block> updateTaskState(String blockId, String? newState) async {
    final block = await _repo.getBlockByBlockId(blockId);
    if (block == null) throw Exception('Block not found: $blockId');
    block.taskState = newState;
    if (newState == 'DONE') {
      block.completedAt = DateTime.now();
    } else {
      block.completedAt = null;
    }
    return _repo.updateBlock(block);
  }

  Future<Block> cycleTaskState(String blockId) async {
    final block = await _repo.getBlockByBlockId(blockId);
    if (block == null) throw Exception('Block not found: $blockId');
    final nextState = _getNextTaskState(block.taskState);
    return updateTaskState(blockId, nextState);
  }

  String? _getNextTaskState(String? current) {
    switch (current) {
      case 'TODO':
        return 'DOING';
      case 'DOING':
        return 'DONE';
      case 'DONE':
        return 'TODO';
      case 'CANCELLED':
        return 'TODO';
      default:
        return 'TODO';
    }
  }
}
