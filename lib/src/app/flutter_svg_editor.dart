import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';
import 'package:flutter_svg_editor/src/managers/mobile_html_manager.dart'
    if (dart.library.html) 'package:flutter_svg_editor/src/managers/web_html_manager.dart'
    as multi_platform;
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;

export '../model/model.dart';
export '../res/res.dart';
export '../widget/widget.dart';

typedef SvgDataCallback = Function(String svgValue);

/// FlutterSvgEditor is a powerful widget that enables users to edit and manipulate SVG images with ease.
///
/// With this widget, users can upload new SVG images from their device or the web, edit the colors and attributes of individual SVG elements,
/// rotate and transform the image to their liking, copy and reset the SVG data, and even download the edited image as a file.
///
/// What's more, the widget provides a range of callbacks that allow developers to track changes to the SVG data in real-time,
/// such as when the user edits the colors or resets the image to its original state.
/// Example.
/// ```dart
/// FlutterSvgEditor(
///  onChange: (svgValue) {},
///  onCopied: (svgValue) {},
///  onReset: (svgValue) {},
/// )
/// ```
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

  String? _uploadedFileName;

  SvgImageRotation _selectedRotationAngle = SvgImageRotation.original;

  final overlaySteteKey = GlobalKey<SvgColorPalateWidgetState>();

  @override
  void initState() {
    super.initState();
    initCall();
  }

  void initCall() async {
    try {
      var result = await multi_platform.HtmlWebManager().setupDragDropListeners(
        (onDrag) {
          setState(() {
            _dragging = onDrag;
          });
        },
      );
      if (result.fileDataString != null) {
        _uploadedFileName = result.name;
        _loadSvgFromString(result.fileDataString ?? '');
      }
    } catch (e) {
      log('Error On upload SVG form drag:$e');
    }
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

  /// [changeSelectedColor]Change the selected svg color when user tap..
  ///
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
    var result = await uploadNewSvgFile();
    if (result != null) {
      _loadSvgFromString(result);
    }
  }

  ///[uploadNewSvgFile] Method to upload an SVG from mobile devices (Android/iOS/Linux Desktop/macOS/web)
  ///
  Future<String?> uploadNewSvgFile() async {
    try {
      if (kIsWeb) {
        var result =
            await multi_platform.HtmlWebManager().uploadNewSvgImageFormWeb();
        if (result.fileDataString != null) {
          _uploadedFileName = result.name;
          return result.fileDataString;
        } else {
          return null;
        }
      } else {
        final result = await FilePicker.platform.pickFiles(
          allowCompression: false,
          allowedExtensions: ['svg'],
          allowMultiple: false,
          type: FileType.custom,
        );
        if (result != null) {
          final file = File(result.files.first.path ?? '');
          var svgContent = await file.readAsString();
          _uploadedFileName = result.files.first.name;
          return svgContent;
        } else {
          return null;
        }
      }
    } catch (e) {
      log('Error uploading SVG: $e');
      return null;
    }
  }

  ///[downloadLatestFile] Download the latest updated file.
  ///[_editedSvg] this is data string to write new file..
  Future<void> downloadLatestFile() async {
    try {
      if (kIsWeb) {
        multi_platform.HtmlWebManager().downloadSvg(
          _editedSvg,
          _uploadedFileName ?? '',
        );
      } else {
        if (Platform.isLinux) {
          return;
        }
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        // Ensure the directory exists
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        // File path
        final filePath = '${directory.path}/${_uploadedFileName ?? ''}';
        final file = File(filePath);
        await file.writeAsString(_editedSvg);
      }
    } catch (e, st) {
      log('Error downloading SVG: $e $st ');
    }
  }

  // Parse the SVG string and update the state
  void _loadSvgFromString(String svgString) {
    final document = xml.XmlDocument.parse(svgString);
    setState(() {
      _parsedSvgDocument = document;
      _editedSvg = svgString;
      _inisialSvgString = svgString;
    });
    widget.onChange?.call(svgString);
  }

  /// Rest the SVG string on inisial data..
  void resetSvgImage() {
    final document = xml.XmlDocument.parse(_inisialSvgString ?? '');
    setState(() {
      _parsedSvgDocument = document;
      _editedSvg = _inisialSvgString ?? '';
      _inisialSvgString = _editedSvg;
      _selectedRotationAngle = SvgImageRotation.original;
    });
    widget.onReset?.call(_editedSvg);
  }

  /// Coppy the data string on clipboard.
  void copySvgData() async {
    await Clipboard.setData(ClipboardData(text: _editedSvg));
    widget.onCopied?.call(_editedSvg);
  }

  // Rotate the SVG image and update the transform attribute
  Future<void> flipSvgImage(SvgImageRotation rotation) async {
    try {
      // Parse the SVG XML string to crete one intance of XmlDocument that use for update the svg..
      final document = xml.XmlDocument.parse(_editedSvg);
      final svgElement = document.findAllElements('svg').first;

      // Get the current width and height
      var currentWidth =
          double.tryParse(svgElement.getAttribute('width') ?? '0') ?? 0;
      var currentHeight =
          double.tryParse(svgElement.getAttribute('height') ?? '0') ?? 0;

      // Check for existing transforms and remove any previous rotate transforms
      var existingTransform = svgElement.getAttribute('transform') ?? '';
      existingTransform = existingTransform
          .replaceAll(RegExp(r'translate\([^)]+\)'), '')
          .replaceAll(RegExp(r'scale\([^)]+\)'), '')
          .trim();

      // Apply the new rotation transformation
      final newTransform =
          'translate(${rotation.translate(width: currentWidth, height: currentHeight).x}, ${rotation.translate(width: currentWidth, height: currentHeight).y}) scale(${rotation.vectors.x}, ${rotation.vectors.x}) translate(${rotation.translate(width: currentWidth, height: currentHeight).x}, ${rotation.translate(width: currentWidth, height: currentHeight).y})';

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
        _selectedRotationAngle = rotation;
      });
    } catch (e, st) {
      log('Error rotating SVG: $e\n$st');
    }
    widget.onChange?.call(_editedSvg);
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
                              direction: Utilities.isMobile(context)
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              children: [
                                Utilities.isMobile(context)
                                    ? SizedBox(
                                        height: constraints.maxHeight / 2,
                                        child: SvgImagePreviewBody(
                                          editedSvg: _editedSvg,
                                          rotationAngle: _selectedRotationAngle,
                                        ),
                                      )
                                    : Expanded(
                                        child: SvgImagePreviewBody(
                                          editedSvg: _editedSvg,
                                          rotationAngle: _selectedRotationAngle,
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
                                  onRotate: flipSvgImage,
                                  downloadFile: () async {
                                    await downloadLatestFile();
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
    required SvgImageRotation rotationAngle,
  })  : _editedSvg = editedSvg,
        _rotationAngle = rotationAngle;

  final String _editedSvg;
  final SvgImageRotation _rotationAngle;

  @override
  Widget build(BuildContext context) => Container(
        width: Utilities.isMobile(context)
            ? Utilities.percentegeWidth(context, 1)
            : Utilities.percentegeWidth(
                context,
                .4,
              ),
        height: Utilities.isMobile(context)
            ? Utilities.percentegeHeight(
                context,
                .5,
              )
            : double.maxFinite,
        color: Colors.grey.withOpacity(.2),
        padding: EdgeInsets.all(Utilities.isMobile(context) ? 10 : 25),
        child: Utilities.isMobile(context)
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
