// ignore_for_file: must_be_immutable
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_http/entao_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'basic/basic.dart';
import 'dialog/dialog.dart';
import 'harepage/harepage.dart';
import 'harewidget/harewidget.dart';
import 'widgets/widgets.dart';

export 'app/app.dart';
export 'basic/basic.dart';
export 'binder/binders.dart';
export 'dash/dash.dart';
export 'dialog/dialog.dart';
export 'harepage/harepage.dart';
export 'harewidget/harewidget.dart';
export 'pages/pages.dart';
export 'query/query.dart';
export 'table/table.dart';
export 'widgets/widgets.dart';

part 'examples/AnimPage.dart';
part 'utils/basic.dart';
part 'utils/files.dart';
part 'utils/ini.dart';
part 'utils/io.dart';
part 'utils/modbus.dart';
part 'utils/search_dialog.dart';
part 'widget/hare_ext.dart';
part 'widget/pop_context_menu.dart';
part 'widget/tree_path.dart';
part 'widget/websocket_wrap.dart';

// part 'widget/radios.dart';
// part 'utils/values.dart';
// part 'utils/files.dart';

extension HttpResultToast on HttpResult {
  void showError({String? nullMessage}) {
    if (!this.success) {
      Toast.error(this.message ?? nullMessage ?? "操作失败");
    }
  }

  void showMessage({String? nullMessage}) {
    if (this.success) {
      Toast.success(this.message ?? nullMessage ?? "操作成功");
    } else {
      Toast.error(this.message ?? nullMessage ?? "操作失败");
    }
  }
}
