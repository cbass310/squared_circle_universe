// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompanyCollection on Isar {
  IsarCollection<Company> get companys => this.collection();
}

const CompanySchema = CollectionSchema(
  name: r'Company',
  id: -3921622125198845844,
  properties: {
    r'cash': PropertySchema(
      id: 0,
      name: r'cash',
      type: IsarType.long,
    ),
    r'fans': PropertySchema(
      id: 1,
      name: r'fans',
      type: IsarType.long,
    ),
    r'venueName': PropertySchema(
      id: 2,
      name: r'venueName',
      type: IsarType.string,
    ),
    r'week': PropertySchema(
      id: 3,
      name: r'week',
      type: IsarType.long,
    )
  },
  estimateSize: _companyEstimateSize,
  serialize: _companySerialize,
  deserialize: _companyDeserialize,
  deserializeProp: _companyDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _companyGetId,
  getLinks: _companyGetLinks,
  attach: _companyAttach,
  version: '3.1.0+1',
);

int _companyEstimateSize(
  Company object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.venueName.length * 3;
  return bytesCount;
}

void _companySerialize(
  Company object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cash);
  writer.writeLong(offsets[1], object.fans);
  writer.writeString(offsets[2], object.venueName);
  writer.writeLong(offsets[3], object.week);
}

Company _companyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Company(
    cash: reader.readLongOrNull(offsets[0]) ?? 50000,
    fans: reader.readLongOrNull(offsets[1]) ?? 10000,
    venueName: reader.readStringOrNull(offsets[2]) ?? "highSchoolGym",
    week: reader.readLongOrNull(offsets[3]) ?? 1,
  );
  object.id = id;
  return object;
}

P _companyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 50000) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 10000) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "highSchoolGym") as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _companyGetId(Company object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _companyGetLinks(Company object) {
  return [];
}

void _companyAttach(IsarCollection<dynamic> col, Id id, Company object) {
  object.id = id;
}

extension CompanyQueryWhereSort on QueryBuilder<Company, Company, QWhere> {
  QueryBuilder<Company, Company, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CompanyQueryWhere on QueryBuilder<Company, Company, QWhereClause> {
  QueryBuilder<Company, Company, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Company, Company, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Company, Company, QAfterWhereClause> idBetween(
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

extension CompanyQueryFilter
    on QueryBuilder<Company, Company, QFilterCondition> {
  QueryBuilder<Company, Company, QAfterFilterCondition> cashEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cash',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> cashGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cash',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> cashLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cash',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> cashBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> fansEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fans',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> fansGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fans',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> fansLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fans',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> fansBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fans',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'venueName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'venueName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'venueName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'venueName',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> venueNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'venueName',
        value: '',
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> weekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<Company, Company, QAfterFilterCondition> weekGreaterThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> weekLessThan(
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

  QueryBuilder<Company, Company, QAfterFilterCondition> weekBetween(
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

extension CompanyQueryObject
    on QueryBuilder<Company, Company, QFilterCondition> {}

extension CompanyQueryLinks
    on QueryBuilder<Company, Company, QFilterCondition> {}

extension CompanyQuerySortBy on QueryBuilder<Company, Company, QSortBy> {
  QueryBuilder<Company, Company, QAfterSortBy> sortByCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cash', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cash', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByFans() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fans', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByFansDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fans', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByVenueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByVenueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> sortByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }
}

extension CompanyQuerySortThenBy
    on QueryBuilder<Company, Company, QSortThenBy> {
  QueryBuilder<Company, Company, QAfterSortBy> thenByCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cash', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByCashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cash', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByFans() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fans', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByFansDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fans', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByVenueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByVenueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'venueName', Sort.desc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<Company, Company, QAfterSortBy> thenByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }
}

extension CompanyQueryWhereDistinct
    on QueryBuilder<Company, Company, QDistinct> {
  QueryBuilder<Company, Company, QDistinct> distinctByCash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cash');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByFans() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fans');
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByVenueName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'venueName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Company, Company, QDistinct> distinctByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'week');
    });
  }
}

extension CompanyQueryProperty
    on QueryBuilder<Company, Company, QQueryProperty> {
  QueryBuilder<Company, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Company, int, QQueryOperations> cashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cash');
    });
  }

  QueryBuilder<Company, int, QQueryOperations> fansProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fans');
    });
  }

  QueryBuilder<Company, String, QQueryOperations> venueNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'venueName');
    });
  }

  QueryBuilder<Company, int, QQueryOperations> weekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'week');
    });
  }
}
