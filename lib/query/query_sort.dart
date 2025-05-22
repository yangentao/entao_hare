part of 'query.dart';

/// QuerySort q = QuerySort("id").asc("name").desc("date")
/// http://xxx/list?sort=q.toString()
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
    if(field.isNotEmpty) {
      list << "_$field";
    }
    return this;
  }

  QuerySort desc(String field) {
    if(field.isNotEmpty) {
      list << "${field}_";
    }
    return this;
  }

  @override
  String toString() {
    return list.join(",");
  }
}
