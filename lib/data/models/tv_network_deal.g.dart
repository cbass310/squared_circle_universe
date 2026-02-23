// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_network_deal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTvNetworkDealCollection on Isar {
  IsarCollection<TvNetworkDeal> get tvNetworkDeals => this.collection();
}

const TvNetworkDealSchema = CollectionSchema(
  name: r'TvNetworkDeal',
  id: -3474307617173001440,
  properties: {
    r'cannibalizesPPVs': PropertySchema(
      id: 0,
      name: r'cannibalizesPPVs',
      type: IsarType.bool,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'durationInWeeks': PropertySchema(
      id: 2,
      name: r'durationInWeeks',
      type: IsarType.long,
    ),
    r'networkName': PropertySchema(
      id: 3,
      name: r'networkName',
      type: IsarType.string,
    ),
    r'ppvBonusMultiplier': PropertySchema(
      id: 4,
      name: r'ppvBonusMultiplier',
      type: IsarType.double,
    ),
    r'promotionId': PropertySchema(
      id: 5,
      name: r'promotionId',
      type: IsarType.long,
    ),
    r'targetMinimumRating': PropertySchema(
      id: 6,
      name: r'targetMinimumRating',
      type: IsarType.double,
    ),
    r'tierLevel': PropertySchema(
      id: 7,
      name: r'tierLevel',
      type: IsarType.long,
    ),
    r'weeklyPayout': PropertySchema(
      id: 8,
      name: r'weeklyPayout',
      type: IsarType.long,
    )
  },
  estimateSize: _tvNetworkDealEstimateSize,
  serialize: _tvNetworkDealSerialize,
  deserialize: _tvNetworkDealDeserialize,
  deserializeProp: _tvNetworkDealDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tvNetworkDealGetId,
  getLinks: _tvNetworkDealGetLinks,
  attach: _tvNetworkDealAttach,
  version: '3.1.0+1',
);

int _tvNetworkDealEstimateSize(
  TvNetworkDeal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.networkName.length * 3;
  return bytesCount;
}

void _tvNetworkDealSerialize(
  TvNetworkDeal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.cannibalizesPPVs);
  writer.writeString(offsets[1], object.description);
  writer.writeLong(offsets[2], object.durationInWeeks);
  writer.writeString(offsets[3], object.networkName);
  writer.writeDouble(offsets[4], object.ppvBonusMultiplier);
  writer.writeLong(offsets[5], object.promotionId);
  writer.writeDouble(offsets[6], object.targetMinimumRating);
  writer.writeLong(offsets[7], object.tierLevel);
  writer.writeLong(offsets[8], object.weeklyPayout);
}

TvNetworkDeal _tvNetworkDealDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TvNetworkDeal();
  object.cannibalizesPPVs = reader.readBool(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.durationInWeeks = reader.readLong(offsets[2]);
  object.id = id;
  object.networkName = reader.readString(offsets[3]);
  object.ppvBonusMultiplier = reader.readDouble(offsets[4]);
  object.promotionId = reader.readLong(offsets[5]);
  object.targetMinimumRating = reader.readDouble(offsets[6]);
  object.tierLevel = reader.readLong(offsets[7]);
  object.weeklyPayout = reader.readLong(offsets[8]);
  return object;
}

P _tvNetworkDealDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tvNetworkDealGetId(TvNetworkDeal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tvNetworkDealGetLinks(TvNetworkDeal object) {
  return [];
}

void _tvNetworkDealAttach(
    IsarCollection<dynamic> col, Id id, TvNetworkDeal object) {
  object.id = id;
}

extension TvNetworkDealQueryWhereSort
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QWhere> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TvNetworkDealQueryWhere
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QWhereClause> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterWhereClause> idBetween(
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

extension TvNetworkDealQueryFilter
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QFilterCondition> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      cannibalizesPPVsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cannibalizesPPVs',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      durationInWeeksEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      durationInWeeksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      durationInWeeksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      durationInWeeksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
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

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'networkName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'networkName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'networkName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'networkName',
        value: '',
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      networkNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'networkName',
        value: '',
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      ppvBonusMultiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ppvBonusMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      ppvBonusMultiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ppvBonusMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      ppvBonusMultiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ppvBonusMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      ppvBonusMultiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ppvBonusMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      promotionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promotionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      promotionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'promotionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      promotionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'promotionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      promotionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'promotionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      targetMinimumRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetMinimumRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      targetMinimumRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetMinimumRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      targetMinimumRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetMinimumRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      targetMinimumRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetMinimumRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      tierLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tierLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      tierLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tierLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      tierLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tierLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      tierLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tierLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      weeklyPayoutEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyPayout',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      weeklyPayoutGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyPayout',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      weeklyPayoutLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyPayout',
        value: value,
      ));
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterFilterCondition>
      weeklyPayoutBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyPayout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TvNetworkDealQueryObject
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QFilterCondition> {}

extension TvNetworkDealQueryLinks
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QFilterCondition> {}

extension TvNetworkDealQuerySortBy
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QSortBy> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByCannibalizesPPVs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cannibalizesPPVs', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByCannibalizesPPVsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cannibalizesPPVs', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByDurationInWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> sortByNetworkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkName', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByNetworkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkName', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByPpvBonusMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvBonusMultiplier', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByPpvBonusMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvBonusMultiplier', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> sortByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByPromotionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByTargetMinimumRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinimumRating', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByTargetMinimumRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinimumRating', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> sortByTierLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tierLevel', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByTierLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tierLevel', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      sortByWeeklyPayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.desc);
    });
  }
}

extension TvNetworkDealQuerySortThenBy
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QSortThenBy> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByCannibalizesPPVs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cannibalizesPPVs', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByCannibalizesPPVsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cannibalizesPPVs', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByDurationInWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenByNetworkName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkName', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByNetworkNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'networkName', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByPpvBonusMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvBonusMultiplier', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByPpvBonusMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvBonusMultiplier', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByPromotionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByTargetMinimumRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinimumRating', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByTargetMinimumRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMinimumRating', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy> thenByTierLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tierLevel', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByTierLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tierLevel', Sort.desc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.asc);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QAfterSortBy>
      thenByWeeklyPayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.desc);
    });
  }
}

extension TvNetworkDealQueryWhereDistinct
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct> {
  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByCannibalizesPPVs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cannibalizesPPVs');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInWeeks');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct> distinctByNetworkName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'networkName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByPpvBonusMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ppvBonusMultiplier');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promotionId');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByTargetMinimumRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetMinimumRating');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct> distinctByTierLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tierLevel');
    });
  }

  QueryBuilder<TvNetworkDeal, TvNetworkDeal, QDistinct>
      distinctByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyPayout');
    });
  }
}

extension TvNetworkDealQueryProperty
    on QueryBuilder<TvNetworkDeal, TvNetworkDeal, QQueryProperty> {
  QueryBuilder<TvNetworkDeal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TvNetworkDeal, bool, QQueryOperations>
      cannibalizesPPVsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cannibalizesPPVs');
    });
  }

  QueryBuilder<TvNetworkDeal, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TvNetworkDeal, int, QQueryOperations> durationInWeeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInWeeks');
    });
  }

  QueryBuilder<TvNetworkDeal, String, QQueryOperations> networkNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'networkName');
    });
  }

  QueryBuilder<TvNetworkDeal, double, QQueryOperations>
      ppvBonusMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ppvBonusMultiplier');
    });
  }

  QueryBuilder<TvNetworkDeal, int, QQueryOperations> promotionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promotionId');
    });
  }

  QueryBuilder<TvNetworkDeal, double, QQueryOperations>
      targetMinimumRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetMinimumRating');
    });
  }

  QueryBuilder<TvNetworkDeal, int, QQueryOperations> tierLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tierLevel');
    });
  }

  QueryBuilder<TvNetworkDeal, int, QQueryOperations> weeklyPayoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyPayout');
    });
  }
}
