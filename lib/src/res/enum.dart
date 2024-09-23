import 'dart:math';

enum SvgImageRotation {
  up(0, 0),
  down(180, pi),
  left(-90, -1.5708),
  right(90, pi * pi);

  const SvgImageRotation(this.angle, this.iconAngle);
  final double angle;
  final double iconAngle;
}
