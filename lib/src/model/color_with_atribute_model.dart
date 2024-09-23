/// A data model that represents a color with an associated attribute.
class ColorWithAtributeModel {
  /// Constructor for creating a new ColorWithAtributeModel instance.
  ///
  /// Requires a color and an attribute, both of which are strings.
  ColorWithAtributeModel({
    required this.color,
    required this.attribute,
  });

  /// The color value, represented as a string.
  final String color;

  /// The attribute associated with the color, represented as a string.
  final String attribute;
}
