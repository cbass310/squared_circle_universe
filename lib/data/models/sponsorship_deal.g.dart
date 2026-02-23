// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsorship_deal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSponsorshipDealCollection on Isar {
  IsarCollection<SponsorshipDeal> get sponsorshipDeals => this.collection();
}

const SponsorshipDealSchema = CollectionSchema(
  name: r'SponsorshipDeal',
  id: -7911858723318706949,
  properties: {
    r'archetype': PropertySchema(
      id: 0,
      name: r'archetype',
      type: IsarType.byte,
      enumMap: _SponsorshipDealarchetypeEnumValueMap,
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
    r'logoPath': PropertySchema(
      id: 3,
      name: r'logoPath',
      type: IsarType.string,
    ),
    r'performanceBonusAmount': PropertySchema(
      id: 4,
      name: r'performanceBonusAmount',
      type: IsarType.long,
    ),
    r'performanceBonusThreshold': PropertySchema(
      id: 5,
      name: r'performanceBonusThreshold',
      type: IsarType.double,
    ),
    r'promotionId': PropertySchema(
      id: 6,
      name: r'promotionId',
      type: IsarType.long,
    ),
    r'slotTarget': PropertySchema(
      id: 7,
      name: r'slotTarget',
      type: IsarType.byte,
      enumMap: _SponsorshipDealslotTargetEnumValueMap,
    ),
    r'sponsorName': PropertySchema(
      id: 8,
      name: r'sponsorName',
      type: IsarType.string,
    ),
    r'upfrontBonus': PropertySchema(
      id: 9,
      name: r'upfrontBonus',
      type: IsarType.long,
    ),
    r'weeklyPayout': PropertySchema(
      id: 10,
      name: r'weeklyPayout',
      type: IsarType.long,
    ),
    r'weeksLeft': PropertySchema(
      id: 11,
      name: r'weeksLeft',
      type: IsarType.long,
    )
  },
  estimateSize: _sponsorshipDealEstimateSize,
  serialize: _sponsorshipDealSerialize,
  deserialize: _sponsorshipDealDeserialize,
  deserializeProp: _sponsorshipDealDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sponsorshipDealGetId,
  getLinks: _sponsorshipDealGetLinks,
  attach: _sponsorshipDealAttach,
  version: '3.1.0+1',
);

int _sponsorshipDealEstimateSize(
  SponsorshipDeal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.logoPath.length * 3;
  bytesCount += 3 + object.sponsorName.length * 3;
  return bytesCount;
}

void _sponsorshipDealSerialize(
  SponsorshipDeal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.archetype.index);
  writer.writeString(offsets[1], object.description);
  writer.writeLong(offsets[2], object.durationInWeeks);
  writer.writeString(offsets[3], object.logoPath);
  writer.writeLong(offsets[4], object.performanceBonusAmount);
  writer.writeDouble(offsets[5], object.performanceBonusThreshold);
  writer.writeLong(offsets[6], object.promotionId);
  writer.writeByte(offsets[7], object.slotTarget.index);
  writer.writeString(offsets[8], object.sponsorName);
  writer.writeLong(offsets[9], object.upfrontBonus);
  writer.writeLong(offsets[10], object.weeklyPayout);
  writer.writeLong(offsets[11], object.weeksLeft);
}

SponsorshipDeal _sponsorshipDealDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SponsorshipDeal();
  object.archetype = _SponsorshipDealarchetypeValueEnumMap[
          reader.readByteOrNull(offsets[0])] ??
      SponsorArchetype.consistency;
  object.description = reader.readString(offsets[1]);
  object.durationInWeeks = reader.readLong(offsets[2]);
  object.id = id;
  object.logoPath = reader.readString(offsets[3]);
  object.performanceBonusAmount = reader.readLong(offsets[4]);
  object.performanceBonusThreshold = reader.readDouble(offsets[5]);
  object.promotionId = reader.readLong(offsets[6]);
  object.slotTarget = _SponsorshipDealslotTargetValueEnumMap[
          reader.readByteOrNull(offsets[7])] ??
      RealEstateSlot.turnbuckle;
  object.sponsorName = reader.readString(offsets[8]);
  object.upfrontBonus = reader.readLong(offsets[9]);
  object.weeklyPayout = reader.readLong(offsets[10]);
  object.weeksLeft = reader.readLong(offsets[11]);
  return object;
}

P _sponsorshipDealDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_SponsorshipDealarchetypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SponsorArchetype.consistency) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (_SponsorshipDealslotTargetValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RealEstateSlot.turnbuckle) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SponsorshipDealarchetypeEnumValueMap = {
  'consistency': 0,
  'upfrontCash': 1,
  'performance': 2,
};
const _SponsorshipDealarchetypeValueEnumMap = {
  0: SponsorArchetype.consistency,
  1: SponsorArchetype.upfrontCash,
  2: SponsorArchetype.performance,
};
const _SponsorshipDealslotTargetEnumValueMap = {
  'turnbuckle': 0,
  'canvas': 1,
  'eventName': 2,
};
const _SponsorshipDealslotTargetValueEnumMap = {
  0: RealEstateSlot.turnbuckle,
  1: RealEstateSlot.canvas,
  2: RealEstateSlot.eventName,
};

Id _sponsorshipDealGetId(SponsorshipDeal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sponsorshipDealGetLinks(SponsorshipDeal object) {
  return [];
}

void _sponsorshipDealAttach(
    IsarCollection<dynamic> col, Id id, SponsorshipDeal object) {
  object.id = id;
}

extension SponsorshipDealQueryWhereSort
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QWhere> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SponsorshipDealQueryWhere
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QWhereClause> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterWhereClause> idBetween(
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

extension SponsorshipDealQueryFilter
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QFilterCondition> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      archetypeEqualTo(SponsorArchetype value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archetype',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      archetypeGreaterThan(
    SponsorArchetype value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'archetype',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      archetypeLessThan(
    SponsorArchetype value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'archetype',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      archetypeBetween(
    SponsorArchetype lower,
    SponsorArchetype upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'archetype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      durationInWeeksEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusAmountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performanceBonusAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusAmountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performanceBonusAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusAmountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performanceBonusAmount',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusAmountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performanceBonusAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusThresholdEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performanceBonusThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusThresholdGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performanceBonusThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusThresholdLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performanceBonusThreshold',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      performanceBonusThresholdBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performanceBonusThreshold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      promotionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'promotionId',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      slotTargetEqualTo(RealEstateSlot value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slotTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      slotTargetGreaterThan(
    RealEstateSlot value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slotTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      slotTargetLessThan(
    RealEstateSlot value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slotTarget',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      slotTargetBetween(
    RealEstateSlot lower,
    RealEstateSlot upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slotTarget',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sponsorName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sponsorName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sponsorName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sponsorName',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      sponsorNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sponsorName',
        value: '',
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      upfrontBonusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upfrontBonus',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      upfrontBonusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upfrontBonus',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      upfrontBonusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upfrontBonus',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      upfrontBonusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upfrontBonus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      weeklyPayoutEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyPayout',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
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

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      weeksLeftEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeksLeft',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      weeksLeftGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeksLeft',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      weeksLeftLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeksLeft',
        value: value,
      ));
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterFilterCondition>
      weeksLeftBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeksLeft',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SponsorshipDealQueryObject
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QFilterCondition> {}

extension SponsorshipDealQueryLinks
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QFilterCondition> {}

extension SponsorshipDealQuerySortBy
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QSortBy> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByArchetype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archetype', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByArchetypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archetype', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByDurationInWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPerformanceBonusAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusAmount', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPerformanceBonusAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusAmount', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPerformanceBonusThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusThreshold', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPerformanceBonusThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusThreshold', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByPromotionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortBySlotTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTarget', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortBySlotTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTarget', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortBySponsorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorName', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortBySponsorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorName', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByUpfrontBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByWeeklyPayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByWeeksLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeksLeft', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      sortByWeeksLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeksLeft', Sort.desc);
    });
  }
}

extension SponsorshipDealQuerySortThenBy
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QSortThenBy> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByArchetype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archetype', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByArchetypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archetype', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByDurationInWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInWeeks', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPerformanceBonusAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusAmount', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPerformanceBonusAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusAmount', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPerformanceBonusThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusThreshold', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPerformanceBonusThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performanceBonusThreshold', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByPromotionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'promotionId', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenBySlotTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTarget', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenBySlotTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slotTarget', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenBySponsorName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorName', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenBySponsorNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorName', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByUpfrontBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByWeeklyPayoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPayout', Sort.desc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByWeeksLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeksLeft', Sort.asc);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QAfterSortBy>
      thenByWeeksLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeksLeft', Sort.desc);
    });
  }
}

extension SponsorshipDealQueryWhereDistinct
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct> {
  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByArchetype() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archetype');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByDurationInWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInWeeks');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct> distinctByLogoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByPerformanceBonusAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performanceBonusAmount');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByPerformanceBonusThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performanceBonusThreshold');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByPromotionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'promotionId');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctBySlotTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slotTarget');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctBySponsorName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sponsorName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upfrontBonus');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByWeeklyPayout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyPayout');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorshipDeal, QDistinct>
      distinctByWeeksLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeksLeft');
    });
  }
}

extension SponsorshipDealQueryProperty
    on QueryBuilder<SponsorshipDeal, SponsorshipDeal, QQueryProperty> {
  QueryBuilder<SponsorshipDeal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SponsorshipDeal, SponsorArchetype, QQueryOperations>
      archetypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archetype');
    });
  }

  QueryBuilder<SponsorshipDeal, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations>
      durationInWeeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInWeeks');
    });
  }

  QueryBuilder<SponsorshipDeal, String, QQueryOperations> logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations>
      performanceBonusAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performanceBonusAmount');
    });
  }

  QueryBuilder<SponsorshipDeal, double, QQueryOperations>
      performanceBonusThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performanceBonusThreshold');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations> promotionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'promotionId');
    });
  }

  QueryBuilder<SponsorshipDeal, RealEstateSlot, QQueryOperations>
      slotTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slotTarget');
    });
  }

  QueryBuilder<SponsorshipDeal, String, QQueryOperations>
      sponsorNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sponsorName');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations> upfrontBonusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upfrontBonus');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations> weeklyPayoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyPayout');
    });
  }

  QueryBuilder<SponsorshipDeal, int, QQueryOperations> weeksLeftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeksLeft');
    });
  }
}
