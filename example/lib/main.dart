import 'package:flutter/material.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      theme: ThemeData.light(),
      home: Center(
        child: SizedBox(
          width: Utilities.isMobile(context)
              ? Utilities.percentegeWidth(context, 1)
              : Utilities.percentegeWidth(
                  context, Utilities.isTablet(context) ? .9 : .7),
          height: Utilities.isMobile(context)
              ? Utilities.percentegeHeight(context, 1)
              : Utilities.percentegeHeight(
                  context, Utilities.isTablet(context) ? .9 : .7),
          child: FlutterSvgEditor(
            onChange: (svgValue) {},
            onCopied: (svgValue) {},
            onReset: (svgValue) {},
          ),
        ),
      ),
    );
  }
}
