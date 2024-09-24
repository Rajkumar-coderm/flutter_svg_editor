import 'package:flutter_svg_editor/flutter_svg_editor.dart';

enum SvgImageRotation {
  original(0),
  vertical(-90),
  horizontal(180),
  both(90);

  const SvgImageRotation(this.angle);
  final double angle;

  AppVectors get vectors => switch (this) {
        SvgImageRotation.original => AppVectors(x: 1, y: 1, z: 1),
        SvgImageRotation.vertical => AppVectors(x: -1, y: 1, z: 1),
        SvgImageRotation.both => AppVectors(x: 1, y: -1, z: 1),
        SvgImageRotation.horizontal => AppVectors(x: -1, y: -1, z: 1),
      };

  AppVectors translate({
    double width = 0,
    double height = 0,
  }) =>
      switch (this) {
        SvgImageRotation.original => AppVectors(),
        SvgImageRotation.vertical => AppVectors(x: -width * 0.5),
        SvgImageRotation.both => AppVectors(y: -height * 0.5),
        SvgImageRotation.horizontal =>
          AppVectors(x: -width * 0.5, y: -height * .5),
      };

  String get iconAsset => switch (this) {
        SvgImageRotation.original => 'assets/original.svg',
        SvgImageRotation.horizontal => 'assets/horizontal.svg',
        SvgImageRotation.vertical => 'assets/vertical.svg',
        SvgImageRotation.both => 'assets/both.svg',
      };
}
