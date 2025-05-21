import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/query/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    var c = AndCond([
      FieldCond(field: "name", op: QueryOp.eq, values: ["entao"]),
      OrCond([
        FieldCond(field: "addr", op: QueryOp.ne, values: ["Jinan"]),
        FieldCond(field: "age", op: QueryOp.ge, values: [49]),
      ]),
    ]);

    printX(c.buildCondition());
  });
}
