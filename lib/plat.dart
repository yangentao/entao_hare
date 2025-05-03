
import 'dart:io';

import 'package:flutter/foundation.dart';

class Plat {
  Plat._();

  static bool get isDebug => kDebugMode;

  static bool get isDebugMode => kDebugMode;

  static bool get isWeb => kIsWeb || kIsWasm;

  static bool get isMobile => !isWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isDesktop => !isWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  static bool get isAndroid => !isWeb && (Platform.isAndroid);

  static bool get isIOS => !isWeb && (Platform.isIOS);

  static bool get isFuchsia => !isWeb && (Platform.isFuchsia);

  static bool get isMacOS => !isWeb && (Platform.isMacOS);

  static bool get isWindows => !isWeb && (Platform.isWindows);

  static bool get isLinux => !isWeb && (Platform.isLinux);
}
