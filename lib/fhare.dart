// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_http/entao_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'entao_basic.dart';
import 'entao_harepage.dart';
import 'entao_harewidget.dart';

part 'app/AppMap.dart';
part 'app/router_date_widget.dart';
part 'app/HareApp.dart';
part 'basic/basic.dart';
part 'basic/files.dart';
part 'basic/ini.dart';
part 'basic/io.dart';
part 'basic/local_store.dart';
part 'basic/modbus.dart';
part 'basic/numbers.dart';
part 'basic/options.dart';
part 'basic/text_validator.dart';
part 'binder/Binder.dart';
part 'binder/binder_chip.dart';
part 'binder/binder_radio.dart';
part 'binder/binder_segments.dart';
part 'binder/binder_widgets.dart';
part 'examples/AnimPage.dart';
part 'hare/dash.dart';
part "hare/dash_content.dart";
part "hare/dash_desktop.dart";
part "hare/dash_mobile.dart";
part 'hare/dash_page.dart';
part 'hare/hare_app_bar.dart';
part 'hare/hare_button.dart';
part 'hare/hare_edit.dart';
part 'hare/hare_ext.dart';
part 'hare/hare_text.dart';
part 'hare/hare_widgets.dart';
part 'hare/page_attr.dart';
part 'page/basic_ui.dart';
part 'page/bottom_nav_bar.dart';
part 'page/collection_page.dart';
part 'page/column_page.dart';
part 'page/grid_page.dart';
part 'page/list_page.dart';
part 'page/login_page.dart';
part 'page/login_page_x.dart';
part 'page/page_tab_list.dart';
part 'page/prepare_page.dart';
part 'page/query_panel.dart';
part 'page/refresh_page.dart';
part 'page/search_dialog.dart';
part 'page/tabbar_page.dart';
part 'page/table_page.dart';
part 'page/table_single_page.dart';
part 'query/query_builder.dart';
part 'query/query_dropdown_widget.dart';
part 'query/query_input_widget.dart';
part 'query/query_operator_widget.dart';
part 'query/query_segment.dart';
part 'query/query_single.dart';
part 'widget/actions.dart';
part 'widget/auto_complete.dart';
part 'widget/bread_crumb.dart';
part 'widget/chips.dart';
part 'widget/custom.dart';
part 'widget/data_table.dart';
part 'widget/dialog_builder.dart';
part 'widget/dialogs.dart';
part 'widget/edits.dart';
part 'widget/int_item_pick.dart';
part 'widget/pagination.dart';
part 'widget/pop_context_menu.dart';
part 'widget/popup.dart';
part 'widget/radios.dart';
part 'widget/segments.dart';
part 'widget/slider.dart';
part 'widget/table.dart';
part 'widget/table_selector.dart';
part 'widget/table_sorter.dart';
part 'widget/tree_path.dart';
part 'widget/websocket_wrap.dart';

// part 'widget/radios.dart';
// part 'basic/values.dart';
// part 'basic/files.dart';

final Icon moreArrow = Icons.keyboard_arrow_right.icon();
final IconData MORE_ICON = Icons.adaptive.more_rounded;

extension BuildContextEx on BuildContext {}

extension StringText on String {
  HareText hareText({TextAlign? align, TextStyle? style}) {
    return HareText(this, style: style, textAlign: align);
  }
}

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
