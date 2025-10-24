library;

import 'dart:ui';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../basic/basic.dart';

part 'AppMap.dart';
part 'HareApp.dart';
part 'router_date_widget.dart';
part 'ThemeWidget.dart';
part 'AppBuilder.dart';

ThemeData LightThemeData({required Color seed, bool useMaterial3 = false}) {
  ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.light);
  return ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
}

ThemeData DarkThemeData({required Color seed, bool useMaterial3 = false}) {
  ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.dark);
  return ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
}

class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => _deviceTypes;
}

const Set<PointerDeviceKind> _deviceTypes = <PointerDeviceKind>{
  PointerDeviceKind.touch,
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
  PointerDeviceKind.trackpad,
  PointerDeviceKind.mouse,
  // The VoiceAccess sends pointer events with unknown type when scrolling
  // scrollables.
  PointerDeviceKind.unknown,
};
