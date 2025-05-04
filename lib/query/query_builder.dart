// ignore_for_file: non_constant_identifier_names

part of 'query.dart';

typedef QueryConditionChange = void Function(QueryCondition? condition);

mixin ConditionListMix {
  List<QueryWidget> conditionList = [];

  String? get buildQueryString => AND_WIDGETS(conditionList).buildCondition();

  void addConditions(List<QueryWidget> ws) {
    conditionList.addAll(ws);
    for (var e in conditionList) {
      e.onConditionChange = _onCondChange;
    }
  }

  void _onCondChange(QueryCondition? q) {
    onQueryConditionChanged(buildQueryString);
  }

  void onQueryConditionChanged(String? q);
}

mixin WithCondition on Widget {
  QueryCondition? condition();

  QueryConditionChange? onConditionChange;
}

// ignore: must_be_immutable
abstract class QueryWidget extends HareWidget with WithCondition {
  QueryWidget() : super();
}

class QueryBuilder {
  int offset;
  int limit;
  QueryCondition? filter;
  List<OrderByItem> sort = [];

  QueryBuilder({
    this.offset = 0,
    this.limit = 200,
    this.filter,
    List<OrderByItem>? sort,
  }) {
    if (sort != null && sort.isNotEmpty) this.sort.addAll(sort);
  }

  QueryBuilder orderByItem(OrderByItem? item) {
    if (item != null) sort.add(item);
    return this;
  }

  QueryBuilder orderBy({required bool asc, required String field}) {
    sort.add(OrderByItem(asc: asc, field: field));
    return this;
  }

  List<LabelValue<dynamic>> arguments() {
    String cond = filter?.buildCondition() ?? "";
    return ["offset" >> offset, "limit" >> limit, if (sort.isNotEmpty) "sort" >> sort.join(","), if (cond.contains("|")) "q" >> cond];
  }
}

const List<QueryOperator> commonConditionOperators = [
  QueryOperator.eq,
  QueryOperator.ge,
  QueryOperator.le,
  QueryOperator.gt,
  QueryOperator.lt,
  QueryOperator.ne,
  QueryOperator.inset,
  QueryOperator.nul
];
// const List<QueryOperator> numConditionOperators = [...commonConditionOperators, QueryOperator.bit];
const List<QueryOperator> numConditionOperators = [...commonConditionOperators];
const List<QueryOperator> textConditionOperators = [...commonConditionOperators, QueryOperator.start, QueryOperator.end, QueryOperator.contain];

enum QueryOperator {
  eq(op: "eq", label: "="),
  ne(op: "ne", label: "≠"),
  ge(op: "ge", label: "≥"),
  le(op: "le", label: "≤"),
  gt(op: "gt", label: ">"),
  lt(op: "lt", label: "<"),
  bit(op: "bit", label: "拥有标识"),
  inset(op: "in", label: "集合"),
  nul(op: "nul", label: "是空"),
  start(op: "start", label: "开始于"),
  end(op: "end", label: "结束于"),
  contain(op: "contain", label: "包含");

  const QueryOperator({required this.op, required this.label});

  final String op;
  final String label;

  String? build(String field, List<dynamic> valueList) {
    List<String> sList = valueList.nonNullList.mapList((e) => e.toString());
    switch (this) {
      case eq || ne || ge || le || gt || lt || contain || start || end || bit:
        if (sList.length == 1) {
          return "$field|$op|${sList.first.toString()}";
        } else {
          return null;
        }
      case nul:
        return "$field|$op";
      case inset:
        if (sList.isNotEmpty) {
          return "$field|$op|${sList.join('|')}";
        } else {
          return null;
        }
    }
  }
}

String? buildSortBy(String? field, bool asc) {
  if (field == null) return null;
  return asc ? "_$field" : "${field}_";
}

class OrderByItem {
  bool asc;
  String field;

  OrderByItem({required this.asc, required this.field});

  @override
  String toString() {
    return asc ? "_$field" : "${field}_";
  }
}

abstract class QueryCondition {
  String? buildCondition();
}

class SingleCondition extends QueryCondition {
  String field;
  QueryOperator op;
  List<dynamic> params;

  SingleCondition({required this.op, required this.field, required this.params});

  @override
  String? buildCondition() {
    return op.build(field, params);
  }

  @override
  String toString() {
    return buildCondition() ?? "";
  }
}

class GroupCondition extends QueryCondition {
  bool isAnd;
  List<QueryCondition> conditions;

  GroupCondition(this.isAnd, this.conditions);

  GroupCondition.and(this.conditions) : isAnd = true;

  GroupCondition.or(this.conditions) : isAnd = false;

  @override
  String? buildCondition() {
    List<String> ls = conditions.mapList((e) => e.buildCondition()).nonNullList;
    if (ls.isEmpty) return null;
    if (ls.length == 1) return ls.first;
    String s = ls.join(',');

    return isAnd ? "{$s}" : "[$s]";
  }

  @override
  String toString() {
    return buildCondition() ?? "";
  }
}

OrderByItem ASC(String field) {
  return OrderByItem(asc: true, field: field);
}

OrderByItem DESC(String field) {
  return OrderByItem(asc: false, field: field);
}

QueryCondition AND_WIDGETS(List<QueryWidget> items) {
  return GroupCondition(true, items.mapList((e) => e.condition()).nonNullList);
}

QueryCondition OR_WIDGETS(List<QueryWidget> items) {
  return GroupCondition(false, items.mapList((e) => e.condition()).nonNullList);
}

QueryCondition AND(List<QueryCondition> items) {
  return GroupCondition(true, items);
}

QueryCondition OR(List<QueryCondition> items) {
  return GroupCondition(false, items);
}

QueryCondition BIT(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.bit, field: field, params: [param]);
}

QueryCondition EQ(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.eq, field: field, params: [param]);
}

QueryCondition NE(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.ne, field: field, params: [param]);
}

QueryCondition GE(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.ge, field: field, params: [param]);
}

QueryCondition LE(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.le, field: field, params: [param]);
}

QueryCondition GT(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.gt, field: field, params: [param]);
}

QueryCondition LT(String field, dynamic param) {
  return SingleCondition(op: QueryOperator.lt, field: field, params: [param]);
}

QueryCondition IN(String field, List<dynamic> params) {
  return SingleCondition(op: QueryOperator.inset, field: field, params: params);
}

QueryCondition ISNULL(String field) {
  return SingleCondition(op: QueryOperator.nul, field: field, params: []);
}

QueryCondition START(String field, String param) {
  return SingleCondition(op: QueryOperator.start, field: field, params: [param]);
}

QueryCondition END(String field, String param) {
  return SingleCondition(op: QueryOperator.end, field: field, params: [param]);
}

QueryCondition CONTAINS(String field, String param) {
  return SingleCondition(op: QueryOperator.contain, field: field, params: [param]);
}
