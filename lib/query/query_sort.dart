part of 'query.dart';

/// QuerySort q = QuerySort().asc("name").desc("date")
/// sort=q.toString()
class QuerySort {
  List<String> list = [];

  QuerySort({String? field, bool asc = true}) {
    if (field != null && field.isNotEmpty) {
      if (asc) {
        this.asc(field);
      } else {
        this.desc(field);
      }
    }
  }

  QuerySort asc(String field) {
    list << "_$field";
    return this;
  }

  QuerySort desc(String field) {
    list << "${field}_";
    return this;
  }

  @override
  String toString() {
    return list.join(",");
  }
}
