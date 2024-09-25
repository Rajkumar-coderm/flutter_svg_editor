import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

class SvgImagePreviewCardWidget extends StatelessWidget {
  const SvgImagePreviewCardWidget({
    super.key,
    required String editedSvg,
    required SvgImageRotation rotation,
  })  : _editedSvg = editedSvg,
        _rotation = rotation;

  final String _editedSvg;
  final SvgImageRotation _rotation;

  double _width(BuildContext context) => Utilities.isMobile(context)
      ? Utilities.percentegeWidth(
          context,
          .5,
        )
      : Utilities.isTablet(context)
          ? 290.0
          : 400.0;

  double _height(BuildContext context) => Utilities.isMobile(context)
      ? Utilities.percentegeHeight(
          context,
          .5,
        )
      : Utilities.isTablet(context)
          ? 290.0
          : 400.0;

  @override
  Widget build(BuildContext context) {
    final _translate = _rotation.translate(
      width: _width(context),
      height: _height(context),
    );

    final _scale = _rotation.vectors;

    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: _height(context),
          width: _width(context),
          child: Transform(
            transform: Matrix4.identity()
              ..translate(
                -_translate.x,
                -_translate.y,
                -_translate.z,
              )
              ..scale(_scale.x, _scale.y, _scale.z)
              ..translate(
                _translate.x,
                _translate.y,
                _translate.z,
              ),
            child: SvgPicture.string(
              _editedSvg,
              semanticsLabel: 'SVG Asset',
              height: _height(context),
              width: _width(context),
            ),
          ),
        ),
      ),
    );
  }
}
