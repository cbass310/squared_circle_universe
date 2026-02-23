// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMatchCollection on Isar {
  IsarCollection<Match> get matchs => this.collection();
}

const MatchSchema = CollectionSchema(
  name: r'Match',
  id: -4384922031457139852,
  properties: {
    r'agentNote': PropertySchema(
      id: 0,
      name: r'agentNote',
      type: IsarType.string,
      enumMap: _MatchagentNoteEnumValueMap,
    ),
    r'duration': PropertySchema(
      id: 1,
      name: r'duration',
      type: IsarType.long,
    ),
    r'finishType': PropertySchema(
      id: 2,
      name: r'finishType',
      type: IsarType.string,
    ),
    r'heat': PropertySchema(
      id: 3,
      name: r'heat',
      type: IsarType.long,
    ),
    r'rating': PropertySchema(
      id: 4,
      name: r'rating',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.string,
      enumMap: _MatchtypeEnumValueMap,
    ),
    r'winnerName': PropertySchema(
      id: 6,
      name: r'winnerName',
      type: IsarType.string,
    )
  },
  estimateSize: _matchEstimateSize,
  serialize: _matchSerialize,
  deserialize: _matchDeserialize,
  deserializeProp: _matchDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'wrestlers': LinkSchema(
      id: -6770233852519899281,
      name: r'wrestlers',
      target: r'Wrestler',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _matchGetId,
  getLinks: _matchGetLinks,
  attach: _matchAttach,
  version: '3.1.0+1',
);

int _matchEstimateSize(
  Match object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.agentNote.name.length * 3;
  bytesCount += 3 + object.finishType.length * 3;
  bytesCount += 3 + object.type.name.length * 3;
  bytesCount += 3 + object.winnerName.length * 3;
  return bytesCount;
}

void _matchSerialize(
  Match object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.agentNote.name);
  writer.writeLong(offsets[1], object.duration);
  writer.writeString(offsets[2], object.finishType);
  writer.writeLong(offsets[3], object.heat);
  writer.writeDouble(offsets[4], object.rating);
  writer.writeString(offsets[5], object.type.name);
  writer.writeString(offsets[6], object.winnerName);
}

Match _matchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Match(
    agentNote:
        _MatchagentNoteValueEnumMap[reader.readStringOrNull(offsets[0])] ??
            AgentNote.standard,
    duration: reader.readLongOrNull(offsets[1]) ?? 10,
    finishType: reader.readStringOrNull(offsets[2]) ?? "Pinfall",
    heat: reader.readLongOrNull(offsets[3]) ?? 0,
    rating: reader.readDoubleOrNull(offsets[4]) ?? 0.0,
    type: _MatchtypeValueEnumMap[reader.readStringOrNull(offsets[5])] ??
        MatchType.standard,
    winnerName: reader.readStringOrNull(offsets[6]) ?? "",
  );
  object.id = id;
  return object;
}

P _matchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_MatchagentNoteValueEnumMap[reader.readStringOrNull(offset)] ??
          AgentNote.standard) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 10) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "Pinfall") as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 5:
      return (_MatchtypeValueEnumMap[reader.readStringOrNull(offset)] ??
          MatchType.standard) as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? "") as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MatchagentNoteEnumValueMap = {
  r'standard': r'standard',
  r'cleanFinish': r'cleanFinish',
  r'screwjob': r'screwjob',
};
const _MatchagentNoteValueEnumMap = {
  r'standard': AgentNote.standard,
  r'cleanFinish': AgentNote.cleanFinish,
  r'screwjob': AgentNote.screwjob,
};
const _MatchtypeEnumValueMap = {
  r'standard': r'standard',
  r'hardcore': r'hardcore',
  r'submission': r'submission',
  r'ladder': r'ladder',
  r'cage': r'cage',
  r'promo': r'promo',
  r'ambush': r'ambush',
};
const _MatchtypeValueEnumMap = {
  r'standard': MatchType.standard,
  r'hardcore': MatchType.hardcore,
  r'submission': MatchType.submission,
  r'ladder': MatchType.ladder,
  r'cage': MatchType.cage,
  r'promo': MatchType.promo,
  r'ambush': MatchType.ambush,
};

Id _matchGetId(Match object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _matchGetLinks(Match object) {
  return [object.wrestlers];
}

void _matchAttach(IsarCollection<dynamic> col, Id id, Match object) {
  object.id = id;
  object.wrestlers
      .attach(col, col.isar.collection<Wrestler>(), r'wrestlers', id);
}

extension MatchQueryWhereSort on QueryBuilder<Match, Match, QWhere> {
  QueryBuilder<Match, Match, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MatchQueryWhere on QueryBuilder<Match, Match, QWhereClause> {
  QueryBuilder<Match, Match, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Match, Match, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Match, Match, QAfterWhereClause> idBetween(
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

extension MatchQueryFilter on QueryBuilder<Match, Match, QFilterCondition> {
  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteEqualTo(
    AgentNote value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteGreaterThan(
    AgentNote value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteLessThan(
    AgentNote value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteBetween(
    AgentNote lower,
    AgentNote upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'agentNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'agentNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'agentNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'agentNote',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> agentNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'agentNote',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> durationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finishType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'finishType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'finishType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finishType',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> finishTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'finishType',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> heatEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heat',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> heatGreaterThan(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> heatLessThan(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> heatBetween(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Match, Match, QAfterFilterCondition> ratingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> ratingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> ratingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> ratingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeEqualTo(
    MatchType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeGreaterThan(
    MatchType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeLessThan(
    MatchType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeBetween(
    MatchType lower,
    MatchType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'winnerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'winnerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'winnerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winnerName',
        value: '',
      ));
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> winnerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'winnerName',
        value: '',
      ));
    });
  }
}

extension MatchQueryObject on QueryBuilder<Match, Match, QFilterCondition> {}

extension MatchQueryLinks on QueryBuilder<Match, Match, QFilterCondition> {
  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlers(
      FilterQuery<Wrestler> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'wrestlers');
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wrestlers', length, true, length, true);
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wrestlers', 0, true, 0, true);
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wrestlers', 0, false, 999999, true);
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wrestlers', 0, true, length, include);
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wrestlers', length, include, 999999, true);
    });
  }

  QueryBuilder<Match, Match, QAfterFilterCondition> wrestlersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'wrestlers', lower, includeLower, upper, includeUpper);
    });
  }
}

extension MatchQuerySortBy on QueryBuilder<Match, Match, QSortBy> {
  QueryBuilder<Match, Match, QAfterSortBy> sortByAgentNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agentNote', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByAgentNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agentNote', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByFinishType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishType', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByFinishTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishType', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByHeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWinnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerName', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> sortByWinnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerName', Sort.desc);
    });
  }
}

extension MatchQuerySortThenBy on QueryBuilder<Match, Match, QSortThenBy> {
  QueryBuilder<Match, Match, QAfterSortBy> thenByAgentNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agentNote', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByAgentNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'agentNote', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByFinishType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishType', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByFinishTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishType', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByHeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heat', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWinnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerName', Sort.asc);
    });
  }

  QueryBuilder<Match, Match, QAfterSortBy> thenByWinnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winnerName', Sort.desc);
    });
  }
}

extension MatchQueryWhereDistinct on QueryBuilder<Match, Match, QDistinct> {
  QueryBuilder<Match, Match, QDistinct> distinctByAgentNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'agentNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByFinishType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByHeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heat');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Match, Match, QDistinct> distinctByWinnerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'winnerName', caseSensitive: caseSensitive);
    });
  }
}

extension MatchQueryProperty on QueryBuilder<Match, Match, QQueryProperty> {
  QueryBuilder<Match, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Match, AgentNote, QQueryOperations> agentNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'agentNote');
    });
  }

  QueryBuilder<Match, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> finishTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishType');
    });
  }

  QueryBuilder<Match, int, QQueryOperations> heatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heat');
    });
  }

  QueryBuilder<Match, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<Match, MatchType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Match, String, QQueryOperations> winnerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'winnerName');
    });
  }
}
