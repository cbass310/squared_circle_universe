// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrestler.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWrestlerCollection on Isar {
  IsarCollection<Wrestler> get wrestlers => this.collection();
}

const WrestlerSchema = CollectionSchema(
  name: r'Wrestler',
  id: 200013,
  properties: {
    r'cardPosition': PropertySchema(
      id: 0,
      name: r'cardPosition',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 1,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'condition': PropertySchema(
      id: 2,
      name: r'condition',
      type: IsarType.long,
    ),
    r'contractWeeks': PropertySchema(
      id: 3,
      name: r'contractWeeks',
      type: IsarType.long,
    ),
    r'contractedPop': PropertySchema(
      id: 4,
      name: r'contractedPop',
      type: IsarType.long,
    ),
    r'desireToWin': PropertySchema(
      id: 5,
      name: r'desireToWin',
      type: IsarType.long,
    ),
    r'greed': PropertySchema(
      id: 6,
      name: r'greed',
      type: IsarType.long,
    ),
    r'hasCreativeControl': PropertySchema(
      id: 7,
      name: r'hasCreativeControl',
      type: IsarType.bool,
    ),
    r'imagePath': PropertySchema(
      id: 8,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'injuryWeeks': PropertySchema(
      id: 9,
      name: r'injuryWeeks',
      type: IsarType.long,
    ),
    r'isChampion': PropertySchema(
      id: 10,
      name: r'isChampion',
      type: IsarType.bool,
    ),
    r'isHeel': PropertySchema(
      id: 11,
      name: r'isHeel',
      type: IsarType.bool,
    ),
    r'isHoldingOut': PropertySchema(
      id: 12,
      name: r'isHoldingOut',
      type: IsarType.bool,
    ),
    r'isInjured': PropertySchema(
      id: 13,
      name: r'isInjured',
      type: IsarType.bool,
    ),
    r'isOnIR': PropertySchema(
      id: 14,
      name: r'isOnIR',
      type: IsarType.bool,
    ),
    r'isRookie': PropertySchema(
      id: 15,
      name: r'isRookie',
      type: IsarType.bool,
    ),
    r'isScouted': PropertySchema(
      id: 16,
      name: r'isScouted',
      type: IsarType.bool,
    ),
    r'isTVChampion': PropertySchema(
      id: 17,
      name: r'isTVChampion',
      type: IsarType.bool,
    ),
    r'loyalty': PropertySchema(
      id: 18,
      name: r'loyalty',
      type: IsarType.long,
    ),
    r'micSkill': PropertySchema(
      id: 19,
      name: r'micSkill',
      type: IsarType.long,
    ),
    r'morale': PropertySchema(
      id: 20,
      name: r'morale',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 21,
      name: r'name',
      type: IsarType.string,
    ),
    r'pop': PropertySchema(
      id: 22,
      name: r'pop',
      type: IsarType.long,
    ),
    r'potentialSkill': PropertySchema(
      id: 23,
      name: r'potentialSkill',
      type: IsarType.long,
    ),
    r'ringSkill': PropertySchema(
      id: 24,
      name: r'ringSkill',
      type: IsarType.long,
    ),
    r'salary': PropertySchema(
      id: 25,
      name: r'salary',
      type: IsarType.long,
    ),
    r'stamina': PropertySchema(
      id: 26,
      name: r'stamina',
      type: IsarType.long,
    ),
    r'style': PropertySchema(
      id: 27,
      name: r'style',
      type: IsarType.byte,
      enumMap: _WrestlerstyleEnumValueMap,
    ),
    r'upfrontBonus': PropertySchema(
      id: 28,
      name: r'upfrontBonus',
      type: IsarType.long,
    )
  },
  estimateSize: _wrestlerEstimateSize,
  serialize: _wrestlerSerialize,
  deserialize: _wrestlerDeserialize,
  deserializeProp: _wrestlerDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _wrestlerGetId,
  getLinks: _wrestlerGetLinks,
  attach: _wrestlerAttach,
  version: '3.1.0+1',
);

int _wrestlerEstimateSize(
  Wrestler object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardPosition.length * 3;
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _wrestlerSerialize(
  Wrestler object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cardPosition);
  writer.writeLong(offsets[1], object.companyId);
  writer.writeLong(offsets[2], object.condition);
  writer.writeLong(offsets[3], object.contractWeeks);
  writer.writeLong(offsets[4], object.contractedPop);
  writer.writeLong(offsets[5], object.desireToWin);
  writer.writeLong(offsets[6], object.greed);
  writer.writeBool(offsets[7], object.hasCreativeControl);
  writer.writeString(offsets[8], object.imagePath);
  writer.writeLong(offsets[9], object.injuryWeeks);
  writer.writeBool(offsets[10], object.isChampion);
  writer.writeBool(offsets[11], object.isHeel);
  writer.writeBool(offsets[12], object.isHoldingOut);
  writer.writeBool(offsets[13], object.isInjured);
  writer.writeBool(offsets[14], object.isOnIR);
  writer.writeBool(offsets[15], object.isRookie);
  writer.writeBool(offsets[16], object.isScouted);
  writer.writeBool(offsets[17], object.isTVChampion);
  writer.writeLong(offsets[18], object.loyalty);
  writer.writeLong(offsets[19], object.micSkill);
  writer.writeLong(offsets[20], object.morale);
  writer.writeString(offsets[21], object.name);
  writer.writeLong(offsets[22], object.pop);
  writer.writeLong(offsets[23], object.potentialSkill);
  writer.writeLong(offsets[24], object.ringSkill);
  writer.writeLong(offsets[25], object.salary);
  writer.writeLong(offsets[26], object.stamina);
  writer.writeByte(offsets[27], object.style.index);
  writer.writeLong(offsets[28], object.upfrontBonus);
}

Wrestler _wrestlerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Wrestler();
  object.cardPosition = reader.readString(offsets[0]);
  object.companyId = reader.readLong(offsets[1]);
  object.condition = reader.readLong(offsets[2]);
  object.contractWeeks = reader.readLong(offsets[3]);
  object.contractedPop = reader.readLong(offsets[4]);
  object.desireToWin = reader.readLong(offsets[5]);
  object.greed = reader.readLong(offsets[6]);
  object.hasCreativeControl = reader.readBool(offsets[7]);
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[8]);
  object.injuryWeeks = reader.readLong(offsets[9]);
  object.isChampion = reader.readBool(offsets[10]);
  object.isHeel = reader.readBool(offsets[11]);
  object.isHoldingOut = reader.readBool(offsets[12]);
  object.isInjured = reader.readBool(offsets[13]);
  object.isOnIR = reader.readBool(offsets[14]);
  object.isRookie = reader.readBool(offsets[15]);
  object.isScouted = reader.readBool(offsets[16]);
  object.isTVChampion = reader.readBool(offsets[17]);
  object.loyalty = reader.readLong(offsets[18]);
  object.micSkill = reader.readLong(offsets[19]);
  object.morale = reader.readLong(offsets[20]);
  object.name = reader.readString(offsets[21]);
  object.pop = reader.readLong(offsets[22]);
  object.potentialSkill = reader.readLong(offsets[23]);
  object.ringSkill = reader.readLong(offsets[24]);
  object.salary = reader.readLong(offsets[25]);
  object.stamina = reader.readLong(offsets[26]);
  object.style =
      _WrestlerstyleValueEnumMap[reader.readByteOrNull(offsets[27])] ??
          WrestlingStyle.brawler;
  object.upfrontBonus = reader.readLong(offsets[28]);
  return object;
}

P _wrestlerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLong(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (_WrestlerstyleValueEnumMap[reader.readByteOrNull(offset)] ??
          WrestlingStyle.brawler) as P;
    case 28:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WrestlerstyleEnumValueMap = {
  'brawler': 0,
  'technician': 1,
  'highFlyer': 2,
  'powerhouse': 3,
  'giant': 4,
  'luchador': 5,
  'entertainer': 6,
  'hardcore': 7,
};
const _WrestlerstyleValueEnumMap = {
  0: WrestlingStyle.brawler,
  1: WrestlingStyle.technician,
  2: WrestlingStyle.highFlyer,
  3: WrestlingStyle.powerhouse,
  4: WrestlingStyle.giant,
  5: WrestlingStyle.luchador,
  6: WrestlingStyle.entertainer,
  7: WrestlingStyle.hardcore,
};

Id _wrestlerGetId(Wrestler object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wrestlerGetLinks(Wrestler object) {
  return [];
}

void _wrestlerAttach(IsarCollection<dynamic> col, Id id, Wrestler object) {
  object.id = id;
}

extension WrestlerQueryWhereSort on QueryBuilder<Wrestler, Wrestler, QWhere> {
  QueryBuilder<Wrestler, Wrestler, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WrestlerQueryWhere on QueryBuilder<Wrestler, Wrestler, QWhereClause> {
  QueryBuilder<Wrestler, Wrestler, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Wrestler, Wrestler, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterWhereClause> idBetween(
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

extension WrestlerQueryFilter
    on QueryBuilder<Wrestler, Wrestler, QFilterCondition> {
  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      cardPositionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cardPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      cardPositionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cardPosition',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> cardPositionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cardPosition',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      cardPositionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardPosition',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      cardPositionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cardPosition',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> companyIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> companyIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> companyIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyId',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> companyIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> conditionEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> conditionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> conditionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'condition',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> conditionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'condition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractWeeksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      contractWeeksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contractWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractWeeksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contractWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractWeeksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contractWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractedPopEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contractedPop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      contractedPopGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contractedPop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractedPopLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contractedPop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> contractedPopBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contractedPop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> desireToWinEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desireToWin',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      desireToWinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'desireToWin',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> desireToWinLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'desireToWin',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> desireToWinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'desireToWin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> greedEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'greed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> greedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'greed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> greedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'greed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> greedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'greed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      hasCreativeControlEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasCreativeControl',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> injuryWeeksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'injuryWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      injuryWeeksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'injuryWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> injuryWeeksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'injuryWeeks',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> injuryWeeksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'injuryWeeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isChampionEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isChampion',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isHeelEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHeel',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isHoldingOutEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHoldingOut',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isInjuredEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isInjured',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isOnIREqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOnIR',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isRookieEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRookie',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isScoutedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isScouted',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> isTVChampionEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTVChampion',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> loyaltyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loyalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> loyaltyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loyalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> loyaltyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loyalty',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> loyaltyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loyalty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> micSkillEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'micSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> micSkillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'micSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> micSkillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'micSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> micSkillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'micSkill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> moraleEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morale',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> moraleGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'morale',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> moraleLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'morale',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> moraleBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'morale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> popEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> popGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> popLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pop',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> popBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> potentialSkillEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'potentialSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      potentialSkillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'potentialSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
      potentialSkillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'potentialSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> potentialSkillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'potentialSkill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> ringSkillEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> ringSkillGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ringSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> ringSkillLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ringSkill',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> ringSkillBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ringSkill',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> salaryEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salary',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> salaryGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salary',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> salaryLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salary',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> salaryBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> staminaEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stamina',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> staminaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stamina',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> staminaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stamina',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> staminaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stamina',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> styleEqualTo(
      WrestlingStyle value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'style',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> styleGreaterThan(
    WrestlingStyle value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'style',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> styleLessThan(
    WrestlingStyle value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'style',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> styleBetween(
    WrestlingStyle lower,
    WrestlingStyle upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'style',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> upfrontBonusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upfrontBonus',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition>
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

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> upfrontBonusLessThan(
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

  QueryBuilder<Wrestler, Wrestler, QAfterFilterCondition> upfrontBonusBetween(
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
}

extension WrestlerQueryObject
    on QueryBuilder<Wrestler, Wrestler, QFilterCondition> {}

extension WrestlerQueryLinks
    on QueryBuilder<Wrestler, Wrestler, QFilterCondition> {}

extension WrestlerQuerySortBy on QueryBuilder<Wrestler, Wrestler, QSortBy> {
  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByCardPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardPosition', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByCardPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardPosition', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByContractWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractWeeks', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByContractWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractWeeks', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByContractedPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractedPop', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByContractedPopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractedPop', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByDesireToWin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desireToWin', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByDesireToWinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desireToWin', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByGreed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'greed', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByGreedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'greed', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByHasCreativeControl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCreativeControl', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy>
      sortByHasCreativeControlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCreativeControl', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByInjuryWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'injuryWeeks', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByInjuryWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'injuryWeeks', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChampion', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsChampionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChampion', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsHeel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHeel', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsHeelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHeel', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsHoldingOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoldingOut', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsHoldingOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoldingOut', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsInjured() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInjured', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsInjuredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInjured', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsOnIR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnIR', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsOnIRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnIR', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsRookie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRookie', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsRookieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRookie', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsScouted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScouted', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsScoutedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScouted', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsTVChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTVChampion', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByIsTVChampionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTVChampion', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByLoyalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loyalty', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByLoyaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loyalty', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByMicSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'micSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByMicSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'micSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByMorale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morale', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByMoraleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morale', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pop', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByPopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pop', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByPotentialSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potentialSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByPotentialSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potentialSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByRingSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByRingSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortBySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByStamina() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stamina', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByStaminaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stamina', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'style', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'style', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> sortByUpfrontBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.desc);
    });
  }
}

extension WrestlerQuerySortThenBy
    on QueryBuilder<Wrestler, Wrestler, QSortThenBy> {
  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByCardPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardPosition', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByCardPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardPosition', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByConditionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'condition', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByContractWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractWeeks', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByContractWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractWeeks', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByContractedPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractedPop', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByContractedPopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contractedPop', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByDesireToWin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desireToWin', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByDesireToWinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desireToWin', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByGreed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'greed', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByGreedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'greed', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByHasCreativeControl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCreativeControl', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy>
      thenByHasCreativeControlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCreativeControl', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByInjuryWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'injuryWeeks', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByInjuryWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'injuryWeeks', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChampion', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsChampionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isChampion', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsHeel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHeel', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsHeelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHeel', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsHoldingOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoldingOut', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsHoldingOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isHoldingOut', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsInjured() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInjured', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsInjuredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isInjured', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsOnIR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnIR', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsOnIRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnIR', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsRookie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRookie', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsRookieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRookie', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsScouted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScouted', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsScoutedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isScouted', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsTVChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTVChampion', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByIsTVChampionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTVChampion', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByLoyalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loyalty', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByLoyaltyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loyalty', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByMicSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'micSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByMicSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'micSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByMorale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morale', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByMoraleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morale', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pop', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByPopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pop', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByPotentialSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potentialSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByPotentialSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potentialSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByRingSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringSkill', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByRingSkillDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringSkill', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenBySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByStamina() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stamina', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByStaminaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stamina', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'style', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'style', Sort.desc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.asc);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QAfterSortBy> thenByUpfrontBonusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upfrontBonus', Sort.desc);
    });
  }
}

extension WrestlerQueryWhereDistinct
    on QueryBuilder<Wrestler, Wrestler, QDistinct> {
  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByCardPosition(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardPosition', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByCondition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'condition');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByContractWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contractWeeks');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByContractedPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contractedPop');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByDesireToWin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'desireToWin');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByGreed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'greed');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByHasCreativeControl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCreativeControl');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByInjuryWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'injuryWeeks');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isChampion');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsHeel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHeel');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsHoldingOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isHoldingOut');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsInjured() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isInjured');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsOnIR() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnIR');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsRookie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRookie');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsScouted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isScouted');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByIsTVChampion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTVChampion');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByLoyalty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loyalty');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByMicSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'micSkill');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByMorale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'morale');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByPop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pop');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByPotentialSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'potentialSkill');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByRingSkill() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringSkill');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salary');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByStamina() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stamina');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'style');
    });
  }

  QueryBuilder<Wrestler, Wrestler, QDistinct> distinctByUpfrontBonus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upfrontBonus');
    });
  }
}

extension WrestlerQueryProperty
    on QueryBuilder<Wrestler, Wrestler, QQueryProperty> {
  QueryBuilder<Wrestler, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Wrestler, String, QQueryOperations> cardPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardPosition');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> conditionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'condition');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> contractWeeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractWeeks');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> contractedPopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contractedPop');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> desireToWinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'desireToWin');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> greedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'greed');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> hasCreativeControlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCreativeControl');
    });
  }

  QueryBuilder<Wrestler, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> injuryWeeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'injuryWeeks');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isChampionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isChampion');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isHeelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHeel');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isHoldingOutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isHoldingOut');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isInjuredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isInjured');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isOnIRProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnIR');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isRookieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRookie');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isScoutedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isScouted');
    });
  }

  QueryBuilder<Wrestler, bool, QQueryOperations> isTVChampionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTVChampion');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> loyaltyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loyalty');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> micSkillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'micSkill');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> moraleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'morale');
    });
  }

  QueryBuilder<Wrestler, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> popProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pop');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> potentialSkillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'potentialSkill');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> ringSkillProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringSkill');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> salaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salary');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> staminaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stamina');
    });
  }

  QueryBuilder<Wrestler, WrestlingStyle, QQueryOperations> styleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'style');
    });
  }

  QueryBuilder<Wrestler, int, QQueryOperations> upfrontBonusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upfrontBonus');
    });
  }
}
