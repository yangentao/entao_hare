part of '../fhare.dart';

extension ThemeDataExt on ThemeData {
  ThemeData copyListTileHorizontalTitleGap([double value = 4]) {
    return copyWith(listTileTheme: listTileTheme.copyWith(horizontalTitleGap: value));
  }
}
