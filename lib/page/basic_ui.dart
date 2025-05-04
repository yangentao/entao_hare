part of '../entao_hare.dart';

const Color primaryColor = Color(0xFFF44336);

ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(100, 44));

ButtonStyle get elevatedButtonStyleLarge => ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(132, 44));

List<DropdownMenuItem<String>> makeDropList(List<String> items) {
  return items
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Center(child: Text(e)),
          ))
      .toList();
}
