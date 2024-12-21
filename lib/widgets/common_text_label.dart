import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonText extends StatelessWidget {
  final String data;
  final TextStyle? textStyle;
  final TextAlign? align;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextHeightBehavior? textHeightBehavior;
  final CommonTextHeightBehavior? heightBehavior;

  const CommonText(
    this.data, {
    super.key,
    this.textStyle,
    this.align,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.textHeightBehavior,
    this.heightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: textStyle ?? Get.theme.textTheme.labelMedium,
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      textHeightBehavior: getRequiredHeightBehavior(),
    );
  }

  /// Returns the appropriate `TextHeightBehavior` based on the specified `CommonTextHeightBehavior`.
  TextHeightBehavior getRequiredHeightBehavior() {
    switch (heightBehavior) {
      case CommonTextHeightBehavior.singleLine:
        return const TextHeightBehavior(
            applyHeightToFirstAscent: false, applyHeightToLastDescent: false);

      case CommonTextHeightBehavior.multiline:
        return const TextHeightBehavior(
          applyHeightToFirstAscent: false,
        );

      default:
        return textHeightBehavior ??
            const TextHeightBehavior(
              applyHeightToFirstAscent: false,
            );
    }
  }
}

enum CommonTextHeightBehavior { singleLine, multiline }
