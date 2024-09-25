import 'package:flutter/material.dart';
import 'package:flutter_svg_editor/flutter_svg_editor.dart';

class SvgEditorHeaderWidget extends StatelessWidget {
  const SvgEditorHeaderWidget({
    super.key,
    required this.uploadNewSvg,
  });

  final VoidCallback uploadNewSvg;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Row(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.format_color_fill_outlined,
                ),
                Utilities.boxWidth(10),
                const Text(
                  'Color Editor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const Spacer(),
            HeaderButtonWidget(
              onTap: () async {
                uploadNewSvg();
              },
            )
          ],
        ),
      );
}

class HeaderButtonWidget extends StatelessWidget {
  const HeaderButtonWidget({
    super.key,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.buttonText = 'Uplaod New SVG',
    this.onTap,
  });
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      );
}
