part of 'query.dart';

sealed class QueryCond {
  String? buildCondition();
  @override
  String toString() {
    return buildCondition() ?? "";
  }
}

class FieldCond extends QueryCond {
  final String field;
  final QueryOp op;
  final List<dynamic> values;

  FieldCond({required this.field, required this.op, required this.values});

  @override
  String toString() {
    return buildCondition() ?? "";
  }

  @override
  String? buildCondition() {
    List<String> sList = values.nonNullList.mapList((e) => e.toString());
    switch (op.argCount) {
      case 0:
        return "$field|${op.op}";
      case 1:
        return "$field|${op.op}|${sList.first.toString()}";
      default:
        return "$field|${op.op}|${sList.join('|')}";
    }
  }
}

class AndCond extends QueryCond {
  List<QueryCond> conditions;

  AndCond(List<QueryCond?> list) : conditions = list.nonNullList;

  @override
  String? buildCondition() {
    List<QueryCond> flatList = [];
    for (QueryCond q in conditions) {
      switch (q) {
        case FieldCond fc:
          flatList.add(fc);
        case AndCond ac:
          flatList.addAll(ac.conditions);
        case OrCond oc:
          flatList.add(oc);
      }
    }
    List<String> ls = flatList.mapList((e) => e.buildCondition()).nonNullList.filter((e) => e.isNotEmpty);
    if (ls.isEmpty) return null;
    if (ls.length == 1) return ls.first;
    String s = ls.join(',');
    return "{$s}";
  }

  @override
  String toString() {
    return buildCondition() ?? "";
  }
}

class OrCond extends QueryCond {
  List<QueryCond> conditions;

  OrCond(List<QueryCond?> list) : conditions = list.nonNullList;

  @override
  String? buildCondition() {
    List<QueryCond> flatList = [];
    for (QueryCond q in conditions) {
      switch (q) {
        case FieldCond fc:
          flatList.add(fc);
        case AndCond ac:
          flatList.add(ac);
        case OrCond oc:
          flatList.addAll(oc.conditions);
      }
    }
    List<String> ls = flatList.mapList((e) => e.buildCondition()).nonNullList.filter((e) => e.isNotEmpty);
    if (ls.isEmpty) return null;
    if (ls.length == 1) return ls.first;
    String s = ls.join(',');
    return "[$s]";
  }

  @override
  String toString() {
    return buildCondition() ?? "";
  }
}
