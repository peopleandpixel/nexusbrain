// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBlockCollection on Isar {
  IsarCollection<Block> get blocks => this.collection();
}

const BlockSchema = CollectionSchema(
  name: r'Block',
  id: -1408548915874355664,
  properties: {
    r'blockId': PropertySchema(
      id: 0,
      name: r'blockId',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'content': PropertySchema(
      id: 2,
      name: r'content',
      type: IsarType.string,
    ),
    r'contentWords': PropertySchema(
      id: 3,
      name: r'contentWords',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deadlineAt': PropertySchema(
      id: 5,
      name: r'deadlineAt',
      type: IsarType.dateTime,
    ),
    r'hasBlockRefs': PropertySchema(
      id: 6,
      name: r'hasBlockRefs',
      type: IsarType.bool,
    ),
    r'hasPageLinks': PropertySchema(
      id: 7,
      name: r'hasPageLinks',
      type: IsarType.bool,
    ),
    r'indentLevel': PropertySchema(
      id: 8,
      name: r'indentLevel',
      type: IsarType.long,
    ),
    r'isCollapsed': PropertySchema(
      id: 9,
      name: r'isCollapsed',
      type: IsarType.bool,
    ),
    r'isCompletedTask': PropertySchema(
      id: 10,
      name: r'isCompletedTask',
      type: IsarType.bool,
    ),
    r'isOpenTask': PropertySchema(
      id: 11,
      name: r'isOpenTask',
      type: IsarType.bool,
    ),
    r'isOverdue': PropertySchema(
      id: 12,
      name: r'isOverdue',
      type: IsarType.bool,
    ),
    r'isTask': PropertySchema(
      id: 13,
      name: r'isTask',
      type: IsarType.bool,
    ),
    r'linkedPageTitles': PropertySchema(
      id: 14,
      name: r'linkedPageTitles',
      type: IsarType.stringList,
    ),
    r'orderIndex': PropertySchema(
      id: 15,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'pageId': PropertySchema(
      id: 16,
      name: r'pageId',
      type: IsarType.string,
    ),
    r'parentId': PropertySchema(
      id: 17,
      name: r'parentId',
      type: IsarType.string,
    ),
    r'preview': PropertySchema(
      id: 18,
      name: r'preview',
      type: IsarType.string,
    ),
    r'referencedBlockIds': PropertySchema(
      id: 19,
      name: r'referencedBlockIds',
      type: IsarType.stringList,
    ),
    r'scheduledAt': PropertySchema(
      id: 20,
      name: r'scheduledAt',
      type: IsarType.dateTime,
    ),
    r'taskColor': PropertySchema(
      id: 21,
      name: r'taskColor',
      type: IsarType.long,
    ),
    r'taskIcon': PropertySchema(
      id: 22,
      name: r'taskIcon',
      type: IsarType.string,
    ),
    r'taskState': PropertySchema(
      id: 23,
      name: r'taskState',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 24,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _blockEstimateSize,
  serialize: _blockSerialize,
  deserialize: _blockDeserialize,
  deserializeProp: _blockDeserializeProp,
  idName: r'id',
  indexes: {
    r'blockId': IndexSchema(
      id: -413886092950911832,
      name: r'blockId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'blockId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'pageId': IndexSchema(
      id: 3928962759474932809,
      name: r'pageId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'pageId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'contentWords': IndexSchema(
      id: -9211142823111558917,
      name: r'contentWords',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'contentWords',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _blockGetId,
  getLinks: _blockGetLinks,
  attach: _blockAttach,
  version: '3.3.2',
);

int _blockEstimateSize(
  Block object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.blockId.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.contentWords.length * 3;
  {
    for (var i = 0; i < object.contentWords.length; i++) {
      final value = object.contentWords[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.linkedPageTitles.length * 3;
  {
    for (var i = 0; i < object.linkedPageTitles.length; i++) {
      final value = object.linkedPageTitles[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.pageId.length * 3;
  {
    final value = object.parentId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.preview.length * 3;
  bytesCount += 3 + object.referencedBlockIds.length * 3;
  {
    for (var i = 0; i < object.referencedBlockIds.length; i++) {
      final value = object.referencedBlockIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.taskIcon.length * 3;
  {
    final value = object.taskState;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _blockSerialize(
  Block object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.blockId);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeString(offsets[2], object.content);
  writer.writeStringList(offsets[3], object.contentWords);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDateTime(offsets[5], object.deadlineAt);
  writer.writeBool(offsets[6], object.hasBlockRefs);
  writer.writeBool(offsets[7], object.hasPageLinks);
  writer.writeLong(offsets[8], object.indentLevel);
  writer.writeBool(offsets[9], object.isCollapsed);
  writer.writeBool(offsets[10], object.isCompletedTask);
  writer.writeBool(offsets[11], object.isOpenTask);
  writer.writeBool(offsets[12], object.isOverdue);
  writer.writeBool(offsets[13], object.isTask);
  writer.writeStringList(offsets[14], object.linkedPageTitles);
  writer.writeLong(offsets[15], object.orderIndex);
  writer.writeString(offsets[16], object.pageId);
  writer.writeString(offsets[17], object.parentId);
  writer.writeString(offsets[18], object.preview);
  writer.writeStringList(offsets[19], object.referencedBlockIds);
  writer.writeDateTime(offsets[20], object.scheduledAt);
  writer.writeLong(offsets[21], object.taskColor);
  writer.writeString(offsets[22], object.taskIcon);
  writer.writeString(offsets[23], object.taskState);
  writer.writeDateTime(offsets[24], object.updatedAt);
}

Block _blockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Block(
    blockId: reader.readString(offsets[0]),
    completedAt: reader.readDateTimeOrNull(offsets[1]),
    content: reader.readStringOrNull(offsets[2]) ?? '',
    createdAt: reader.readDateTimeOrNull(offsets[4]),
    deadlineAt: reader.readDateTimeOrNull(offsets[5]),
    indentLevel: reader.readLongOrNull(offsets[8]) ?? 0,
    isCollapsed: reader.readBoolOrNull(offsets[9]) ?? false,
    orderIndex: reader.readLongOrNull(offsets[15]) ?? 0,
    pageId: reader.readString(offsets[16]),
    parentId: reader.readStringOrNull(offsets[17]),
    scheduledAt: reader.readDateTimeOrNull(offsets[20]),
    taskState: reader.readStringOrNull(offsets[23]),
    updatedAt: reader.readDateTimeOrNull(offsets[24]),
  );
  object.id = id;
  return object;
}

P _blockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readStringList(offset) ?? []) as P;
    case 15:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readStringList(offset) ?? []) as P;
    case 20:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _blockGetId(Block object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _blockGetLinks(Block object) {
  return [];
}

void _blockAttach(IsarCollection<dynamic> col, Id id, Block object) {
  object.id = id;
}

extension BlockQueryWhereSort on QueryBuilder<Block, Block, QWhere> {
  QueryBuilder<Block, Block, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Block, Block, QAfterWhere> anyContentWordsElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'contentWords'),
      );
    });
  }
}

extension BlockQueryWhere on QueryBuilder<Block, Block, QWhereClause> {
  QueryBuilder<Block, Block, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> blockIdEqualTo(String blockId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'blockId',
        value: [blockId],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> blockIdNotEqualTo(
      String blockId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [],
              upper: [blockId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [blockId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [blockId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [],
              upper: [blockId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> pageIdEqualTo(String pageId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'pageId',
        value: [pageId],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> pageIdNotEqualTo(
      String pageId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageId',
              lower: [],
              upper: [pageId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageId',
              lower: [pageId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageId',
              lower: [pageId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'pageId',
              lower: [],
              upper: [pageId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementEqualTo(
      String contentWordsElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentWords',
        value: [contentWordsElement],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementNotEqualTo(
      String contentWordsElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [],
              upper: [contentWordsElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [contentWordsElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [contentWordsElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentWords',
              lower: [],
              upper: [contentWordsElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementGreaterThan(
    String contentWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [contentWordsElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementLessThan(
    String contentWordsElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [],
        upper: [contentWordsElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementBetween(
    String lowerContentWordsElement,
    String upperContentWordsElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [lowerContentWordsElement],
        includeLower: includeLower,
        upper: [upperContentWordsElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementStartsWith(
      String ContentWordsElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentWords',
        lower: [ContentWordsElementPrefix],
        upper: ['$ContentWordsElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause> contentWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentWords',
        value: [''],
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterWhereClause>
      contentWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'contentWords',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'contentWords',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'contentWords',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'contentWords',
              upper: [''],
            ));
      }
    });
  }
}

extension BlockQueryFilter on QueryBuilder<Block, Block, QFilterCondition> {
  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> blockIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      contentWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      contentWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      contentWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      contentWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentWords',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      contentWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> contentWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contentWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deadlineAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deadlineAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deadlineAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deadlineAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deadlineAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> deadlineAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deadlineAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> hasBlockRefsEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasBlockRefs',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> hasPageLinksEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasPageLinks',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> indentLevelEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> indentLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'indentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> indentLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'indentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> indentLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'indentLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> isCollapsedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCollapsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> isCompletedTaskEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompletedTask',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> isOpenTaskEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOpenTask',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> isOverdueEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOverdue',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> isTaskEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTask',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedPageTitles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedPageTitles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedPageTitles',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedPageTitles',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedPageTitles',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> linkedPageTitlesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      linkedPageTitlesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'linkedPageTitles',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> orderIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pageId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pageId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> pageIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pageId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentId',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentId',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> parentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentId',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preview',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preview',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preview',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> previewIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preview',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referencedBlockIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'referencedBlockIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'referencedBlockIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referencedBlockIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'referencedBlockIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition>
      referencedBlockIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'referencedBlockIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> scheduledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskColor',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskIcon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskIcon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskIcon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskIconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskIcon',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskState',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskState',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskState',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> taskStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskState',
        value: '',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Block, Block, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BlockQueryObject on QueryBuilder<Block, Block, QFilterCondition> {}

extension BlockQueryLinks on QueryBuilder<Block, Block, QFilterCondition> {}

extension BlockQuerySortBy on QueryBuilder<Block, Block, QSortBy> {
  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByDeadlineAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deadlineAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByDeadlineAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deadlineAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByHasBlockRefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasBlockRefs', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByHasBlockRefsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasBlockRefs', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByHasPageLinks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPageLinks', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByHasPageLinksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPageLinks', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIndentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indentLevel', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIndentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indentLevel', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsCollapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCollapsed', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsCollapsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCollapsed', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsCompletedTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsCompletedTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsOpenTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpenTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsOpenTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpenTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByIsTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskColor', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskColor', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskIcon', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskIcon', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskState', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByTaskStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskState', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BlockQuerySortThenBy on QueryBuilder<Block, Block, QSortThenBy> {
  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByDeadlineAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deadlineAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByDeadlineAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deadlineAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByHasBlockRefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasBlockRefs', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByHasBlockRefsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasBlockRefs', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByHasPageLinks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPageLinks', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByHasPageLinksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPageLinks', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIndentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indentLevel', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIndentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indentLevel', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsCollapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCollapsed', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsCollapsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCollapsed', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsCompletedTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsCompletedTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompletedTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsOpenTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpenTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsOpenTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpenTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsOverdueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOverdue', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTask', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByIsTaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTask', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPageId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPageIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByParentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByParentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentId', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPreview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByPreviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preview', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskColor', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskColor', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskIcon', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskIcon', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskState', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByTaskStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskState', Sort.desc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Block, Block, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BlockQueryWhereDistinct on QueryBuilder<Block, Block, QDistinct> {
  QueryBuilder<Block, Block, QDistinct> distinctByBlockId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByContentWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentWords');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByDeadlineAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deadlineAt');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByHasBlockRefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasBlockRefs');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByHasPageLinks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasPageLinks');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIndentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'indentLevel');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIsCollapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCollapsed');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIsCompletedTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompletedTask');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIsOpenTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOpenTask');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIsOverdue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOverdue');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByIsTask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTask');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByLinkedPageTitles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedPageTitles');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByPageId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByParentId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByPreview(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preview', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByReferencedBlockIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referencedBlockIds');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAt');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByTaskColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskColor');
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByTaskIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskIcon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByTaskState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Block, Block, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BlockQueryProperty on QueryBuilder<Block, Block, QQueryProperty> {
  QueryBuilder<Block, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Block, String, QQueryOperations> blockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockId');
    });
  }

  QueryBuilder<Block, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<Block, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<Block, List<String>, QQueryOperations> contentWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentWords');
    });
  }

  QueryBuilder<Block, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Block, DateTime?, QQueryOperations> deadlineAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deadlineAt');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> hasBlockRefsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasBlockRefs');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> hasPageLinksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasPageLinks');
    });
  }

  QueryBuilder<Block, int, QQueryOperations> indentLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'indentLevel');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> isCollapsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCollapsed');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> isCompletedTaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompletedTask');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> isOpenTaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOpenTask');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> isOverdueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOverdue');
    });
  }

  QueryBuilder<Block, bool, QQueryOperations> isTaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTask');
    });
  }

  QueryBuilder<Block, List<String>, QQueryOperations>
      linkedPageTitlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedPageTitles');
    });
  }

  QueryBuilder<Block, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<Block, String, QQueryOperations> pageIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageId');
    });
  }

  QueryBuilder<Block, String?, QQueryOperations> parentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentId');
    });
  }

  QueryBuilder<Block, String, QQueryOperations> previewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preview');
    });
  }

  QueryBuilder<Block, List<String>, QQueryOperations>
      referencedBlockIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referencedBlockIds');
    });
  }

  QueryBuilder<Block, DateTime?, QQueryOperations> scheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAt');
    });
  }

  QueryBuilder<Block, int, QQueryOperations> taskColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskColor');
    });
  }

  QueryBuilder<Block, String, QQueryOperations> taskIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskIcon');
    });
  }

  QueryBuilder<Block, String?, QQueryOperations> taskStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskState');
    });
  }

  QueryBuilder<Block, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
