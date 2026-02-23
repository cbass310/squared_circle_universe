// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_card.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShowCardCollection on Isar {
  IsarCollection<ShowCard> get showCards => this.collection();
}

const ShowCardSchema = CollectionSchema(
  name: r'ShowCard',
  id: 200011,
  properties: {
    r'finalRating': PropertySchema(
      id: 0,
      name: r'finalRating',
      type: IsarType.double,
    ),
    r'isPPV': PropertySchema(
      id: 1,
      name: r'isPPV',
      type: IsarType.bool,
    ),
    r'isShowcaseEvent': PropertySchema(
      id: 2,
      name: r'isShowcaseEvent',
      type: IsarType.bool,
    ),
    r'pacingMultiplier': PropertySchema(
      id: 3,
      name: r'pacingMultiplier',
      type: IsarType.double,
    ),
    r'showName': PropertySchema(
      id: 4,
      name: r'showName',
      type: IsarType.string,
    ),
    r'totalRevenue': PropertySchema(
      id: 5,
      name: r'totalRevenue',
      type: IsarType.long,
    ),
    r'week': PropertySchema(
      id: 6,
      name: r'week',
      type: IsarType.long,
    )
  },
  estimateSize: _showCardEstimateSize,
  serialize: _showCardSerialize,
  deserialize: _showCardDeserialize,
  deserializeProp: _showCardDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'bookedMatches': LinkSchema(
      id: 200012,
      name: r'bookedMatches',
      target: r'Match',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _showCardGetId,
  getLinks: _showCardGetLinks,
  attach: _showCardAttach,
  version: '3.1.0+1',
);

int _showCardEstimateSize(
  ShowCard object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.showName.length * 3;
  return bytesCount;
}

void _showCardSerialize(
  ShowCard object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.finalRating);
  writer.writeBool(offsets[1], object.isPPV);
  writer.writeBool(offsets[2], object.isShowcaseEvent);
  writer.writeDouble(offsets[3], object.pacingMultiplier);
  writer.writeString(offsets[4], object.showName);
  writer.writeLong(offsets[5], object.totalRevenue);
  writer.writeLong(offsets[6], object.week);
}

ShowCard _showCardDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShowCard();
  object.finalRating = reader.readDouble(offsets[0]);
  object.id = id;
  object.isPPV = reader.readBool(offsets[1]);
  object.isShowcaseEvent = reader.readBool(offsets[2]);
  object.pacingMultiplier = reader.readDouble(offsets[3]);
  object.showName = reader.readString(offsets[4]);
  object.totalRevenue = reader.readLong(offsets[5]);
  object.week = reader.readLong(offsets[6]);
  return object;
}

P _showCardDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _showCardGetId(ShowCard object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _showCardGetLinks(ShowCard object) {
  return [object.bookedMatches];
}

void _showCardAttach(IsarCollection<dynamic> col, Id id, ShowCard object) {
  object.id = id;
  object.bookedMatches
      .attach(col, col.isar.collection<Match>(), r'bookedMatches', id);
}

extension ShowCardQueryWhereSort on QueryBuilder<ShowCard, ShowCard, QWhere> {
  QueryBuilder<ShowCard, ShowCard, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShowCardQueryWhere on QueryBuilder<ShowCard, ShowCard, QWhereClause> {
  QueryBuilder<ShowCard, ShowCard, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ShowCard, ShowCard, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterWhereClause> idBetween(
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

extension ShowCardQueryFilter
    on QueryBuilder<ShowCard, ShowCard, QFilterCondition> {
  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> finalRatingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      finalRatingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> finalRatingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalRating',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> finalRatingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> isPPVEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPPV',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      isShowcaseEventEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShowcaseEvent',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      pacingMultiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pacingMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      pacingMultiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pacingMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      pacingMultiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pacingMultiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      pacingMultiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pacingMultiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameEqualTo(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameGreaterThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameLessThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameBetween(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameStartsWith(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameEndsWith(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'showName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameMatches(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> showNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'showName',
        value: '',
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> totalRevenueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      totalRevenueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> totalRevenueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> totalRevenueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> weekEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> weekGreaterThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> weekLessThan(
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

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> weekBetween(
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
}

extension ShowCardQueryObject
    on QueryBuilder<ShowCard, ShowCard, QFilterCondition> {}

extension ShowCardQueryLinks
    on QueryBuilder<ShowCard, ShowCard, QFilterCondition> {
  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition> bookedMatches(
      FilterQuery<Match> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bookedMatches');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bookedMatches', length, true, length, true);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bookedMatches', 0, true, 0, true);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bookedMatches', 0, false, 999999, true);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bookedMatches', 0, true, length, include);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bookedMatches', length, include, 999999, true);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterFilterCondition>
      bookedMatchesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'bookedMatches', lower, includeLower, upper, includeUpper);
    });
  }
}

extension ShowCardQuerySortBy on QueryBuilder<ShowCard, ShowCard, QSortBy> {
  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByFinalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalRating', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByFinalRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalRating', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByIsPPV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPPV', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByIsPPVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPPV', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByIsShowcaseEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShowcaseEvent', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByIsShowcaseEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShowcaseEvent', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByPacingMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pacingMultiplier', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByPacingMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pacingMultiplier', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByTotalRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRevenue', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByTotalRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRevenue', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> sortByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }
}

extension ShowCardQuerySortThenBy
    on QueryBuilder<ShowCard, ShowCard, QSortThenBy> {
  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByFinalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalRating', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByFinalRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalRating', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByIsPPV() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPPV', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByIsPPVDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPPV', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByIsShowcaseEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShowcaseEvent', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByIsShowcaseEventDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShowcaseEvent', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByPacingMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pacingMultiplier', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByPacingMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pacingMultiplier', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByShowName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByShowNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showName', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByTotalRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRevenue', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByTotalRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRevenue', Sort.desc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QAfterSortBy> thenByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }
}

extension ShowCardQueryWhereDistinct
    on QueryBuilder<ShowCard, ShowCard, QDistinct> {
  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByFinalRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalRating');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByIsPPV() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPPV');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByIsShowcaseEvent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isShowcaseEvent');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByPacingMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pacingMultiplier');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByShowName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByTotalRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRevenue');
    });
  }

  QueryBuilder<ShowCard, ShowCard, QDistinct> distinctByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'week');
    });
  }
}

extension ShowCardQueryProperty
    on QueryBuilder<ShowCard, ShowCard, QQueryProperty> {
  QueryBuilder<ShowCard, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShowCard, double, QQueryOperations> finalRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalRating');
    });
  }

  QueryBuilder<ShowCard, bool, QQueryOperations> isPPVProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPPV');
    });
  }

  QueryBuilder<ShowCard, bool, QQueryOperations> isShowcaseEventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isShowcaseEvent');
    });
  }

  QueryBuilder<ShowCard, double, QQueryOperations> pacingMultiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pacingMultiplier');
    });
  }

  QueryBuilder<ShowCard, String, QQueryOperations> showNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showName');
    });
  }

  QueryBuilder<ShowCard, int, QQueryOperations> totalRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRevenue');
    });
  }

  QueryBuilder<ShowCard, int, QQueryOperations> weekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'week');
    });
  }
}
