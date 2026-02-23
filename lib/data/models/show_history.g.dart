// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShowHistoryCollection on Isar {
  IsarCollection<ShowHistory> get showHistorys => this.collection();
}

const ShowHistorySchema = CollectionSchema(
  name: r'ShowHistory',
  id: -4118309659678317111,
  properties: {
    r'attendance': PropertySchema(
      id: 0,
      name: r'attendance',
      type: IsarType.long,
    ),
    r'avgRating': PropertySchema(
      id: 1,
      name: r'avgRating',
      type: IsarType.double,
    ),
    r'highlights': PropertySchema(
      id: 2,
      name: r'highlights',
      type: IsarType.stringList,
    ),
    r'showName': PropertySchema(
      id: 3,
      name: r'showName',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 4,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'totalProfit': PropertySchema(
      id: 5,
      name: r'totalProfit',
      type: IsarType.long,
    ),
    r'week': PropertySchema(
      id: 6,
      name: r'week',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 7,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _showHistoryEstimateSize,
  serialize: _showHistorySerialize,
  deserialize: _showHistoryDeserialize,
  deserializeProp: _showHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'matches': LinkSchema(
      id: -7167609467175284141,
      name: r'matches',
      target: r'Match',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _showHistoryGetId,
  getLinks: _showHistoryGetLinks,
  attach: _showHistoryAttach,
  version: '3.1.0+1',
);

int _showHistoryEstimateSize(
  ShowHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.highlights.length * 3;
  {
    for (var i = 0; i < object.highlights.length; i++) {
      final value = object.highlights[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.showName.length * 3;
  return bytesCount;
}

void _showHistorySerialize(
  ShowHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attendance);
  writer.writeDouble(offsets[1], object.avgRating);
  writer.writeStringList(offsets[2], object.highlights);
  writer.writeString(offsets[3], object.showName);
  writer.writeDateTime(offsets[4], object.timestamp);
  writer.writeLong(offsets[5], object.totalProfit);
  writer.writeLong(offsets[6], object.week);
  writer.writeLong(offsets[7], object.year);
}

ShowHistory _showHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShowHistory();
  object.attendance = reader.readLong(offsets[0]);
  object.avgRating = reader.readDouble(offsets[1]);
  object.highlights = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.showName = reader.readString(offsets[3]);
  object.timestamp = reader.readDateTime(offsets[4]);
  object.totalProfit = reader.readLong(offsets[5]);
  object.week = reader.readLong(offsets[6]);
  object.year = reader.readLong(offsets[7]);
  return object;
}

P _showHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _showHistoryGetId(ShowHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _showHistoryGetLinks(ShowHistory object) {
  return [object.matches];
}

void _showHistoryAttach(
    IsarCollection<dynamic> col, Id id, ShowHistory object) {
  object.id = id;
  object.matches.attach(col, col.isar.collection<Match>(), r'matches', id);
}

extension ShowHistoryQueryWhereSort
    on QueryBuilder<ShowHistory, ShowHistory, QWhere> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension ShowHistoryQueryWhere
    on QueryBuilder<ShowHistory, ShowHistory, QWhereClause> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> idBetween(
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

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> timestampEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> timestampNotEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause>
      timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShowHistoryQueryFilter
    on QueryBuilder<ShowHistory, ShowHistory, QFilterCondition> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      attendanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendance',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      attendanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attendance',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      attendanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attendance',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      attendanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attendance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      avgRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      avgRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      avgRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      avgRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highlights',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'highlights',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'highlights',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlights',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'highlights',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      highlightsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'highlights',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> showNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> showNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'showName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> showNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'showName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      showNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'showName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      totalProfitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalProfit',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      totalProfitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalProfit',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      totalProfitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalProfit',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      totalProfitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalProfit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> weekEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> weekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> weekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> weekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'week',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShowHistoryQueryObject
    on QueryBuilder<ShowHistory, ShowHistory, QFilterCondition> {}

extension ShowHistoryQueryLinks
    on QueryBuilder<ShowHistory, ShowHistory, QFilterCondition> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition> matches(
      FilterQuery<Match> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'matches');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'matches', length, true, length, true);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'matches', 0, true, 0, true);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'matches', 0, false, 999999, true);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'matches', 0, true, length, include);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'matches', length, include, 999999, true);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterFilterCondition>
      matchesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'matches', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ShowHistoryQuerySortBy
    on QueryBuilder<ShowHistory, ShowHistory, QSortBy> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByAvgRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgRating', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByAvgRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgRating', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByTotalProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension ShowHistoryQuerySortThenBy
    on QueryBuilder<ShowHistory, ShowHistory, QSortThenBy> {
  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendance', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByAvgRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgRating', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByAvgRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgRating', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByTotalProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension ShowHistoryQueryWhereDistinct
    on QueryBuilder<ShowHistory, ShowHistory, QDistinct> {
  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendance');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByAvgRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgRating');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByHighlights() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highlights');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByShowName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalProfit');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'week');
    });
  }

  QueryBuilder<ShowHistory, ShowHistory, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension ShowHistoryQueryProperty
    on QueryBuilder<ShowHistory, ShowHistory, QQueryProperty> {
  QueryBuilder<ShowHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShowHistory, int, QQueryOperations> attendanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendance');
    });
  }

  QueryBuilder<ShowHistory, double, QQueryOperations> avgRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgRating');
    });
  }

  QueryBuilder<ShowHistory, List<String>, QQueryOperations>
      highlightsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highlights');
    });
  }

  QueryBuilder<ShowHistory, String, QQueryOperations> showNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showName');
    });
  }

  QueryBuilder<ShowHistory, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<ShowHistory, int, QQueryOperations> totalProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalProfit');
    });
  }

  QueryBuilder<ShowHistory, int, QQueryOperations> weekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'week');
    });
  }

  QueryBuilder<ShowHistory, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
