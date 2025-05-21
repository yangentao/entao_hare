part of 'query.dart';

enum QueryOp {
  eq(op: "eq", label: "="),
  ne(op: "ne", label: "≠"),
  ge(op: "ge", label: "≥"),
  le(op: "le", label: "≤"),
  gt(op: "gt", label: ">"),
  lt(op: "lt", label: "<"),
  bit(op: "bit", label: "拥有标识"),
  start(op: "start", label: "开始于"),
  end(op: "end", label: "结束于"),
  contain(op: "contain", label: "包含"),
  nul(op: "nul", label: "是空", argCount: 0),
  inset(op: "in", label: "集合", argCount: 2);

  const QueryOp({required this.op, required this.label, this.argCount = 1});

  final String op;
  final String label;
  final int argCount;
}
