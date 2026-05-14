class Block {
  final String id;
  final String pageId;
  final String? parentId;
  final String content;
  final int orderIndex;
  final int indentLevel;
  final bool isCollapsed;
  // Task management
  final String? taskState; // 'TODO', 'DOING', 'DONE', 'CANCELLED', null
  final DateTime? scheduledAt;
  final DateTime? deadlineAt;
  final DateTime? completedAt;
  //
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Block> children;
  final List<String> referenceIds;

  const Block({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
    this.children = const [],
    this.referenceIds = const [],
  });

  Block copyWith({
    String? id,
    String? pageId,
    String? parentId,
    String? content,
    int? orderIndex,
    int? indentLevel,
    bool? isCollapsed,
    String? taskState,
    DateTime? scheduledAt,
    DateTime? deadlineAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Block>? children,
    List<String>? referenceIds,
  }) {
    return Block(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      indentLevel: indentLevel ?? this.indentLevel,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      taskState: taskState ?? this.taskState,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      children: children ?? this.children,
      referenceIds: referenceIds ?? this.referenceIds,
    );
  }

  factory Block.fromDrift(dynamic driftBlock) {
    return Block(
      id: driftBlock.id as String,
      pageId: driftBlock.pageId as String,
      parentId: driftBlock.parentId as String?,
      content: driftBlock.content as String? ?? '',
      orderIndex: driftBlock.orderIndex as int,
      indentLevel: driftBlock.indentLevel as int,
      isCollapsed: driftBlock.isCollapsed as bool,
      taskState: driftBlock.taskState as String?,
      scheduledAt: driftBlock.scheduledAt as DateTime?,
      deadlineAt: driftBlock.deadlineAt as DateTime?,
      completedAt: driftBlock.completedAt as DateTime?,
      createdAt: driftBlock.createdAt as DateTime,
      updatedAt: driftBlock.updatedAt as DateTime,
    );
  }

  /// Get a short preview of the content (first line, max 100 chars)
  String get preview {
    final firstLine = content.split('\n').first.trim();
    if (firstLine.length <= 100) return firstLine;
    return '${firstLine.substring(0, 97)}...';
  }

  /// Check if this block has children
  bool get hasChildren => children.isNotEmpty;

  /// Check if this block is a task
  bool get isTask => taskState != null;

  /// Check if this block is an open task (TODO or DOING)
  bool get isOpenTask => taskState == 'TODO' || taskState == 'DOING';

  /// Check if this block is a completed task
  bool get isCompletedTask => taskState == 'DONE';

  /// Check if this block is overdue (deadline in the past, not completed)
  bool get isOverdue {
    if (deadlineAt == null || taskState == 'DONE' || taskState == 'CANCELLED') {
      return false;
    }
    return deadlineAt!.isBefore(DateTime.now());
  }

  /// Get the task state icon
  String get taskIcon {
    switch (taskState) {
      case 'TODO': return '☐';
      case 'DOING': return '◐';
      case 'DONE': return '☑';
      case 'CANCELLED': return '⊘';
      default: return '';
    }
  }

  /// Get the task state color
  int get taskColor {
    switch (taskState) {
      case 'TODO': return 0xFF8B5CF6; // Violet
      case 'DOING': return 0xFF06B6D4; // Cyan
      case 'DONE': return 0xFF10B981; // Green
      case 'CANCELLED': return 0xFF64748B; // Gray
      default: return 0xFF64748B;
    }
  }

  /// Check if this block contains a page link [[Title]]
  bool get hasPageLinks => content.contains(RegExp(r'\[\['));

  /// Check if this block contains a block reference ((id))
  bool get hasBlockRefs => content.contains(RegExp(r'\(\('));

  /// Extract page link titles from content
  List<String> get linkedPageTitles {
    final regex = RegExp(r'\[\[([^\]|]+)(?:\|[^\]]+)?\]\]');
    return regex.allMatches(content).map((m) => m.group(1)!.trim()).toList();
  }

  /// Extract block reference IDs from content
  List<String> get referencedBlockIds {
    final regex = RegExp(r'\(\(([^)]+)\)');
    return regex.allMatches(content).map((m) => m.group(1)!.trim()).toList();
  }
}
