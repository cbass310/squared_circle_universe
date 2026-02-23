// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rivalry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRivalryCollection on Isar {
  IsarCollection<Rivalry> get rivalrys => this.collection();
}

const RivalrySchema = CollectionSchema(
  name: r'Rivalry',
  id: 6984051708322725130,
  properties: {
    r'durationWeeks': PropertySchema(
      id: 0,
      name: r'durationWeeks',
      type: IsarType.long,
    ),
    r'heat': PropertySchema(
      id: 1,
      name: r'heat',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 2,
      name: r'status',
      type: IsarType.byte,
      enumMap: _RivalrystatusEnumValueMap,
    ),
    r'wrestler1Name': PropertySchema(
      id: 3,
      name: r'wrestler1Name',
      type: IsarType.string,
    ),
    r'wrestler2Name': PropertySchema(
      id: 4,
      name: r'wrestler2Name',
      type: IsarType.string,
    )
  },
  estimateSize: _rivalryEstimateSize,
  serialize: _rivalrySerialize,
  deserialize: _rivalryDeserialize,
  deserializeProp: _rivalryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _rivalryGetId,
  getLinks: _rivalryGetLinks,
  attach: _rivalryAttach,
  version: '3.1.0+1',
);

int _rivalryEstimateSize(
  Rivalry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.wrestler1Name.length * 3;
  bytesCount += 3 + object.wrestler2Name.length * 3;
  return bytesCount;
}

void _rivalrySerialize(
  Rivalry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationWeeks);
  writer.writeLong(offsets[1], object.heat);
  writer.writeByte(offsets[2], object.status.index);
  writer.writeString(offsets[3], object.wrestler1Name);
  writer.writeString(offsets[4], object.wrestler2Name);
}

Rivalry _rivalryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Rivalry(
    durationWeeks: reader.readLongOrNull(offsets[0]) ?? 0,
    heat: reader.readLongOrNull(offsets[1]) ?? 0,
    status: _RivalrystatusValueEnumMap[reader.readByteOrNull(offsets[2])] ??
        RivalryStatus.active,
    wrestler1Name: reader.readString(offsets[3]),
    wrestler2Name: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _rivalryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (_RivalrystatusValueEnumMap[reader.readByteOrNull(offset)] ??
          RivalryStatus.active) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RivalrystatusEnumValueMap = {
  'active': 0,
  'coolingDown': 1,
  'concluded': 2,
};
const _RivalrystatusValueEnumMap = {
  0: RivalryStatus.active,
  1: RivalryStatus.coolingDown,
  2: RivalryStatus.concluded,
};

Id _rivalryGetId(Rivalry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rivalryGetLinks(Rivalry object) {
  return [];
}

void _rivalryAttach(IsarCollection<dynamic> col, Id id, Rivalry object) {
  object.id = id;
}

extension RivalryQueryWhereSort on QueryBuilder<Rivalry, Rivalry, QWhere> {
  QueryBuilder<Rivalry, Rivalry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RivalryQueryWhere on QueryBuilder<Rivalry, Rivalry, QWhereClause> {
  QueryBuilder<Rivalry, Rivalry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Rivalry, Rivalry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterWhereClause> idBetween(
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
}

extension RivalryQueryFilter
    on QueryBuilder<Rivalry, Rivalry, QFilterCondition> {
  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> durationWeeksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition>
      durationWeeksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> durationWeeksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> durationWeeksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> heatEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heat',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> heatGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heat',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> heatLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heat',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> heatBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> statusEqualTo(
      RivalryStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> statusGreaterThan(
    RivalryStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> statusLessThan(
    RivalryStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> statusBetween(
    RivalryStatus lower,
    RivalryStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition>
      wrestler1NameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrestler1Name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrestler1Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrestler1Name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler1NameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestler1Name',
        value: '',
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition>
      wrestler1NameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrestler1Name',
        value: '',
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition>
      wrestler2NameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrestler2Name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrestler2Name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrestler2Name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition> wrestler2NameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestler2Name',
        value: '',
      ));
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterFilterCondition>
      wrestler2NameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrestler2Name',
        value: '',
      ));
    });
  }
}

extension RivalryQueryObject
    on QueryBuilder<Rivalry, Rivalry, QFilterCondition> {}

extension RivalryQueryLinks
    on QueryBuilder<Rivalry, Rivalry, QFilterCondition> {}

extension RivalryQuerySortBy on QueryBuilder<Rivalry, Rivalry, QSortBy> {
  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByDurationWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWeeks', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByDurationWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWeeks', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByHeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByWrestler1Name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler1Name', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByWrestler1NameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler1Name', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByWrestler2Name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler2Name', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> sortByWrestler2NameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler2Name', Sort.desc);
    });
  }
}

extension RivalryQuerySortThenBy
    on QueryBuilder<Rivalry, Rivalry, QSortThenBy> {
  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByDurationWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWeeks', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByDurationWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationWeeks', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByHeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByWrestler1Name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler1Name', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByWrestler1NameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler1Name', Sort.desc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByWrestler2Name() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler2Name', Sort.asc);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QAfterSortBy> thenByWrestler2NameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestler2Name', Sort.desc);
    });
  }
}

extension RivalryQueryWhereDistinct
    on QueryBuilder<Rivalry, Rivalry, QDistinct> {
  QueryBuilder<Rivalry, Rivalry, QDistinct> distinctByDurationWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationWeeks');
    });
  }

  QueryBuilder<Rivalry, Rivalry, QDistinct> distinctByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heat');
    });
  }

  QueryBuilder<Rivalry, Rivalry, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Rivalry, Rivalry, QDistinct> distinctByWrestler1Name(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrestler1Name',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Rivalry, Rivalry, QDistinct> distinctByWrestler2Name(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrestler2Name',
          caseSensitive: caseSensitive);
    });
  }
}

extension RivalryQueryProperty
    on QueryBuilder<Rivalry, Rivalry, QQueryProperty> {
  QueryBuilder<Rivalry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Rivalry, int, QQueryOperations> durationWeeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationWeeks');
    });
  }

  QueryBuilder<Rivalry, int, QQueryOperations> heatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heat');
    });
  }

  QueryBuilder<Rivalry, RivalryStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Rivalry, String, QQueryOperations> wrestler1NameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrestler1Name');
    });
  }

  QueryBuilder<Rivalry, String, QQueryOperations> wrestler2NameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrestler2Name');
    });
  }
}
