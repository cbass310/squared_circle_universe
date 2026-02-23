// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFinancialRecordCollection on Isar {
  IsarCollection<FinancialRecord> get financialRecords => this.collection();
}

const FinancialRecordSchema = CollectionSchema(
  name: r'FinancialRecord',
  id: 200001,
  properties: {
    r'facilityCosts': PropertySchema(
      id: 0,
      name: r'facilityCosts',
      type: IsarType.long,
    ),
    r'logisticsCosts': PropertySchema(
      id: 1,
      name: r'logisticsCosts',
      type: IsarType.long,
    ),
    r'merchandiseSales': PropertySchema(
      id: 2,
      name: r'merchandiseSales',
      type: IsarType.long,
    ),
    r'ppvRevenue': PropertySchema(
      id: 3,
      name: r'ppvRevenue',
      type: IsarType.long,
    ),
    r'productionCosts': PropertySchema(
      id: 4,
      name: r'productionCosts',
      type: IsarType.long,
    ),
    r'rosterPayroll': PropertySchema(
      id: 5,
      name: r'rosterPayroll',
      type: IsarType.long,
    ),
    r'sponsorshipRevenue': PropertySchema(
      id: 6,
      name: r'sponsorshipRevenue',
      type: IsarType.long,
    ),
    r'ticketSales': PropertySchema(
      id: 7,
      name: r'ticketSales',
      type: IsarType.long,
    ),
    r'tvRevenue': PropertySchema(
      id: 8,
      name: r'tvRevenue',
      type: IsarType.long,
    ),
    r'week': PropertySchema(
      id: 9,
      name: r'week',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 10,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _financialRecordEstimateSize,
  serialize: _financialRecordSerialize,
  deserialize: _financialRecordDeserialize,
  deserializeProp: _financialRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _financialRecordGetId,
  getLinks: _financialRecordGetLinks,
  attach: _financialRecordAttach,
  version: '3.1.0+1',
);

int _financialRecordEstimateSize(
  FinancialRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _financialRecordSerialize(
  FinancialRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.facilityCosts);
  writer.writeLong(offsets[1], object.logisticsCosts);
  writer.writeLong(offsets[2], object.merchandiseSales);
  writer.writeLong(offsets[3], object.ppvRevenue);
  writer.writeLong(offsets[4], object.productionCosts);
  writer.writeLong(offsets[5], object.rosterPayroll);
  writer.writeLong(offsets[6], object.sponsorshipRevenue);
  writer.writeLong(offsets[7], object.ticketSales);
  writer.writeLong(offsets[8], object.tvRevenue);
  writer.writeLong(offsets[9], object.week);
  writer.writeLong(offsets[10], object.year);
}

FinancialRecord _financialRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FinancialRecord();
  object.facilityCosts = reader.readLong(offsets[0]);
  object.id = id;
  object.logisticsCosts = reader.readLong(offsets[1]);
  object.merchandiseSales = reader.readLong(offsets[2]);
  object.ppvRevenue = reader.readLong(offsets[3]);
  object.productionCosts = reader.readLong(offsets[4]);
  object.rosterPayroll = reader.readLong(offsets[5]);
  object.sponsorshipRevenue = reader.readLong(offsets[6]);
  object.ticketSales = reader.readLong(offsets[7]);
  object.tvRevenue = reader.readLong(offsets[8]);
  object.week = reader.readLong(offsets[9]);
  object.year = reader.readLong(offsets[10]);
  return object;
}

P _financialRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
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
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _financialRecordGetId(FinancialRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _financialRecordGetLinks(FinancialRecord object) {
  return [];
}

void _financialRecordAttach(
    IsarCollection<dynamic> col, Id id, FinancialRecord object) {
  object.id = id;
}

extension FinancialRecordQueryWhereSort
    on QueryBuilder<FinancialRecord, FinancialRecord, QWhere> {
  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FinancialRecordQueryWhere
    on QueryBuilder<FinancialRecord, FinancialRecord, QWhereClause> {
  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhereClause>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterWhereClause> idBetween(
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

extension FinancialRecordQueryFilter
    on QueryBuilder<FinancialRecord, FinancialRecord, QFilterCondition> {
  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      facilityCostsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'facilityCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      facilityCostsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'facilityCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      facilityCostsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'facilityCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      facilityCostsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'facilityCosts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      logisticsCostsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logisticsCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      logisticsCostsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logisticsCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      logisticsCostsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logisticsCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      logisticsCostsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logisticsCosts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      merchandiseSalesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'merchandiseSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      merchandiseSalesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'merchandiseSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      merchandiseSalesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'merchandiseSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      merchandiseSalesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'merchandiseSales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ppvRevenueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ppvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ppvRevenueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ppvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ppvRevenueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ppvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ppvRevenueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ppvRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      productionCostsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productionCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      productionCostsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productionCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      productionCostsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productionCosts',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      productionCostsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productionCosts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      rosterPayrollEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rosterPayroll',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      rosterPayrollGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rosterPayroll',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      rosterPayrollLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rosterPayroll',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      rosterPayrollBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rosterPayroll',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      sponsorshipRevenueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sponsorshipRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      sponsorshipRevenueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sponsorshipRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      sponsorshipRevenueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sponsorshipRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      sponsorshipRevenueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sponsorshipRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ticketSalesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ticketSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ticketSalesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ticketSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ticketSalesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ticketSales',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      ticketSalesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ticketSales',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      tvRevenueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      tvRevenueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      tvRevenueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tvRevenue',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      tvRevenueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tvRevenue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      weekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'week',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      weekGreaterThan(
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      weekLessThan(
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      weekBetween(
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
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

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterFilterCondition>
      yearBetween(
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

extension FinancialRecordQueryObject
    on QueryBuilder<FinancialRecord, FinancialRecord, QFilterCondition> {}

extension FinancialRecordQueryLinks
    on QueryBuilder<FinancialRecord, FinancialRecord, QFilterCondition> {}

extension FinancialRecordQuerySortBy
    on QueryBuilder<FinancialRecord, FinancialRecord, QSortBy> {
  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByFacilityCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByFacilityCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByLogisticsCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logisticsCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByLogisticsCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logisticsCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByMerchandiseSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchandiseSales', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByMerchandiseSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchandiseSales', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByPpvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByPpvRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByProductionCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productionCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByProductionCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productionCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByRosterPayroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rosterPayroll', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByRosterPayrollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rosterPayroll', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortBySponsorshipRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorshipRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortBySponsorshipRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorshipRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByTicketSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ticketSales', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByTicketSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ticketSales', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByTvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByTvRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> sortByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension FinancialRecordQuerySortThenBy
    on QueryBuilder<FinancialRecord, FinancialRecord, QSortThenBy> {
  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByFacilityCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByFacilityCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'facilityCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByLogisticsCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logisticsCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByLogisticsCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logisticsCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByMerchandiseSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchandiseSales', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByMerchandiseSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchandiseSales', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByPpvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByPpvRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ppvRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByProductionCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productionCosts', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByProductionCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productionCosts', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByRosterPayroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rosterPayroll', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByRosterPayrollDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rosterPayroll', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenBySponsorshipRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorshipRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenBySponsorshipRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sponsorshipRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByTicketSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ticketSales', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByTicketSalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ticketSales', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByTvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvRevenue', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByTvRevenueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tvRevenue', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> thenByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'week', Sort.desc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension FinancialRecordQueryWhereDistinct
    on QueryBuilder<FinancialRecord, FinancialRecord, QDistinct> {
  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByFacilityCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'facilityCosts');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByLogisticsCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logisticsCosts');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByMerchandiseSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'merchandiseSales');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByPpvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ppvRevenue');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByProductionCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productionCosts');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByRosterPayroll() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rosterPayroll');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctBySponsorshipRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sponsorshipRevenue');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByTicketSales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ticketSales');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct>
      distinctByTvRevenue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tvRevenue');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct> distinctByWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'week');
    });
  }

  QueryBuilder<FinancialRecord, FinancialRecord, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension FinancialRecordQueryProperty
    on QueryBuilder<FinancialRecord, FinancialRecord, QQueryProperty> {
  QueryBuilder<FinancialRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> facilityCostsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'facilityCosts');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations>
      logisticsCostsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logisticsCosts');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations>
      merchandiseSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'merchandiseSales');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> ppvRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ppvRevenue');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations>
      productionCostsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productionCosts');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> rosterPayrollProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rosterPayroll');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations>
      sponsorshipRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sponsorshipRevenue');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> ticketSalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ticketSales');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> tvRevenueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tvRevenue');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> weekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'week');
    });
  }

  QueryBuilder<FinancialRecord, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
