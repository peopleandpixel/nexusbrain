// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PagesTable extends Pages with TableInfo<$PagesTable, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isJournalMeta =
      const VerificationMeta('isJournal');
  @override
  late final GeneratedColumn<bool> isJournal = GeneratedColumn<bool>(
      'is_journal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_journal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, filePath, isJournal, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pages';
  @override
  VerificationContext validateIntegrity(Insertable<Page> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('is_journal')) {
      context.handle(_isJournalMeta,
          isJournal.isAcceptableOrUnknown(data['is_journal']!, _isJournalMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Page(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      isJournal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_journal'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class Page extends DataClass implements Insertable<Page> {
  final String id;
  final String title;
  final String? filePath;
  final bool isJournal;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Page(
      {required this.id,
      required this.title,
      this.filePath,
      required this.isJournal,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['is_journal'] = Variable<bool>(isJournal);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      title: Value(title),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      isJournal: Value(isJournal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Page.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      isJournal: serializer.fromJson<bool>(json['isJournal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'filePath': serializer.toJson<String?>(filePath),
      'isJournal': serializer.toJson<bool>(isJournal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Page copyWith(
          {String? id,
          String? title,
          Value<String?> filePath = const Value.absent(),
          bool? isJournal,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Page(
        id: id ?? this.id,
        title: title ?? this.title,
        filePath: filePath.present ? filePath.value : this.filePath,
        isJournal: isJournal ?? this.isJournal,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Page copyWithCompanion(PagesCompanion data) {
    return Page(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isJournal: data.isJournal.present ? data.isJournal.value : this.isJournal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('isJournal: $isJournal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, filePath, isJournal, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.title == this.title &&
          other.filePath == this.filePath &&
          other.isJournal == this.isJournal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> filePath;
  final Value<bool> isJournal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isJournal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PagesCompanion.insert({
    required String id,
    required String title,
    this.filePath = const Value.absent(),
    this.isJournal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title);
  static Insertable<Page> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? filePath,
    Expression<bool>? isJournal,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (filePath != null) 'file_path': filePath,
      if (isJournal != null) 'is_journal': isJournal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? filePath,
      Value<bool>? isJournal,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      isJournal: isJournal ?? this.isJournal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (isJournal.present) {
      map['is_journal'] = Variable<bool>(isJournal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('isJournal: $isJournal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BlocksTable extends Blocks with TableInfo<$BlocksTable, Block> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
      'page_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pages (id) ON DELETE CASCADE'));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES blocks (id) ON DELETE SET NULL'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _indentLevelMeta =
      const VerificationMeta('indentLevel');
  @override
  late final GeneratedColumn<int> indentLevel = GeneratedColumn<int>(
      'indent_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isCollapsedMeta =
      const VerificationMeta('isCollapsed');
  @override
  late final GeneratedColumn<bool> isCollapsed = GeneratedColumn<bool>(
      'is_collapsed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_collapsed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _taskStateMeta =
      const VerificationMeta('taskState');
  @override
  late final GeneratedColumn<String> taskState = GeneratedColumn<String>(
      'task_state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deadlineAtMeta =
      const VerificationMeta('deadlineAt');
  @override
  late final GeneratedColumn<DateTime> deadlineAt = GeneratedColumn<DateTime>(
      'deadline_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pageId,
        parentId,
        content,
        orderIndex,
        indentLevel,
        isCollapsed,
        taskState,
        scheduledAt,
        deadlineAt,
        completedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocks';
  @override
  VerificationContext validateIntegrity(Insertable<Block> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    }
    if (data.containsKey('indent_level')) {
      context.handle(
          _indentLevelMeta,
          indentLevel.isAcceptableOrUnknown(
              data['indent_level']!, _indentLevelMeta));
    }
    if (data.containsKey('is_collapsed')) {
      context.handle(
          _isCollapsedMeta,
          isCollapsed.isAcceptableOrUnknown(
              data['is_collapsed']!, _isCollapsedMeta));
    }
    if (data.containsKey('task_state')) {
      context.handle(_taskStateMeta,
          taskState.isAcceptableOrUnknown(data['task_state']!, _taskStateMeta));
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    }
    if (data.containsKey('deadline_at')) {
      context.handle(
          _deadlineAtMeta,
          deadlineAt.isAcceptableOrUnknown(
              data['deadline_at']!, _deadlineAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Block map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Block(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      pageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      indentLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}indent_level'])!,
      isCollapsed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_collapsed'])!,
      taskState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_state']),
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at']),
      deadlineAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BlocksTable createAlias(String alias) {
    return $BlocksTable(attachedDatabase, alias);
  }
}

class Block extends DataClass implements Insertable<Block> {
  final String id;
  final String pageId;
  final String? parentId;
  final String content;
  final int orderIndex;
  final int indentLevel;
  final bool isCollapsed;
  final String? taskState;
  final DateTime? scheduledAt;
  final DateTime? deadlineAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Block(
      {required this.id,
      required this.pageId,
      this.parentId,
      required this.content,
      required this.orderIndex,
      required this.indentLevel,
      required this.isCollapsed,
      this.taskState,
      this.scheduledAt,
      this.deadlineAt,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['page_id'] = Variable<String>(pageId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['content'] = Variable<String>(content);
    map['order_index'] = Variable<int>(orderIndex);
    map['indent_level'] = Variable<int>(indentLevel);
    map['is_collapsed'] = Variable<bool>(isCollapsed);
    if (!nullToAbsent || taskState != null) {
      map['task_state'] = Variable<String>(taskState);
    }
    if (!nullToAbsent || scheduledAt != null) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    }
    if (!nullToAbsent || deadlineAt != null) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BlocksCompanion toCompanion(bool nullToAbsent) {
    return BlocksCompanion(
      id: Value(id),
      pageId: Value(pageId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      content: Value(content),
      orderIndex: Value(orderIndex),
      indentLevel: Value(indentLevel),
      isCollapsed: Value(isCollapsed),
      taskState: taskState == null && nullToAbsent
          ? const Value.absent()
          : Value(taskState),
      scheduledAt: scheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledAt),
      deadlineAt: deadlineAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deadlineAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Block.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Block(
      id: serializer.fromJson<String>(json['id']),
      pageId: serializer.fromJson<String>(json['pageId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      content: serializer.fromJson<String>(json['content']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      indentLevel: serializer.fromJson<int>(json['indentLevel']),
      isCollapsed: serializer.fromJson<bool>(json['isCollapsed']),
      taskState: serializer.fromJson<String?>(json['taskState']),
      scheduledAt: serializer.fromJson<DateTime?>(json['scheduledAt']),
      deadlineAt: serializer.fromJson<DateTime?>(json['deadlineAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'pageId': serializer.toJson<String>(pageId),
      'parentId': serializer.toJson<String?>(parentId),
      'content': serializer.toJson<String>(content),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'indentLevel': serializer.toJson<int>(indentLevel),
      'isCollapsed': serializer.toJson<bool>(isCollapsed),
      'taskState': serializer.toJson<String?>(taskState),
      'scheduledAt': serializer.toJson<DateTime?>(scheduledAt),
      'deadlineAt': serializer.toJson<DateTime?>(deadlineAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Block copyWith(
          {String? id,
          String? pageId,
          Value<String?> parentId = const Value.absent(),
          String? content,
          int? orderIndex,
          int? indentLevel,
          bool? isCollapsed,
          Value<String?> taskState = const Value.absent(),
          Value<DateTime?> scheduledAt = const Value.absent(),
          Value<DateTime?> deadlineAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Block(
        id: id ?? this.id,
        pageId: pageId ?? this.pageId,
        parentId: parentId.present ? parentId.value : this.parentId,
        content: content ?? this.content,
        orderIndex: orderIndex ?? this.orderIndex,
        indentLevel: indentLevel ?? this.indentLevel,
        isCollapsed: isCollapsed ?? this.isCollapsed,
        taskState: taskState.present ? taskState.value : this.taskState,
        scheduledAt: scheduledAt.present ? scheduledAt.value : this.scheduledAt,
        deadlineAt: deadlineAt.present ? deadlineAt.value : this.deadlineAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Block copyWithCompanion(BlocksCompanion data) {
    return Block(
      id: data.id.present ? data.id.value : this.id,
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      content: data.content.present ? data.content.value : this.content,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      indentLevel:
          data.indentLevel.present ? data.indentLevel.value : this.indentLevel,
      isCollapsed:
          data.isCollapsed.present ? data.isCollapsed.value : this.isCollapsed,
      taskState: data.taskState.present ? data.taskState.value : this.taskState,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      deadlineAt:
          data.deadlineAt.present ? data.deadlineAt.value : this.deadlineAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Block(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('parentId: $parentId, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('indentLevel: $indentLevel, ')
          ..write('isCollapsed: $isCollapsed, ')
          ..write('taskState: $taskState, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      pageId,
      parentId,
      content,
      orderIndex,
      indentLevel,
      isCollapsed,
      taskState,
      scheduledAt,
      deadlineAt,
      completedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Block &&
          other.id == this.id &&
          other.pageId == this.pageId &&
          other.parentId == this.parentId &&
          other.content == this.content &&
          other.orderIndex == this.orderIndex &&
          other.indentLevel == this.indentLevel &&
          other.isCollapsed == this.isCollapsed &&
          other.taskState == this.taskState &&
          other.scheduledAt == this.scheduledAt &&
          other.deadlineAt == this.deadlineAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BlocksCompanion extends UpdateCompanion<Block> {
  final Value<String> id;
  final Value<String> pageId;
  final Value<String?> parentId;
  final Value<String> content;
  final Value<int> orderIndex;
  final Value<int> indentLevel;
  final Value<bool> isCollapsed;
  final Value<String?> taskState;
  final Value<DateTime?> scheduledAt;
  final Value<DateTime?> deadlineAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BlocksCompanion({
    this.id = const Value.absent(),
    this.pageId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.indentLevel = const Value.absent(),
    this.isCollapsed = const Value.absent(),
    this.taskState = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlocksCompanion.insert({
    required String id,
    required String pageId,
    this.parentId = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.indentLevel = const Value.absent(),
    this.isCollapsed = const Value.absent(),
    this.taskState = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        pageId = Value(pageId);
  static Insertable<Block> custom({
    Expression<String>? id,
    Expression<String>? pageId,
    Expression<String>? parentId,
    Expression<String>? content,
    Expression<int>? orderIndex,
    Expression<int>? indentLevel,
    Expression<bool>? isCollapsed,
    Expression<String>? taskState,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? deadlineAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pageId != null) 'page_id': pageId,
      if (parentId != null) 'parent_id': parentId,
      if (content != null) 'content': content,
      if (orderIndex != null) 'order_index': orderIndex,
      if (indentLevel != null) 'indent_level': indentLevel,
      if (isCollapsed != null) 'is_collapsed': isCollapsed,
      if (taskState != null) 'task_state': taskState,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (deadlineAt != null) 'deadline_at': deadlineAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlocksCompanion copyWith(
      {Value<String>? id,
      Value<String>? pageId,
      Value<String?>? parentId,
      Value<String>? content,
      Value<int>? orderIndex,
      Value<int>? indentLevel,
      Value<bool>? isCollapsed,
      Value<String?>? taskState,
      Value<DateTime?>? scheduledAt,
      Value<DateTime?>? deadlineAt,
      Value<DateTime?>? completedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BlocksCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (indentLevel.present) {
      map['indent_level'] = Variable<int>(indentLevel.value);
    }
    if (isCollapsed.present) {
      map['is_collapsed'] = Variable<bool>(isCollapsed.value);
    }
    if (taskState.present) {
      map['task_state'] = Variable<String>(taskState.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (deadlineAt.present) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksCompanion(')
          ..write('id: $id, ')
          ..write('pageId: $pageId, ')
          ..write('parentId: $parentId, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('indentLevel: $indentLevel, ')
          ..write('isCollapsed: $isCollapsed, ')
          ..write('taskState: $taskState, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, color, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final String? color;
  final DateTime createdAt;
  const Tag(
      {required this.id,
      required this.name,
      this.color,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith(
          {String? id,
          String? name,
          Value<String?> color = const Value.absent(),
          DateTime? createdAt}) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color.present ? color.value : this.color,
        createdAt: createdAt ?? this.createdAt,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? color,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PageTagsTable extends PageTags with TableInfo<$PageTagsTable, PageTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PageTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<String> pageId = GeneratedColumn<String>(
      'page_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pages (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tags (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [pageId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'page_tags';
  @override
  VerificationContext validateIntegrity(Insertable<PageTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    } else if (isInserting) {
      context.missing(_pageIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pageId, tagId};
  @override
  PageTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PageTag(
      pageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $PageTagsTable createAlias(String alias) {
    return $PageTagsTable(attachedDatabase, alias);
  }
}

class PageTag extends DataClass implements Insertable<PageTag> {
  final String pageId;
  final String tagId;
  const PageTag({required this.pageId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['page_id'] = Variable<String>(pageId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  PageTagsCompanion toCompanion(bool nullToAbsent) {
    return PageTagsCompanion(
      pageId: Value(pageId),
      tagId: Value(tagId),
    );
  }

  factory PageTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PageTag(
      pageId: serializer.fromJson<String>(json['pageId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pageId': serializer.toJson<String>(pageId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  PageTag copyWith({String? pageId, String? tagId}) => PageTag(
        pageId: pageId ?? this.pageId,
        tagId: tagId ?? this.tagId,
      );
  PageTag copyWithCompanion(PageTagsCompanion data) {
    return PageTag(
      pageId: data.pageId.present ? data.pageId.value : this.pageId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PageTag(')
          ..write('pageId: $pageId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pageId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PageTag &&
          other.pageId == this.pageId &&
          other.tagId == this.tagId);
}

class PageTagsCompanion extends UpdateCompanion<PageTag> {
  final Value<String> pageId;
  final Value<String> tagId;
  final Value<int> rowid;
  const PageTagsCompanion({
    this.pageId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PageTagsCompanion.insert({
    required String pageId,
    required String tagId,
    this.rowid = const Value.absent(),
  })  : pageId = Value(pageId),
        tagId = Value(tagId);
  static Insertable<PageTag> custom({
    Expression<String>? pageId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pageId != null) 'page_id': pageId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PageTagsCompanion copyWith(
      {Value<String>? pageId, Value<String>? tagId, Value<int>? rowid}) {
    return PageTagsCompanion(
      pageId: pageId ?? this.pageId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pageId.present) {
      map['page_id'] = Variable<String>(pageId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PageTagsCompanion(')
          ..write('pageId: $pageId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PageLinksTable extends PageLinks
    with TableInfo<$PageLinksTable, PageLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PageLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourcePageIdMeta =
      const VerificationMeta('sourcePageId');
  @override
  late final GeneratedColumn<String> sourcePageId = GeneratedColumn<String>(
      'source_page_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pages (id) ON DELETE CASCADE'));
  static const VerificationMeta _targetPageIdMeta =
      const VerificationMeta('targetPageId');
  @override
  late final GeneratedColumn<String> targetPageId = GeneratedColumn<String>(
      'target_page_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pages (id) ON DELETE CASCADE'));
  static const VerificationMeta _sourceBlockIdMeta =
      const VerificationMeta('sourceBlockId');
  @override
  late final GeneratedColumn<String> sourceBlockId = GeneratedColumn<String>(
      'source_block_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES blocks (id) ON DELETE SET NULL'));
  static const VerificationMeta _linkTypeMeta =
      const VerificationMeta('linkType');
  @override
  late final GeneratedColumn<String> linkType = GeneratedColumn<String>(
      'link_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('wikilink'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [sourcePageId, targetPageId, sourceBlockId, linkType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'page_links';
  @override
  VerificationContext validateIntegrity(Insertable<PageLink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_page_id')) {
      context.handle(
          _sourcePageIdMeta,
          sourcePageId.isAcceptableOrUnknown(
              data['source_page_id']!, _sourcePageIdMeta));
    } else if (isInserting) {
      context.missing(_sourcePageIdMeta);
    }
    if (data.containsKey('target_page_id')) {
      context.handle(
          _targetPageIdMeta,
          targetPageId.isAcceptableOrUnknown(
              data['target_page_id']!, _targetPageIdMeta));
    } else if (isInserting) {
      context.missing(_targetPageIdMeta);
    }
    if (data.containsKey('source_block_id')) {
      context.handle(
          _sourceBlockIdMeta,
          sourceBlockId.isAcceptableOrUnknown(
              data['source_block_id']!, _sourceBlockIdMeta));
    }
    if (data.containsKey('link_type')) {
      context.handle(_linkTypeMeta,
          linkType.isAcceptableOrUnknown(data['link_type']!, _linkTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {sourcePageId, targetPageId, sourceBlockId};
  @override
  PageLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PageLink(
      sourcePageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_page_id'])!,
      targetPageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_page_id'])!,
      sourceBlockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_block_id']),
      linkType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}link_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PageLinksTable createAlias(String alias) {
    return $PageLinksTable(attachedDatabase, alias);
  }
}

class PageLink extends DataClass implements Insertable<PageLink> {
  final String sourcePageId;
  final String targetPageId;
  final String? sourceBlockId;
  final String linkType;
  final DateTime createdAt;
  const PageLink(
      {required this.sourcePageId,
      required this.targetPageId,
      this.sourceBlockId,
      required this.linkType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_page_id'] = Variable<String>(sourcePageId);
    map['target_page_id'] = Variable<String>(targetPageId);
    if (!nullToAbsent || sourceBlockId != null) {
      map['source_block_id'] = Variable<String>(sourceBlockId);
    }
    map['link_type'] = Variable<String>(linkType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PageLinksCompanion toCompanion(bool nullToAbsent) {
    return PageLinksCompanion(
      sourcePageId: Value(sourcePageId),
      targetPageId: Value(targetPageId),
      sourceBlockId: sourceBlockId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBlockId),
      linkType: Value(linkType),
      createdAt: Value(createdAt),
    );
  }

  factory PageLink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PageLink(
      sourcePageId: serializer.fromJson<String>(json['sourcePageId']),
      targetPageId: serializer.fromJson<String>(json['targetPageId']),
      sourceBlockId: serializer.fromJson<String?>(json['sourceBlockId']),
      linkType: serializer.fromJson<String>(json['linkType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourcePageId': serializer.toJson<String>(sourcePageId),
      'targetPageId': serializer.toJson<String>(targetPageId),
      'sourceBlockId': serializer.toJson<String?>(sourceBlockId),
      'linkType': serializer.toJson<String>(linkType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PageLink copyWith(
          {String? sourcePageId,
          String? targetPageId,
          Value<String?> sourceBlockId = const Value.absent(),
          String? linkType,
          DateTime? createdAt}) =>
      PageLink(
        sourcePageId: sourcePageId ?? this.sourcePageId,
        targetPageId: targetPageId ?? this.targetPageId,
        sourceBlockId:
            sourceBlockId.present ? sourceBlockId.value : this.sourceBlockId,
        linkType: linkType ?? this.linkType,
        createdAt: createdAt ?? this.createdAt,
      );
  PageLink copyWithCompanion(PageLinksCompanion data) {
    return PageLink(
      sourcePageId: data.sourcePageId.present
          ? data.sourcePageId.value
          : this.sourcePageId,
      targetPageId: data.targetPageId.present
          ? data.targetPageId.value
          : this.targetPageId,
      sourceBlockId: data.sourceBlockId.present
          ? data.sourceBlockId.value
          : this.sourceBlockId,
      linkType: data.linkType.present ? data.linkType.value : this.linkType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PageLink(')
          ..write('sourcePageId: $sourcePageId, ')
          ..write('targetPageId: $targetPageId, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('linkType: $linkType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      sourcePageId, targetPageId, sourceBlockId, linkType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PageLink &&
          other.sourcePageId == this.sourcePageId &&
          other.targetPageId == this.targetPageId &&
          other.sourceBlockId == this.sourceBlockId &&
          other.linkType == this.linkType &&
          other.createdAt == this.createdAt);
}

class PageLinksCompanion extends UpdateCompanion<PageLink> {
  final Value<String> sourcePageId;
  final Value<String> targetPageId;
  final Value<String?> sourceBlockId;
  final Value<String> linkType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PageLinksCompanion({
    this.sourcePageId = const Value.absent(),
    this.targetPageId = const Value.absent(),
    this.sourceBlockId = const Value.absent(),
    this.linkType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PageLinksCompanion.insert({
    required String sourcePageId,
    required String targetPageId,
    this.sourceBlockId = const Value.absent(),
    this.linkType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : sourcePageId = Value(sourcePageId),
        targetPageId = Value(targetPageId);
  static Insertable<PageLink> custom({
    Expression<String>? sourcePageId,
    Expression<String>? targetPageId,
    Expression<String>? sourceBlockId,
    Expression<String>? linkType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourcePageId != null) 'source_page_id': sourcePageId,
      if (targetPageId != null) 'target_page_id': targetPageId,
      if (sourceBlockId != null) 'source_block_id': sourceBlockId,
      if (linkType != null) 'link_type': linkType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PageLinksCompanion copyWith(
      {Value<String>? sourcePageId,
      Value<String>? targetPageId,
      Value<String?>? sourceBlockId,
      Value<String>? linkType,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PageLinksCompanion(
      sourcePageId: sourcePageId ?? this.sourcePageId,
      targetPageId: targetPageId ?? this.targetPageId,
      sourceBlockId: sourceBlockId ?? this.sourceBlockId,
      linkType: linkType ?? this.linkType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourcePageId.present) {
      map['source_page_id'] = Variable<String>(sourcePageId.value);
    }
    if (targetPageId.present) {
      map['target_page_id'] = Variable<String>(targetPageId.value);
    }
    if (sourceBlockId.present) {
      map['source_block_id'] = Variable<String>(sourceBlockId.value);
    }
    if (linkType.present) {
      map['link_type'] = Variable<String>(linkType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PageLinksCompanion(')
          ..write('sourcePageId: $sourcePageId, ')
          ..write('targetPageId: $targetPageId, ')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('linkType: $linkType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BlockReferencesTable extends BlockReferences
    with TableInfo<$BlockReferencesTable, BlockReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceBlockIdMeta =
      const VerificationMeta('sourceBlockId');
  @override
  late final GeneratedColumn<String> sourceBlockId = GeneratedColumn<String>(
      'source_block_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES blocks (id) ON DELETE CASCADE'));
  static const VerificationMeta _targetBlockIdMeta =
      const VerificationMeta('targetBlockId');
  @override
  late final GeneratedColumn<String> targetBlockId = GeneratedColumn<String>(
      'target_block_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES blocks (id) ON DELETE CASCADE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [sourceBlockId, targetBlockId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'block_references';
  @override
  VerificationContext validateIntegrity(Insertable<BlockReference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source_block_id')) {
      context.handle(
          _sourceBlockIdMeta,
          sourceBlockId.isAcceptableOrUnknown(
              data['source_block_id']!, _sourceBlockIdMeta));
    } else if (isInserting) {
      context.missing(_sourceBlockIdMeta);
    }
    if (data.containsKey('target_block_id')) {
      context.handle(
          _targetBlockIdMeta,
          targetBlockId.isAcceptableOrUnknown(
              data['target_block_id']!, _targetBlockIdMeta));
    } else if (isInserting) {
      context.missing(_targetBlockIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sourceBlockId, targetBlockId};
  @override
  BlockReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockReference(
      sourceBlockId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_block_id'])!,
      targetBlockId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_block_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BlockReferencesTable createAlias(String alias) {
    return $BlockReferencesTable(attachedDatabase, alias);
  }
}

class BlockReference extends DataClass implements Insertable<BlockReference> {
  final String sourceBlockId;
  final String targetBlockId;
  final DateTime createdAt;
  const BlockReference(
      {required this.sourceBlockId,
      required this.targetBlockId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source_block_id'] = Variable<String>(sourceBlockId);
    map['target_block_id'] = Variable<String>(targetBlockId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BlockReferencesCompanion toCompanion(bool nullToAbsent) {
    return BlockReferencesCompanion(
      sourceBlockId: Value(sourceBlockId),
      targetBlockId: Value(targetBlockId),
      createdAt: Value(createdAt),
    );
  }

  factory BlockReference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockReference(
      sourceBlockId: serializer.fromJson<String>(json['sourceBlockId']),
      targetBlockId: serializer.fromJson<String>(json['targetBlockId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sourceBlockId': serializer.toJson<String>(sourceBlockId),
      'targetBlockId': serializer.toJson<String>(targetBlockId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BlockReference copyWith(
          {String? sourceBlockId,
          String? targetBlockId,
          DateTime? createdAt}) =>
      BlockReference(
        sourceBlockId: sourceBlockId ?? this.sourceBlockId,
        targetBlockId: targetBlockId ?? this.targetBlockId,
        createdAt: createdAt ?? this.createdAt,
      );
  BlockReference copyWithCompanion(BlockReferencesCompanion data) {
    return BlockReference(
      sourceBlockId: data.sourceBlockId.present
          ? data.sourceBlockId.value
          : this.sourceBlockId,
      targetBlockId: data.targetBlockId.present
          ? data.targetBlockId.value
          : this.targetBlockId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockReference(')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('targetBlockId: $targetBlockId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sourceBlockId, targetBlockId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockReference &&
          other.sourceBlockId == this.sourceBlockId &&
          other.targetBlockId == this.targetBlockId &&
          other.createdAt == this.createdAt);
}

class BlockReferencesCompanion extends UpdateCompanion<BlockReference> {
  final Value<String> sourceBlockId;
  final Value<String> targetBlockId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BlockReferencesCompanion({
    this.sourceBlockId = const Value.absent(),
    this.targetBlockId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlockReferencesCompanion.insert({
    required String sourceBlockId,
    required String targetBlockId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : sourceBlockId = Value(sourceBlockId),
        targetBlockId = Value(targetBlockId);
  static Insertable<BlockReference> custom({
    Expression<String>? sourceBlockId,
    Expression<String>? targetBlockId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sourceBlockId != null) 'source_block_id': sourceBlockId,
      if (targetBlockId != null) 'target_block_id': targetBlockId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlockReferencesCompanion copyWith(
      {Value<String>? sourceBlockId,
      Value<String>? targetBlockId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BlockReferencesCompanion(
      sourceBlockId: sourceBlockId ?? this.sourceBlockId,
      targetBlockId: targetBlockId ?? this.targetBlockId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sourceBlockId.present) {
      map['source_block_id'] = Variable<String>(sourceBlockId.value);
    }
    if (targetBlockId.present) {
      map['target_block_id'] = Variable<String>(targetBlockId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockReferencesCompanion(')
          ..write('sourceBlockId: $sourceBlockId, ')
          ..write('targetBlockId: $targetBlockId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$NexusBrainDatabase extends GeneratedDatabase {
  _$NexusBrainDatabase(QueryExecutor e) : super(e);
  $NexusBrainDatabaseManager get managers => $NexusBrainDatabaseManager(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $BlocksTable blocks = $BlocksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $PageTagsTable pageTags = $PageTagsTable(this);
  late final $PageLinksTable pageLinks = $PageLinksTable(this);
  late final $BlockReferencesTable blockReferences =
      $BlockReferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [pages, blocks, tags, pageTags, pageLinks, blockReferences];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('pages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('blocks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('blocks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('blocks', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('pages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('page_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('page_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('pages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('page_links', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('pages',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('page_links', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('blocks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('page_links', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('blocks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('block_references', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('blocks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('block_references', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$PagesTableCreateCompanionBuilder = PagesCompanion Function({
  required String id,
  required String title,
  Value<String?> filePath,
  Value<bool> isJournal,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$PagesTableUpdateCompanionBuilder = PagesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> filePath,
  Value<bool> isJournal,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PagesTableReferences
    extends BaseReferences<_$NexusBrainDatabase, $PagesTable, Page> {
  $$PagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BlocksTable, List<Block>> _blocksRefsTable(
          _$NexusBrainDatabase db) =>
      MultiTypedResultKey.fromTable(db.blocks,
          aliasName: $_aliasNameGenerator(db.pages.id, db.blocks.pageId));

  $$BlocksTableProcessedTableManager get blocksRefs {
    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_blocksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PageTagsTable, List<PageTag>> _pageTagsRefsTable(
          _$NexusBrainDatabase db) =>
      MultiTypedResultKey.fromTable(db.pageTags,
          aliasName: $_aliasNameGenerator(db.pages.id, db.pageTags.pageId));

  $$PageTagsTableProcessedTableManager get pageTagsRefs {
    final manager = $$PageTagsTableTableManager($_db, $_db.pageTags)
        .filter((f) => f.pageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pageTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PagesTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $PagesTable> {
  $$PagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isJournal => $composableBuilder(
      column: $table.isJournal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> blocksRefs(
      Expression<bool> Function($$BlocksTableFilterComposer f) f) {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.pageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> pageTagsRefs(
      Expression<bool> Function($$PageTagsTableFilterComposer f) f) {
    final $$PageTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageTags,
        getReferencedColumn: (t) => t.pageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageTagsTableFilterComposer(
              $db: $db,
              $table: $db.pageTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PagesTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $PagesTable> {
  $$PagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isJournal => $composableBuilder(
      column: $table.isJournal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PagesTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $PagesTable> {
  $$PagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get isJournal =>
      $composableBuilder(column: $table.isJournal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> blocksRefs<T extends Object>(
      Expression<T> Function($$BlocksTableAnnotationComposer a) f) {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.pageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> pageTagsRefs<T extends Object>(
      Expression<T> Function($$PageTagsTableAnnotationComposer a) f) {
    final $$PageTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageTags,
        getReferencedColumn: (t) => t.pageId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.pageTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PagesTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $PagesTable,
    Page,
    $$PagesTableFilterComposer,
    $$PagesTableOrderingComposer,
    $$PagesTableAnnotationComposer,
    $$PagesTableCreateCompanionBuilder,
    $$PagesTableUpdateCompanionBuilder,
    (Page, $$PagesTableReferences),
    Page,
    PrefetchHooks Function({bool blocksRefs, bool pageTagsRefs})> {
  $$PagesTableTableManager(_$NexusBrainDatabase db, $PagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<bool> isJournal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PagesCompanion(
            id: id,
            title: title,
            filePath: filePath,
            isJournal: isJournal,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> filePath = const Value.absent(),
            Value<bool> isJournal = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PagesCompanion.insert(
            id: id,
            title: title,
            filePath: filePath,
            isJournal: isJournal,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({blocksRefs = false, pageTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (blocksRefs) db.blocks,
                if (pageTagsRefs) db.pageTags
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (blocksRefs)
                    await $_getPrefetchedData<Page, $PagesTable, Block>(
                        currentTable: table,
                        referencedTable:
                            $$PagesTableReferences._blocksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PagesTableReferences(db, table, p0).blocksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pageId == item.id),
                        typedResults: items),
                  if (pageTagsRefs)
                    await $_getPrefetchedData<Page, $PagesTable, PageTag>(
                        currentTable: table,
                        referencedTable:
                            $$PagesTableReferences._pageTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PagesTableReferences(db, table, p0).pageTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pageId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PagesTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $PagesTable,
    Page,
    $$PagesTableFilterComposer,
    $$PagesTableOrderingComposer,
    $$PagesTableAnnotationComposer,
    $$PagesTableCreateCompanionBuilder,
    $$PagesTableUpdateCompanionBuilder,
    (Page, $$PagesTableReferences),
    Page,
    PrefetchHooks Function({bool blocksRefs, bool pageTagsRefs})>;
typedef $$BlocksTableCreateCompanionBuilder = BlocksCompanion Function({
  required String id,
  required String pageId,
  Value<String?> parentId,
  Value<String> content,
  Value<int> orderIndex,
  Value<int> indentLevel,
  Value<bool> isCollapsed,
  Value<String?> taskState,
  Value<DateTime?> scheduledAt,
  Value<DateTime?> deadlineAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$BlocksTableUpdateCompanionBuilder = BlocksCompanion Function({
  Value<String> id,
  Value<String> pageId,
  Value<String?> parentId,
  Value<String> content,
  Value<int> orderIndex,
  Value<int> indentLevel,
  Value<bool> isCollapsed,
  Value<String?> taskState,
  Value<DateTime?> scheduledAt,
  Value<DateTime?> deadlineAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$BlocksTableReferences
    extends BaseReferences<_$NexusBrainDatabase, $BlocksTable, Block> {
  $$BlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PagesTable _pageIdTable(_$NexusBrainDatabase db) =>
      db.pages.createAlias($_aliasNameGenerator(db.blocks.pageId, db.pages.id));

  $$PagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$PagesTableTableManager($_db, $_db.pages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BlocksTable _parentIdTable(_$NexusBrainDatabase db) => db.blocks
      .createAlias($_aliasNameGenerator(db.blocks.parentId, db.blocks.id));

  $$BlocksTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PageLinksTable, List<PageLink>>
      _pageLinksRefsTable(_$NexusBrainDatabase db) =>
          MultiTypedResultKey.fromTable(db.pageLinks,
              aliasName: $_aliasNameGenerator(
                  db.blocks.id, db.pageLinks.sourceBlockId));

  $$PageLinksTableProcessedTableManager get pageLinksRefs {
    final manager = $$PageLinksTableTableManager($_db, $_db.pageLinks).filter(
        (f) => f.sourceBlockId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pageLinksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BlocksTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $BlocksTable> {
  $$BlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get indentLevel => $composableBuilder(
      column: $table.indentLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskState => $composableBuilder(
      column: $table.taskState, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadlineAt => $composableBuilder(
      column: $table.deadlineAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$PagesTableFilterComposer get pageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableFilterComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableFilterComposer get parentId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> pageLinksRefs(
      Expression<bool> Function($$PageLinksTableFilterComposer f) f) {
    final $$PageLinksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageLinks,
        getReferencedColumn: (t) => t.sourceBlockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageLinksTableFilterComposer(
              $db: $db,
              $table: $db.pageLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlocksTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $BlocksTable> {
  $$BlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get indentLevel => $composableBuilder(
      column: $table.indentLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskState => $composableBuilder(
      column: $table.taskState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadlineAt => $composableBuilder(
      column: $table.deadlineAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$PagesTableOrderingComposer get pageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableOrderingComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableOrderingComposer get parentId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableOrderingComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlocksTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $BlocksTable> {
  $$BlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<int> get indentLevel => $composableBuilder(
      column: $table.indentLevel, builder: (column) => column);

  GeneratedColumn<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => column);

  GeneratedColumn<String> get taskState =>
      $composableBuilder(column: $table.taskState, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deadlineAt => $composableBuilder(
      column: $table.deadlineAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PagesTableAnnotationComposer get pageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableAnnotationComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableAnnotationComposer get parentId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> pageLinksRefs<T extends Object>(
      Expression<T> Function($$PageLinksTableAnnotationComposer a) f) {
    final $$PageLinksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageLinks,
        getReferencedColumn: (t) => t.sourceBlockId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageLinksTableAnnotationComposer(
              $db: $db,
              $table: $db.pageLinks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BlocksTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, $$BlocksTableReferences),
    Block,
    PrefetchHooks Function({bool pageId, bool parentId, bool pageLinksRefs})> {
  $$BlocksTableTableManager(_$NexusBrainDatabase db, $BlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> pageId = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> indentLevel = const Value.absent(),
            Value<bool> isCollapsed = const Value.absent(),
            Value<String?> taskState = const Value.absent(),
            Value<DateTime?> scheduledAt = const Value.absent(),
            Value<DateTime?> deadlineAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlocksCompanion(
            id: id,
            pageId: pageId,
            parentId: parentId,
            content: content,
            orderIndex: orderIndex,
            indentLevel: indentLevel,
            isCollapsed: isCollapsed,
            taskState: taskState,
            scheduledAt: scheduledAt,
            deadlineAt: deadlineAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String pageId,
            Value<String?> parentId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> indentLevel = const Value.absent(),
            Value<bool> isCollapsed = const Value.absent(),
            Value<String?> taskState = const Value.absent(),
            Value<DateTime?> scheduledAt = const Value.absent(),
            Value<DateTime?> deadlineAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlocksCompanion.insert(
            id: id,
            pageId: pageId,
            parentId: parentId,
            content: content,
            orderIndex: orderIndex,
            indentLevel: indentLevel,
            isCollapsed: isCollapsed,
            taskState: taskState,
            scheduledAt: scheduledAt,
            deadlineAt: deadlineAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BlocksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {pageId = false, parentId = false, pageLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pageLinksRefs) db.pageLinks],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pageId,
                    referencedTable: $$BlocksTableReferences._pageIdTable(db),
                    referencedColumn:
                        $$BlocksTableReferences._pageIdTable(db).id,
                  ) as T;
                }
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable: $$BlocksTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$BlocksTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pageLinksRefs)
                    await $_getPrefetchedData<Block, $BlocksTable, PageLink>(
                        currentTable: table,
                        referencedTable:
                            $$BlocksTableReferences._pageLinksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BlocksTableReferences(db, table, p0)
                                .pageLinksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sourceBlockId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BlocksTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, $$BlocksTableReferences),
    Block,
    PrefetchHooks Function({bool pageId, bool parentId, bool pageLinksRefs})>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  Value<String?> color,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> color,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$NexusBrainDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PageTagsTable, List<PageTag>> _pageTagsRefsTable(
          _$NexusBrainDatabase db) =>
      MultiTypedResultKey.fromTable(db.pageTags,
          aliasName: $_aliasNameGenerator(db.tags.id, db.pageTags.tagId));

  $$PageTagsTableProcessedTableManager get pageTagsRefs {
    final manager = $$PageTagsTableTableManager($_db, $_db.pageTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pageTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagsTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> pageTagsRefs(
      Expression<bool> Function($$PageTagsTableFilterComposer f) f) {
    final $$PageTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageTagsTableFilterComposer(
              $db: $db,
              $table: $db.pageTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> pageTagsRefs<T extends Object>(
      Expression<T> Function($$PageTagsTableAnnotationComposer a) f) {
    final $$PageTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pageTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PageTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.pageTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool pageTagsRefs})> {
  $$TagsTableTableManager(_$NexusBrainDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> color = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            color: color,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({pageTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pageTagsRefs) db.pageTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pageTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, PageTag>(
                        currentTable: table,
                        referencedTable:
                            $$TagsTableReferences._pageTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagsTableReferences(db, table, p0).pageTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool pageTagsRefs})>;
typedef $$PageTagsTableCreateCompanionBuilder = PageTagsCompanion Function({
  required String pageId,
  required String tagId,
  Value<int> rowid,
});
typedef $$PageTagsTableUpdateCompanionBuilder = PageTagsCompanion Function({
  Value<String> pageId,
  Value<String> tagId,
  Value<int> rowid,
});

final class $$PageTagsTableReferences
    extends BaseReferences<_$NexusBrainDatabase, $PageTagsTable, PageTag> {
  $$PageTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PagesTable _pageIdTable(_$NexusBrainDatabase db) => db.pages
      .createAlias($_aliasNameGenerator(db.pageTags.pageId, db.pages.id));

  $$PagesTableProcessedTableManager get pageId {
    final $_column = $_itemColumn<String>('page_id')!;

    final manager = $$PagesTableTableManager($_db, $_db.pages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TagsTable _tagIdTable(_$NexusBrainDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.pageTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PageTagsTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $PageTagsTable> {
  $$PageTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PagesTableFilterComposer get pageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableFilterComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageTagsTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $PageTagsTable> {
  $$PageTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PagesTableOrderingComposer get pageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableOrderingComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableOrderingComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageTagsTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $PageTagsTable> {
  $$PageTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$PagesTableAnnotationComposer get pageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableAnnotationComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageTagsTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $PageTagsTable,
    PageTag,
    $$PageTagsTableFilterComposer,
    $$PageTagsTableOrderingComposer,
    $$PageTagsTableAnnotationComposer,
    $$PageTagsTableCreateCompanionBuilder,
    $$PageTagsTableUpdateCompanionBuilder,
    (PageTag, $$PageTagsTableReferences),
    PageTag,
    PrefetchHooks Function({bool pageId, bool tagId})> {
  $$PageTagsTableTableManager(_$NexusBrainDatabase db, $PageTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PageTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PageTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PageTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> pageId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PageTagsCompanion(
            pageId: pageId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String pageId,
            required String tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              PageTagsCompanion.insert(
            pageId: pageId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PageTagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({pageId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pageId,
                    referencedTable: $$PageTagsTableReferences._pageIdTable(db),
                    referencedColumn:
                        $$PageTagsTableReferences._pageIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable: $$PageTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$PageTagsTableReferences._tagIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PageTagsTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $PageTagsTable,
    PageTag,
    $$PageTagsTableFilterComposer,
    $$PageTagsTableOrderingComposer,
    $$PageTagsTableAnnotationComposer,
    $$PageTagsTableCreateCompanionBuilder,
    $$PageTagsTableUpdateCompanionBuilder,
    (PageTag, $$PageTagsTableReferences),
    PageTag,
    PrefetchHooks Function({bool pageId, bool tagId})>;
typedef $$PageLinksTableCreateCompanionBuilder = PageLinksCompanion Function({
  required String sourcePageId,
  required String targetPageId,
  Value<String?> sourceBlockId,
  Value<String> linkType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PageLinksTableUpdateCompanionBuilder = PageLinksCompanion Function({
  Value<String> sourcePageId,
  Value<String> targetPageId,
  Value<String?> sourceBlockId,
  Value<String> linkType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PageLinksTableReferences
    extends BaseReferences<_$NexusBrainDatabase, $PageLinksTable, PageLink> {
  $$PageLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PagesTable _sourcePageIdTable(_$NexusBrainDatabase db) =>
      db.pages.createAlias(
          $_aliasNameGenerator(db.pageLinks.sourcePageId, db.pages.id));

  $$PagesTableProcessedTableManager get sourcePageId {
    final $_column = $_itemColumn<String>('source_page_id')!;

    final manager = $$PagesTableTableManager($_db, $_db.pages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourcePageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PagesTable _targetPageIdTable(_$NexusBrainDatabase db) =>
      db.pages.createAlias(
          $_aliasNameGenerator(db.pageLinks.targetPageId, db.pages.id));

  $$PagesTableProcessedTableManager get targetPageId {
    final $_column = $_itemColumn<String>('target_page_id')!;

    final manager = $$PagesTableTableManager($_db, $_db.pages)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetPageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BlocksTable _sourceBlockIdTable(_$NexusBrainDatabase db) =>
      db.blocks.createAlias(
          $_aliasNameGenerator(db.pageLinks.sourceBlockId, db.blocks.id));

  $$BlocksTableProcessedTableManager? get sourceBlockId {
    final $_column = $_itemColumn<String>('source_block_id');
    if ($_column == null) return null;
    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceBlockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PageLinksTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $PageLinksTable> {
  $$PageLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get linkType => $composableBuilder(
      column: $table.linkType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PagesTableFilterComposer get sourcePageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourcePageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableFilterComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PagesTableFilterComposer get targetPageId {
    final $$PagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetPageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableFilterComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableFilterComposer get sourceBlockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageLinksTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $PageLinksTable> {
  $$PageLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get linkType => $composableBuilder(
      column: $table.linkType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PagesTableOrderingComposer get sourcePageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourcePageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableOrderingComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PagesTableOrderingComposer get targetPageId {
    final $$PagesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetPageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableOrderingComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableOrderingComposer get sourceBlockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableOrderingComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageLinksTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $PageLinksTable> {
  $$PageLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get linkType =>
      $composableBuilder(column: $table.linkType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PagesTableAnnotationComposer get sourcePageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourcePageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableAnnotationComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PagesTableAnnotationComposer get targetPageId {
    final $$PagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetPageId,
        referencedTable: $db.pages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagesTableAnnotationComposer(
              $db: $db,
              $table: $db.pages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableAnnotationComposer get sourceBlockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PageLinksTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $PageLinksTable,
    PageLink,
    $$PageLinksTableFilterComposer,
    $$PageLinksTableOrderingComposer,
    $$PageLinksTableAnnotationComposer,
    $$PageLinksTableCreateCompanionBuilder,
    $$PageLinksTableUpdateCompanionBuilder,
    (PageLink, $$PageLinksTableReferences),
    PageLink,
    PrefetchHooks Function(
        {bool sourcePageId, bool targetPageId, bool sourceBlockId})> {
  $$PageLinksTableTableManager(_$NexusBrainDatabase db, $PageLinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PageLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PageLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PageLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sourcePageId = const Value.absent(),
            Value<String> targetPageId = const Value.absent(),
            Value<String?> sourceBlockId = const Value.absent(),
            Value<String> linkType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PageLinksCompanion(
            sourcePageId: sourcePageId,
            targetPageId: targetPageId,
            sourceBlockId: sourceBlockId,
            linkType: linkType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sourcePageId,
            required String targetPageId,
            Value<String?> sourceBlockId = const Value.absent(),
            Value<String> linkType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PageLinksCompanion.insert(
            sourcePageId: sourcePageId,
            targetPageId: targetPageId,
            sourceBlockId: sourceBlockId,
            linkType: linkType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PageLinksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourcePageId = false,
              targetPageId = false,
              sourceBlockId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sourcePageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourcePageId,
                    referencedTable:
                        $$PageLinksTableReferences._sourcePageIdTable(db),
                    referencedColumn:
                        $$PageLinksTableReferences._sourcePageIdTable(db).id,
                  ) as T;
                }
                if (targetPageId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetPageId,
                    referencedTable:
                        $$PageLinksTableReferences._targetPageIdTable(db),
                    referencedColumn:
                        $$PageLinksTableReferences._targetPageIdTable(db).id,
                  ) as T;
                }
                if (sourceBlockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceBlockId,
                    referencedTable:
                        $$PageLinksTableReferences._sourceBlockIdTable(db),
                    referencedColumn:
                        $$PageLinksTableReferences._sourceBlockIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PageLinksTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $PageLinksTable,
    PageLink,
    $$PageLinksTableFilterComposer,
    $$PageLinksTableOrderingComposer,
    $$PageLinksTableAnnotationComposer,
    $$PageLinksTableCreateCompanionBuilder,
    $$PageLinksTableUpdateCompanionBuilder,
    (PageLink, $$PageLinksTableReferences),
    PageLink,
    PrefetchHooks Function(
        {bool sourcePageId, bool targetPageId, bool sourceBlockId})>;
typedef $$BlockReferencesTableCreateCompanionBuilder = BlockReferencesCompanion
    Function({
  required String sourceBlockId,
  required String targetBlockId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BlockReferencesTableUpdateCompanionBuilder = BlockReferencesCompanion
    Function({
  Value<String> sourceBlockId,
  Value<String> targetBlockId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BlockReferencesTableReferences extends BaseReferences<
    _$NexusBrainDatabase, $BlockReferencesTable, BlockReference> {
  $$BlockReferencesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BlocksTable _sourceBlockIdTable(_$NexusBrainDatabase db) =>
      db.blocks.createAlias(
          $_aliasNameGenerator(db.blockReferences.sourceBlockId, db.blocks.id));

  $$BlocksTableProcessedTableManager get sourceBlockId {
    final $_column = $_itemColumn<String>('source_block_id')!;

    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceBlockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $BlocksTable _targetBlockIdTable(_$NexusBrainDatabase db) =>
      db.blocks.createAlias(
          $_aliasNameGenerator(db.blockReferences.targetBlockId, db.blocks.id));

  $$BlocksTableProcessedTableManager get targetBlockId {
    final $_column = $_itemColumn<String>('target_block_id')!;

    final manager = $$BlocksTableTableManager($_db, $_db.blocks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetBlockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BlockReferencesTableFilterComposer
    extends Composer<_$NexusBrainDatabase, $BlockReferencesTable> {
  $$BlockReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$BlocksTableFilterComposer get sourceBlockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableFilterComposer get targetBlockId {
    final $$BlocksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableFilterComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockReferencesTableOrderingComposer
    extends Composer<_$NexusBrainDatabase, $BlockReferencesTable> {
  $$BlockReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$BlocksTableOrderingComposer get sourceBlockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableOrderingComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableOrderingComposer get targetBlockId {
    final $$BlocksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableOrderingComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockReferencesTableAnnotationComposer
    extends Composer<_$NexusBrainDatabase, $BlockReferencesTable> {
  $$BlockReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BlocksTableAnnotationComposer get sourceBlockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$BlocksTableAnnotationComposer get targetBlockId {
    final $$BlocksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetBlockId,
        referencedTable: $db.blocks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BlocksTableAnnotationComposer(
              $db: $db,
              $table: $db.blocks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BlockReferencesTableTableManager extends RootTableManager<
    _$NexusBrainDatabase,
    $BlockReferencesTable,
    BlockReference,
    $$BlockReferencesTableFilterComposer,
    $$BlockReferencesTableOrderingComposer,
    $$BlockReferencesTableAnnotationComposer,
    $$BlockReferencesTableCreateCompanionBuilder,
    $$BlockReferencesTableUpdateCompanionBuilder,
    (BlockReference, $$BlockReferencesTableReferences),
    BlockReference,
    PrefetchHooks Function({bool sourceBlockId, bool targetBlockId})> {
  $$BlockReferencesTableTableManager(
      _$NexusBrainDatabase db, $BlockReferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> sourceBlockId = const Value.absent(),
            Value<String> targetBlockId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlockReferencesCompanion(
            sourceBlockId: sourceBlockId,
            targetBlockId: targetBlockId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String sourceBlockId,
            required String targetBlockId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlockReferencesCompanion.insert(
            sourceBlockId: sourceBlockId,
            targetBlockId: targetBlockId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BlockReferencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {sourceBlockId = false, targetBlockId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sourceBlockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceBlockId,
                    referencedTable: $$BlockReferencesTableReferences
                        ._sourceBlockIdTable(db),
                    referencedColumn: $$BlockReferencesTableReferences
                        ._sourceBlockIdTable(db)
                        .id,
                  ) as T;
                }
                if (targetBlockId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetBlockId,
                    referencedTable: $$BlockReferencesTableReferences
                        ._targetBlockIdTable(db),
                    referencedColumn: $$BlockReferencesTableReferences
                        ._targetBlockIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BlockReferencesTableProcessedTableManager = ProcessedTableManager<
    _$NexusBrainDatabase,
    $BlockReferencesTable,
    BlockReference,
    $$BlockReferencesTableFilterComposer,
    $$BlockReferencesTableOrderingComposer,
    $$BlockReferencesTableAnnotationComposer,
    $$BlockReferencesTableCreateCompanionBuilder,
    $$BlockReferencesTableUpdateCompanionBuilder,
    (BlockReference, $$BlockReferencesTableReferences),
    BlockReference,
    PrefetchHooks Function({bool sourceBlockId, bool targetBlockId})>;

class $NexusBrainDatabaseManager {
  final _$NexusBrainDatabase _db;
  $NexusBrainDatabaseManager(this._db);
  $$PagesTableTableManager get pages =>
      $$PagesTableTableManager(_db, _db.pages);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db, _db.blocks);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$PageTagsTableTableManager get pageTags =>
      $$PageTagsTableTableManager(_db, _db.pageTags);
  $$PageLinksTableTableManager get pageLinks =>
      $$PageLinksTableTableManager(_db, _db.pageLinks);
  $$BlockReferencesTableTableManager get blockReferences =>
      $$BlockReferencesTableTableManager(_db, _db.blockReferences);
}
