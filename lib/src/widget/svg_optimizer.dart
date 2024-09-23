import 'package:xml/xml.dart' as xml;

class SvgOptimizer {
  // [optimizeSvg] this  to simplify and optimize SVG
  String optimizeSvg(String svgString) {
    final document = xml.XmlDocument.parse(svgString);
    _mergePaths(document);
    _removeRedundantElements(document);
    _simplifyPaths(document);
    return document.toXmlString();
  }

  // Step 1: Merge paths with the same style
  void _mergePaths(xml.XmlDocument document) {
    final paths = document.findAllElements('path').toList();

    // Group paths by common style attributes like 'fill' and 'stroke'
    final pathGroups = <String, List<xml.XmlElement>>{};

    for (final path in paths) {
      final styleKey =
          '${path.getAttribute('fill')}-${path.getAttribute('stroke')}';
      pathGroups.putIfAbsent(styleKey, () => []).add(path);
    }

    // Merge paths that have the same style
    for (final group in pathGroups.values) {
      if (group.length > 1) {
        final mergedPathData =
            group.map((path) => path.getAttribute('d')).join(' ');
        final firstPath = group.first;
        firstPath.setAttribute('d', mergedPathData);

        // Remove redundant paths
        for (var i = 1; i < group.length; i++) {
          group[i].parent?.children.remove(group[i]);
        }
      }
    }
  }

  // Step 2: Remove empty or redundant elements
  void _removeRedundantElements(xml.XmlDocument document) {
    final elements = document.descendants.toList();
    for (final element in elements) {
      if (element is xml.XmlElement) {
        // Remove elements with no child elements or attributes
        if (element.children.isEmpty && element.attributes.isEmpty) {
          element.parent?.children.remove(element);
        }
      }
    }
  }

  // Step 3: Simplify complex paths by reducing precision (basic example)
  void _simplifyPaths(xml.XmlDocument document) {
    final paths = document.findAllElements('path').toList();

    for (final path in paths) {
      var d = path.getAttribute('d');
      if (d != null) {
        // Simplify the path data by rounding off numbers (basic approach)
        d = d.replaceAllMapped(RegExp(r'([0-9]*\.[0-9]+)'), (match) {
          final numValue = double.tryParse(match[0] ?? '0') ?? 0;
          return numValue.toStringAsFixed(2);
        });
        path.setAttribute('d', d);
      }
    }
  }
}
