// ignore_for_file: non_constant_identifier_names

part of 'query.dart';

typedef QueryConditionChange = void Function(QueryCond? condition);

mixin WithCondition on Widget {
  QueryConditionChange? onConditionChange;

  QueryCond? condition();
}

const List<QueryOp> commonConditionOperators = [
  QueryOp.eq,
  QueryOp.ge,
  QueryOp.le,
  QueryOp.gt,
  QueryOp.lt,
  QueryOp.ne,
  QueryOp.inset,
  QueryOp.nul
];
// const List<QueryOperator> numConditionOperators = [...commonConditionOperators, QueryOperator.bit];
const List<QueryOp> numConditionOperators = [...commonConditionOperators];
const List<QueryOp> textConditionOperators = [...commonConditionOperators, QueryOp.start, QueryOp.end, QueryOp.contain];

