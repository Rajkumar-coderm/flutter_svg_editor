import 'package:flutter/material.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

class EmptySvgPreviewBoxWidget extends StatefulWidget {
  const EmptySvgPreviewBoxWidget({
    super.key,
    required this.constraints,
    required this.uploadImage,
    required this.isUploading,
  });

  final BoxConstraints constraints;
  final VoidCallback uploadImage;
  final bool isUploading;

  @override
  State<EmptySvgPreviewBoxWidget> createState() =>
      _EmptySvgPreviewBoxWidgetState();
}

class _EmptySvgPreviewBoxWidgetState extends State<EmptySvgPreviewBoxWidget> {
  bool _onHover = false;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.grey.withOpacity(.2),
        child: SizedBox(
          height: SvgEditorUtils.isMobile(context)
              ? widget.constraints.maxHeight - 73
              : widget.constraints.maxHeight - 73,
          child: Center(
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.opaque,
              cursor: MouseCursor.defer,
              onEnter: (_) => setState(() => _onHover = true),
              onExit: (_) => setState(() => _onHover = false),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  widget.uploadImage();
                },
                child: Card(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: SvgEditorUtils.isMobile(context)
                          ? SvgEditorUtils.percentegeHeight(
                              context,
                              .3,
                            )
                          : 350.0,
                      maxWidth: SvgEditorUtils.isMobile(context)
                          ? SvgEditorUtils.percentegeWidth(
                              context,
                              .7,
                            )
                          : 350.0,
                    ),
                    child: DottedBorder(
                      color: _onHover || widget.isUploading
                          ? Colors.blue
                          : Colors.grey.withOpacity(.6),
                      strokeWidth: 1.5,
                      gap: 2,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.isUploading
                                ? const Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.blue,
                                    size: 45,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 45,
                                  ),
                            SvgEditorUtils.boxHeight(10),
                            Text(
                              widget.isUploading
                                  ? 'Drop your file to upload'
                                  : 'Drop your SVG here',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
