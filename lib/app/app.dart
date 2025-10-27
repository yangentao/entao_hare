library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/entao_hare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


part 'AppBuilder.dart';
part 'AppMap.dart';
part 'Assets.dart';
part 'FileConfig.dart';
part 'HareApp.dart';
part 'ThemePalette.dart';
part 'ThemeWidget.dart';
part 'router_date_widget.dart';



extension ThemeDataBright on ThemeData {
  bool get isDark => this.brightness == Brightness.dark;

  bool get isLight => this.brightness == Brightness.light;
}

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

Widget TextAction(String title, {Color? color, VoidCallback? onTap}) {
  return title.button(onTap, color: color ?? HareApp.themeData.colorScheme.onPrimary);
}
