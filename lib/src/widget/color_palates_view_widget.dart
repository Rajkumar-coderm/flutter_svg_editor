import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

class SvgColorPalateWidget extends StatefulWidget {
  const SvgColorPalateWidget({
    super.key,
    required this.getSvgImageColors,
    required this.onChangeSvgColor,
    this.resetSvgData,
    this.copySvgData,
    this.onRotate,
    required this.rotation,
    required this.constraints,
    this.downloadFile,
  });

  final List<ColorWithAtributeModel> getSvgImageColors;
  final Function(int index, Color color) onChangeSvgColor;
  final VoidCallback? resetSvgData;
  final VoidCallback? copySvgData;
  final Function(SvgImageRotation rotaion)? onRotate;
  final SvgImageRotation rotation;
  final BoxConstraints constraints;
  final VoidCallback? downloadFile;

  @override
  State<SvgColorPalateWidget> createState() => SvgColorPalateWidgetState();
}

class SvgColorPalateWidgetState extends State<SvgColorPalateWidget> {
  OverlayEntry? colorOverlayEntry;

  void closeOverlayEntry() {
    if (colorOverlayEntry != null) {
      colorOverlayEntry?.remove();
      colorOverlayEntry = null;
    }
  }

  Future<void> showColorPicker(
    BuildContext context,
    int index,
  ) async =>
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(12),
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor:
                  widget.getSvgImageColors[index].color.toHexColorCode(),
              onColorChanged: (color) {
                widget.onChangeSvgColor.call(index, color);
              },
              hexInputController: TextEditingController(),
              displayThumbColor: true,
              hexInputBar: true,
              enableAlpha: false,
              colorPickerWidth: 250,
            ),
          ),
        ),
      );

  Future<void> openOverlayEntry(
    BuildContext context,
    int index,
  ) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Get hight of Overlay widget which is rendor on message tap
    var overlayHeight = 300;
    var isOverFlowing =
        (overlayHeight + offset.dy + 35) > MediaQuery.of(context).size.height;

    var topPosition = offset.dy + 35;

    if (isOverFlowing) {
      topPosition = MediaQuery.of(context).size.height - overlayHeight - 30;
    }

    OverlayState? overlayState = Overlay.of(context);
    colorOverlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        // left: offset.dx + size.width - 5,
        right: size.width + 5,
        top: topPosition,
        child: Card(
          elevation: 1,
          shadowColor: Colors.black,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ColorPicker(
              pickerColor:
                  widget.getSvgImageColors[index].color.toHexColorCode(),
              onColorChanged: (color) {
                widget.onChangeSvgColor.call(index, color);
              },
              hexInputController: TextEditingController(),
              displayThumbColor: true,
              hexInputBar: true,
              enableAlpha: false,
              colorPickerWidth: 250,
            ),
          ),
        ),
      ),
    );
    overlayState.insert(colorOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: closeOverlayEntry,
        child: SizedBox(
          width: Utilities.isMobile(context)
              ? Utilities.percentegeWidth(context, 1)
              : 350,
          height: Utilities.isMobile(context)
              ? (widget.constraints.maxHeight -
                      (widget.constraints.maxHeight / 2)) -
                  74
              : null,
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ITEM COLORS',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Reset',
                    onPressed: () {
                      widget.resetSvgData?.call();
                    },
                    icon: const Icon(
                      Icons.restore_outlined,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: () {
                      widget.copySvgData?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Copied to clipboard',
                            style: TextStyle(color: Colors.white),
                          ),
                          width: 200,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.file_copy_outlined,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Download',
                    onPressed: () async {
                      widget.downloadFile?.call();
                    },
                    icon: const Icon(
                      Icons.file_download_outlined,
                    ),
                  ),
                ],
              ),
              Utilities.boxHeight(10),
              SizedBox(
                width: Utilities.isMobile(context)
                    ? Utilities.percentegeWidth(context, 1)
                    : 350,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 15 / 15,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: widget.getSvgImageColors.length,
                  itemBuilder: (context, index) {
                    final key = GlobalKey();
                    return Tooltip(
                      key: key,
                      message: widget
                          .getSvgImageColors[index].color.colorTextToHexColor
                          .toUpperCase(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () async {
                          if (Utilities.isMobile(context)) {
                            await showColorPicker(key.currentContext!, index);
                          } else {
                            closeOverlayEntry();
                            await openOverlayEntry(key.currentContext!, index);
                          }
                        },
                        child: DecoratedBox(
                          position: DecorationPosition.foreground,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: ColoredBox(
                              color: widget.getSvgImageColors[index].color
                                  .toHexColorCode(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Utilities.boxHeight(10),
              const Divider(
                height: .5,
              ),
              Utilities.boxHeight(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FLIP',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Utilities.boxHeight(10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        SvgImageRotation.values.length,
                        (index) {
                          final element = SvgImageRotation.values[index];
                          return InkWell(
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              widget.onRotate?.call(element);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 250,
                              ),
                              margin: const EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                left: 2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: widget.rotation == element
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: Tooltip(
                                message: element.iconAsset,
                                child: SvgPicture.asset(
                                  element.iconAsset,
                                  package: 'flutter_svg_editor',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
