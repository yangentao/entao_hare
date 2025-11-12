import 'package:entao_http/entao_http.dart';

import '../basic/basic.dart';

extension HttpResultToast on HttpResult {
  void showError({String? nullMessage}) {
    if (!this.success) {
      Toast.error(this.message);
    }
  }

  void showMessage({String? nullMessage}) {
    if (this.success) {
      Toast.success(this.message);
    } else {
      Toast.error(this.message);
    }
  }
}
