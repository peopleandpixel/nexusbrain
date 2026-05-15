import 'package:isar_community/isar.dart';

part 'block.g.dart';

@Collection()
class Block {
  Id id = Isar.autoIncrement;

  @Index()
  late String blockId;

  @Index()
  late String pageId;

  String? parentId;
  String content = '';
  int orderIndex = 0;
  int indentLevel = 0;
  bool isCollapsed = false;

  String? taskState;
  DateTime? scheduledAt;
  DateTime? deadlineAt;
  DateTime? completedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords =>
      content.toLowerCase().split(RegExp(r'\s+'));

  Block({
    required this.blockId,
    required this.pageId,
    this.parentId,
    this.content = '',
    this.orderIndex = 0,
    this.indentLevel = 0,
    this.isCollapsed = false,
    this.taskState,
    this.scheduledAt,
    this.deadlineAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isTask => taskState != null;
  bool get isOpenTask => taskState == 'TODO' || taskState == 'DOING';
  bool get isCompletedTask => taskState == 'DONE';

  bool get isOverdue {
    if (deadlineAt == null || taskState == 'DONE' || taskState == 'CANCELLED') {
      return false;
    }
    return deadlineAt!.isBefore(DateTime.now());
  }

  String get taskIcon {
    switch (taskState) {
      case 'TODO': return '☐';
      case 'DOING': return '◐';
      case 'DONE': return '☑';
      case 'CANCELLED': return '⊘';
      default: return '';
    }
  }

  int get taskColor {
    switch (taskState) {
      case 'TODO': return 0xFF8B5CF6;
      case 'DOING': return 0xFF06B6D4;
      case 'DONE': return 0xFF10B981;
      case 'CANCELLED': return 0xFF64748B;
      default: return 0xFF64748B;
    }
  }

  bool get hasPageLinks => content.contains('[[');
  bool get hasBlockRefs => content.contains('((');

  List<String> get linkedPageTitles {
    final regex = RegExp(r'\[\[([^\]|]+)(?:\|[^\]]+)?\]\]');
    return regex.allMatches(content).map((m) => m.group(1)!.trim()).toList();
  }

  List<String> get referencedBlockIds {
    final regex = RegExp(r'\(\(([^)]+)\)');
    return regex.allMatches(content).map((m) => m.group(1)!.trim()).toList();
  }

  String get preview {
    final firstLine = content.split('\n').first.trim();
    if (firstLine.length <= 100) return firstLine;
    return '${firstLine.substring(0, 97)}...';
  }
}
