// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_archive.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetYearlyArchiveCollection on Isar {
  IsarCollection<YearlyArchive> get yearlyArchives => this.collection();
}

const YearlyArchiveSchema = CollectionSchema(
  name: r'YearlyArchive',
  id: 4701503744404887743,
  properties: {
    r'bestShowName': PropertySchema(
      id: 0,
      name: r'bestShowName',
      type: IsarType.string,
    ),
    r'bestShowRating': PropertySchema(
      id: 1,
      name: r'bestShowRating',
      type: IsarType.double,
    ),
    r'draws': PropertySchema(
      id: 2,
      name: r'draws',
      type: IsarType.long,
    ),
    r'losses': PropertySchema(
      id: 3,
      name: r'losses',
      type: IsarType.long,
    ),
    r'totalProfit': PropertySchema(
      id: 4,
      name: r'totalProfit',
      type: IsarType.long,
    ),
    r'wins': PropertySchema(
      id: 5,
      name: r'wins',
      type: IsarType.long,
    ),
    r'wrestlerOfTheYear': PropertySchema(
      id: 6,
      name: r'wrestlerOfTheYear',
      type: IsarType.string,
    ),
    r'year': PropertySchema(
      id: 7,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _yearlyArchiveEstimateSize,
  serialize: _yearlyArchiveSerialize,
  deserialize: _yearlyArchiveDeserialize,
  deserializeProp: _yearlyArchiveDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _yearlyArchiveGetId,
  getLinks: _yearlyArchiveGetLinks,
  attach: _yearlyArchiveAttach,
  version: '3.1.0+1',
);

int _yearlyArchiveEstimateSize(
  YearlyArchive object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bestShowName.length * 3;
  bytesCount += 3 + object.wrestlerOfTheYear.length * 3;
  return bytesCount;
}

void _yearlyArchiveSerialize(
  YearlyArchive object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bestShowName);
  writer.writeDouble(offsets[1], object.bestShowRating);
  writer.writeLong(offsets[2], object.draws);
  writer.writeLong(offsets[3], object.losses);
  writer.writeLong(offsets[4], object.totalProfit);
  writer.writeLong(offsets[5], object.wins);
  writer.writeString(offsets[6], object.wrestlerOfTheYear);
  writer.writeLong(offsets[7], object.year);
}

YearlyArchive _yearlyArchiveDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = YearlyArchive();
  object.bestShowName = reader.readString(offsets[0]);
  object.bestShowRating = reader.readDouble(offsets[1]);
  object.draws = reader.readLong(offsets[2]);
  object.id = id;
  object.losses = reader.readLong(offsets[3]);
  object.totalProfit = reader.readLong(offsets[4]);
  object.wins = reader.readLong(offsets[5]);
  object.wrestlerOfTheYear = reader.readString(offsets[6]);
  object.year = reader.readLong(offsets[7]);
  return object;
}

P _yearlyArchiveDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _yearlyArchiveGetId(YearlyArchive object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _yearlyArchiveGetLinks(YearlyArchive object) {
  return [];
}

void _yearlyArchiveAttach(
    IsarCollection<dynamic> col, Id id, YearlyArchive object) {
  object.id = id;
}

extension YearlyArchiveQueryWhereSort
    on QueryBuilder<YearlyArchive, YearlyArchive, QWhere> {
  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension YearlyArchiveQueryWhere
    on QueryBuilder<YearlyArchive, YearlyArchive, QWhereClause> {
  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterWhereClause> idBetween(
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

extension YearlyArchiveQueryFilter
    on QueryBuilder<YearlyArchive, YearlyArchive, QFilterCondition> {
  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestShowName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bestShowName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bestShowName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestShowName',
        value: '',
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bestShowName',
        value: '',
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bestShowRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bestShowRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bestShowRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      bestShowRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bestShowRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      drawsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'draws',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      drawsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'draws',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      drawsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'draws',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      drawsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'draws',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> idBetween(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      lossesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'losses',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      lossesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'losses',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      lossesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'losses',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      lossesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'losses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      totalProfitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalProfit',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> winsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wins',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      winsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wins',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      winsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wins',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> winsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wins',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrestlerOfTheYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrestlerOfTheYear',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrestlerOfTheYear',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrestlerOfTheYear',
        value: '',
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      wrestlerOfTheYearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrestlerOfTheYear',
        value: '',
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> yearEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      yearGreaterThan(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition>
      yearLessThan(
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

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterFilterCondition> yearBetween(
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

extension YearlyArchiveQueryObject
    on QueryBuilder<YearlyArchive, YearlyArchive, QFilterCondition> {}

extension YearlyArchiveQueryLinks
    on QueryBuilder<YearlyArchive, YearlyArchive, QFilterCondition> {}

extension YearlyArchiveQuerySortBy
    on QueryBuilder<YearlyArchive, YearlyArchive, QSortBy> {
  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByBestShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowName', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByBestShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowName', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByBestShowRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowRating', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByBestShowRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowRating', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByDraws() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draws', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByDrawsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draws', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByLosses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'losses', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByLossesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'losses', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByTotalProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByWins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wins', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByWinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wins', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByWrestlerOfTheYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestlerOfTheYear', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      sortByWrestlerOfTheYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestlerOfTheYear', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension YearlyArchiveQuerySortThenBy
    on QueryBuilder<YearlyArchive, YearlyArchive, QSortThenBy> {
  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByBestShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowName', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByBestShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowName', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByBestShowRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowRating', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByBestShowRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestShowRating', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByDraws() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draws', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByDrawsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draws', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByLosses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'losses', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByLossesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'losses', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByTotalProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProfit', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByWins() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wins', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByWinsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wins', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByWrestlerOfTheYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestlerOfTheYear', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy>
      thenByWrestlerOfTheYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrestlerOfTheYear', Sort.desc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension YearlyArchiveQueryWhereDistinct
    on QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> {
  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> distinctByBestShowName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestShowName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct>
      distinctByBestShowRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestShowRating');
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> distinctByDraws() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'draws');
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> distinctByLosses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'losses');
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct>
      distinctByTotalProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalProfit');
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> distinctByWins() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wins');
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct>
      distinctByWrestlerOfTheYear({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrestlerOfTheYear',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<YearlyArchive, YearlyArchive, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension YearlyArchiveQueryProperty
    on QueryBuilder<YearlyArchive, YearlyArchive, QQueryProperty> {
  QueryBuilder<YearlyArchive, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<YearlyArchive, String, QQueryOperations> bestShowNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestShowName');
    });
  }

  QueryBuilder<YearlyArchive, double, QQueryOperations>
      bestShowRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestShowRating');
    });
  }

  QueryBuilder<YearlyArchive, int, QQueryOperations> drawsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'draws');
    });
  }

  QueryBuilder<YearlyArchive, int, QQueryOperations> lossesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'losses');
    });
  }

  QueryBuilder<YearlyArchive, int, QQueryOperations> totalProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalProfit');
    });
  }

  QueryBuilder<YearlyArchive, int, QQueryOperations> winsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wins');
    });
  }

  QueryBuilder<YearlyArchive, String, QQueryOperations>
      wrestlerOfTheYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrestlerOfTheYear');
    });
  }

  QueryBuilder<YearlyArchive, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
