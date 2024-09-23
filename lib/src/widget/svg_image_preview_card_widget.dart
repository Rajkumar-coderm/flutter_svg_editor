import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

class SvgImagePreviewCardWidget extends StatelessWidget {
  const SvgImagePreviewCardWidget({
    super.key,
    required String editedSvg,
    required double rotation,
  })  : _editedSvg = editedSvg,
        _rotation = rotation;

  final String _editedSvg;
  final double _rotation;

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.white,
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: SvgEditorUtils.isMobile(context)
              ? SvgEditorUtils.percentegeHeight(
                  context,
                  .5,
                )
              : 400.0,
          width: SvgEditorUtils.isMobile(context)
              ? SvgEditorUtils.percentegeWidth(
                  context,
                  1,
                )
              : 400.0,
          child: Transform.rotate(
            angle: _rotation,
            child: SvgPicture.string(
              _editedSvg,
              semanticsLabel: 'SVG Asset',
              height: SvgEditorUtils.isMobile(context)
                  ? SvgEditorUtils.percentegeHeight(
                      context,
                      .5,
                    )
                  : 400.0,
              width: SvgEditorUtils.isMobile(context)
                  ? SvgEditorUtils.percentegeWidth(
                      context,
                      1,
                    )
                  : 400.0,
            ),
          ),
        ),
      );
}
