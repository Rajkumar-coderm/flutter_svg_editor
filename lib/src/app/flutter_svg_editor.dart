import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_editor/src/app/flutter_svg_editor.dart';
import 'package:flutter_svg_editor/src/managers/mobile_html_manager.dart'
    if (dart.library.html) 'package:flutter_svg_editor/src/managers/web_html_manager.dart'
    as multi_platform;
import 'package:xml/xml.dart' as xml;

export '../model/model.dart';
export '../res/res.dart';
export '../widget/widget.dart';

typedef SvgDataCallback = Function(String svgValue);

class FlutterSvgEditor extends StatefulWidget {
  const FlutterSvgEditor({
    super.key,
    this.onChange,
    this.onCopied,
    this.onReset,
  });

  /// Callback that is triggered when the SVG data changes.
  ///
  /// This callback is invoked whenever an action results in a change
  /// to the SVG content, such as editing the colors, transforming
  /// elements, or adding new elements.
  ///
  /// - [onChange]: A callback function that provides the updated SVG data.
  final SvgDataCallback? onChange;

  /// Callback that is triggered when the SVG data is copied.
  ///
  /// This callback is invoked when the user copies the current SVG data.
  /// It can be used to handle the copying event, such as showing a
  /// confirmation message or saving the copied data to the clipboard.
  ///
  /// - [onCopied]: A callback function that provides the copied SVG data.
  final SvgDataCallback? onCopied;

  /// Callback that is triggered when the SVG data is reset to its original state.
  ///
  /// This callback is invoked when the user decides to reset all changes
  /// and return the SVG to its original unedited form.
  /// It can be used to handle the reset event, such as refreshing the
  /// UI to reflect the initial SVG.
  ///
  /// - [onReset]: A callback function that provides the reset SVG data.
  final SvgDataCallback? onReset;

  @override
  FlutterSvgEditorState createState() => FlutterSvgEditorState();
}

class FlutterSvgEditorState extends State<FlutterSvgEditor> {
  late xml.XmlDocument _parsedSvgDocument;

  String _editedSvg = '';

  String? _inisialSvgString;

  bool _dragging = false;

  double _rotationAngle = 0;

  SvgImageRotation _selectedRotationAngle = SvgImageRotation.up;

  final overlaySteteKey = GlobalKey<SvgColorPalateWidgetState>();

  @override
  void initState() {
    super.initState();
    initCall();
  }

  void initCall() async {
    var svgData = await multi_platform.HtmlWebManager().setupDragDropListeners(
      (onDrag) {
        setState(() {
          _dragging = onDrag;
        });
      },
    );
    _loadSvgFromString(svgData);
  }

  /// GET the all colors form svg picture..
  List<ColorWithAtributeModel> get getSvgImageColors {
    var colors = <ColorWithAtributeModel>[];
    final document = _parsedSvgDocument;
    final svgElements = document.findAllElements('*');
    for (var i in svgElements) {
      var fillColor = i.getAttribute('fill');
      var stopColor = i.getAttribute('stop-color');
      var strokeColor = i.getAttribute('stroke');
      if (fillColor != null) {
        colors.add(
          ColorWithAtributeModel(
            color: fillColor,
            attribute: 'fill',
          ),
        );
      }
      if (strokeColor != null) {
        colors.add(
          ColorWithAtributeModel(
            color: strokeColor,
            attribute: 'stroke',
          ),
        );
      }
      if (stopColor != null) {
        colors.add(
          ColorWithAtributeModel(
            color: stopColor,
            attribute: 'stop-color',
          ),
        );
      }
    }
    var uniqueColors = <ColorWithAtributeModel>[];
    for (var color in colors) {
      if (!uniqueColors.any((element) =>
          element.color == color.color &&
          element.attribute == color.attribute)) {
        uniqueColors.add(color);
      }
    }
    uniqueColors.removeWhere((element) => element.color == 'none');

    return uniqueColors;
  }

  /// Change the selected svg color when user tap..
  void changeSelectedColor(
    String initsialColor,
    Color finalColor,
    String attribute,
  ) async {
    final document = _parsedSvgDocument;
    final svgElements = document.findAllElements('*').toList();
    var element = svgElements
        .where(
          (element) => element.getAttribute(attribute) == initsialColor,
        )
        .toList();
    for (var e in element) {
      e.setAttribute(
        attribute,
        finalColor.toHex().replaceAll('ff', ''),
      );
    }
    setState(() {
      _editedSvg = document.toXmlString(pretty: true);
    });
    widget.onChange?.call(_editedSvg);
  }

  /// Upload new Svg image form device..
  void _uploadNewSvg() async {
    if (kIsWeb) {
      var svgData =
          await multi_platform.HtmlWebManager().uploadNewSvgImageFormWeb();
      _loadSvgFromString(svgData);
    } else {
      var svgData = await uploadSvgFromMobile();
      if (svgData != null) {
        _loadSvgFromString(svgData);
      }
    }
  }

  // Method to upload an SVG from mobile devices (Android/iOS)
  Future<String?> uploadSvgFromMobile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowCompression: false,
        allowedExtensions: ['svg'],
        allowMultiple: false,
        type: FileType.custom,
      );
      if (result != null) {
        final file = File(result.files.first.path ?? '');
        var svgContent = await file.readAsString();
        return svgContent;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Parse the SVG string and update the state
  void _loadSvgFromString(String svgString) {
    final d1 = SvgOptimizer();
    var optimizeSvg = d1.optimizeSvg(svgString);
    final document = xml.XmlDocument.parse(optimizeSvg);
    setState(() {
      _parsedSvgDocument = document;
      _editedSvg = optimizeSvg;
      _inisialSvgString = optimizeSvg;
    });
    widget.onChange?.call(optimizeSvg);
  }

  void resetSvgImage() {
    final document = xml.XmlDocument.parse(_inisialSvgString ?? '');
    setState(() {
      _parsedSvgDocument = document;
      _editedSvg = _inisialSvgString ?? '';
      _inisialSvgString = _editedSvg;
      _selectedRotationAngle = SvgImageRotation.up;
      _rotationAngle = 0;
    });
    widget.onReset?.call(_editedSvg);
  }

  void copySvgData() async {
    await Clipboard.setData(ClipboardData(text: _editedSvg));
    widget.onCopied?.call(_editedSvg);
  }

  // Rotate the SVG image and update the transform attribute
  void _rotateSvg(SvgImageRotation rotation) async {
    try {
      // Parse the SVG XML string to crete one intance of XmlDocument that use for update the svg..
      final document = xml.XmlDocument.parse(_editedSvg);
      final svgElement = document.findAllElements('svg').first;

      // Check for existing transforms and remove any previous rotate transforms
      var existingTransform = svgElement.getAttribute('transform') ?? '';
      existingTransform = _removePreviousRotation(existingTransform);

      // Apply the new rotation transformation
      final newTransform = 'rotate(${rotation.angle} 0 0)';

      // Combine the new rotation with any other existing transforms
      final updatedTransform = existingTransform.isNotEmpty
          ? '$existingTransform $newTransform'
          : newTransform;

      // Update the 'transform' attribute
      svgElement.setAttribute('transform', updatedTransform);

      // Update the state to reflect the changes
      setState(() {
        _editedSvg = document.toXmlString(pretty: true);
        _parsedSvgDocument = document;
        _rotationAngle = rotation.angle * (math.pi / 180);
        _selectedRotationAngle = rotation;
      });
    } catch (e, st) {
      log('Error rotating SVG: $e\n$st');
    }
  }

  // Helper method to remove any previous rotation from the transform attribute
  String _removePreviousRotation(String transform) {
    final rotationRegex = RegExp(r'rotate\([^)]*\)');
    return transform.replaceAll(rotationRegex, '').trim();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: GestureDetector(
          onTap: () {
            overlaySteteKey.currentState?.closeOverlayEntry();
            setState(() {});
          },
          child: Scaffold(
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  Card(
                margin: const EdgeInsets.all(0),
                color: Colors.white,
                elevation: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgEditorHeaderWidget(
                      uploadNewSvg: () async {
                        _uploadNewSvg();
                      },
                    ),
                    const Divider(
                      height: .5,
                    ),
                    _editedSvg.isEmpty
                        ? EmptySvgPreviewBoxWidget(
                            constraints: constraints,
                            uploadImage: _uploadNewSvg,
                            isUploading: _dragging,
                          )
                        : Expanded(
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              direction: SvgEditorUtils.isMobile(context)
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              children: [
                                SvgEditorUtils.isMobile(context)
                                    ? SizedBox(
                                        height: constraints.maxHeight / 2,
                                        child: SvgImagePreviewBody(
                                          editedSvg: _editedSvg,
                                          rotationAngle: _rotationAngle,
                                        ),
                                      )
                                    : Expanded(
                                        child: SvgImagePreviewBody(
                                          editedSvg: _editedSvg,
                                          rotationAngle: _rotationAngle,
                                        ),
                                      ),
                                const VerticalDivider(
                                  width: 0.5,
                                ),
                                SvgColorPalateWidget(
                                  key: overlaySteteKey,
                                  constraints: constraints,
                                  rotation: _selectedRotationAngle,
                                  getSvgImageColors: getSvgImageColors,
                                  onChangeSvgColor: (index, color) async {
                                    changeSelectedColor(
                                      getSvgImageColors[index].color,
                                      color,
                                      getSvgImageColors[index].attribute,
                                    );
                                  },
                                  resetSvgData: resetSvgImage,
                                  copySvgData: copySvgData,
                                  onRotate: _rotateSvg,
                                  downloadFile: () async {
                                    multi_platform.HtmlWebManager().downloadSvg(
                                      _editedSvg,
                                      'first_data_file.svg',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class SvgImagePreviewBody extends StatelessWidget {
  const SvgImagePreviewBody({
    super.key,
    required String editedSvg,
    required double rotationAngle,
  })  : _editedSvg = editedSvg,
        _rotationAngle = rotationAngle;

  final String _editedSvg;
  final double _rotationAngle;

  @override
  Widget build(BuildContext context) => Container(
        width: SvgEditorUtils.isMobile(context)
            ? SvgEditorUtils.percentegeWidth(context, 1)
            : SvgEditorUtils.percentegeWidth(
                context,
                .4,
              ),
        height: SvgEditorUtils.isMobile(context)
            ? SvgEditorUtils.percentegeHeight(
                context,
                .5,
              )
            : double.maxFinite,
        color: Colors.grey.withOpacity(.2),
        padding: EdgeInsets.all(SvgEditorUtils.isMobile(context) ? 10 : 25),
        child: SvgEditorUtils.isMobile(context)
            ? SvgImagePreviewCardWidget(
                editedSvg: _editedSvg,
                rotation: _rotationAngle,
              )
            : UnconstrainedBox(
                child: SvgImagePreviewCardWidget(
                  editedSvg: _editedSvg,
                  rotation: _rotationAngle,
                ),
              ),
      );
}
