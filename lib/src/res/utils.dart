import 'dart:math';

import 'package:flutter/material.dart';

class Utilities {
  Utilities._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768.95;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 &&
      MediaQuery.of(context).size.width >= 768.95;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double percentegeWidth(BuildContext context, double value) =>
      MediaQuery.of(context).size.width * value;

  static double percentegeHeight(BuildContext context, double value) =>
      MediaQuery.of(context).size.height * value;

  static SizedBox boxHeight(double height) => SizedBox(
        height: height,
      );

  static SizedBox boxWidth(double width) => SizedBox(
        width: width,
      );

  /// Returns text representation of a provided bytes value (e.g. 1kB, 1GB)
  static String formatBytes(int size, [int fractionDigits = 2]) {
    if (size <= 0) return '0 B';
    final multiple = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB'
    ][multiple]}';
  }
}
