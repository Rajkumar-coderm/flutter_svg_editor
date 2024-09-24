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
      home: Center(
        child: SizedBox(
          width: SvgEditorUtils.isMobile(context)
              ? SvgEditorUtils.percentegeWidth(context, 1)
              : SvgEditorUtils.percentegeWidth(context, .7),
          height: SvgEditorUtils.isMobile(context)
              ? SvgEditorUtils.percentegeHeight(context, 1)
              : SvgEditorUtils.percentegeHeight(context, .7),
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
