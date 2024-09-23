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
      home: FlutterSvgEditor(
        onChange: (svgValue) {},
        onCopied: (svgValue) {},
        onReset: (svgValue) {},
      ),
    );
  }
}
