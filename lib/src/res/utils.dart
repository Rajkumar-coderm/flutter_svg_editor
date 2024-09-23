import 'package:flutter/material.dart';

class SvgEditorUtils {
  SvgEditorUtils._();

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
}
