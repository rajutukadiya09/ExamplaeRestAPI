import 'package:flutter/material.dart';


import '../utils/app_colors.dart';
import 'common_text_label.dart';
import 'components/spacings.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.enabledColor =appBlue,
    this.onTap,
    this.label,
    this.disabledColor = appBlue,
    this.padding = 24 / 2,
    this.leading,
    this.trailing,
    this.textStyles,
    this.width,
    this.borderRadius,
  });

  final Color? enabledColor; // Color when button is enabled
  final Color? disabledColor; // Color when button is disabled
  final VoidCallback? onTap; // Function to execute on button press
  final String? label; // Button label
  final double? padding; // Padding inside the button
  final Widget? leading; // Widget to display before the label (optional)
  final Widget? trailing; // Widget to display after the label (optional)
  final TextStyle? textStyles; // Custom text styles for the button label
  final double? width; // Button width
  final double? borderRadius; // Border radius for the button

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Default to full width if not specified
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(padding!), // Apply custom padding
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.disabled)
                    ? disabledColor! // Use disabled color if button is disabled
                    : enabledColor!, // Use enabled color otherwise
          ),
          overlayColor: MaterialStateColor.resolveWith(
            (Set<MaterialState> states) =>
                Colors.white.withOpacity(0.4), // Ripple effect on tap
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              // Default to 8 if no radius specified
              side: BorderSide.none, // No border by default
            ),
          ),
        ),
        onPressed: onTap == null ? null : () => onTap!(),
        // Disable button if onTap is null
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // Center the button content
          children: <Widget>[
            leading ?? const Offstage(),
            // Display leading widget or hide if null
            Text(
              label!, // Display button label
              style: textStyles ??
                  button(), // Apply custom styles or default button style
            ),
            trailing ?? const Offstage(),
            // Display trailing widget or hide if null
          ],
        ),
      ),
    );
  }

  // Default button text style if none is provided
  static TextStyle button({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double size = 14,
  }) =>
      TextStyle(
        color: color ?? white, // Default text color is white
        fontSize: size,
        fontWeight: fontWeight,
      );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.color = appBlue,
    this.labelColor = appBlue,
    this.onTap,
    this.label,
    this.leading, this.width,
  });

  final Color? color;
  final Color? labelColor;
  final VoidCallback? onTap;
  final String? label;
  final Widget? leading;
  final double? width; // Button width

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Default to full width if not specified
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(Spacings.large / 2),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(appBlue),
          overlayColor: MaterialStateColor.resolveWith(
                (Set<MaterialState> states) => appBlue.withOpacity(0.2),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: appBlue),
            ),
          ),
        ),
        onPressed: () => onTap!(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading ?? const Offstage(),
            CommonText(
              label!,
              textStyle: TextStyle(
                color: labelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
