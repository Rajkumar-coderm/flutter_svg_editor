import 'package:flutter/material.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

extension ColorHex on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0')}';
}

extension HexColorExtension on String {
  String get colorTextToHexColor {
    if (!startsWith('#')) {
      final colorsCode = SvgColorsCodes.colorsAndCodesData;

      var colorKey = '';

      for (var x in colorsCode.entries) {
        if (x.value.trim().toLowerCase() == trim().toLowerCase()) {
          colorKey = x.key;
          break;
        }
      }
      return colorKey;
    }
    return this;
  }

  Color toHexColorCode() {
    if (startsWith('#')) {
      var hexString = toUpperCase().replaceAll('#', '');

      // Handle 3-character hex (e.g., #FFF => #FFFFFF)
      if (hexString.length == 3) {
        hexString = hexString.split('').map((char) => char + char).join();
      }

      // Add alpha value if not provided (assume full opacity, i.e., FF)
      if (hexString.length == 6) {
        hexString = 'FF$hexString';
      }

      // Convert hex string to int and create a Color
      return Color(int.parse(hexString, radix: 16));
    } else {
      final colorsCode = SvgColorsCodes.colorsAndCodesData;

      var colorKey = '';

      for (var x in colorsCode.entries) {
        if (x.value.trim().toLowerCase() == trim().toLowerCase()) {
          colorKey = x.key;
          break;
        }
      }

      if (colorKey.trim().isNotEmpty) {
        var hexString = colorKey.toUpperCase().replaceAll('#', '');

        // Handle 3-character hex (e.g., #FFF => #FFFFFF)
        if (hexString.length == 3) {
          hexString = hexString.split('').map((char) => char + char).join();
        }

        // Add alpha value if not provided (assume full opacity, i.e., FF)
        if (hexString.length == 6) {
          hexString = 'FF$hexString';
        }

        var code = Color(int.parse(hexString, radix: 16));
        // Convert hex string to int and create a Color
        return code;
      }
      return const Color(0x00ffffff);
    }
  }
}
