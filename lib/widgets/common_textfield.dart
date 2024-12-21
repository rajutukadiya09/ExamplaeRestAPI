import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

// Custom text field widget with various customization options
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? inputTextStyle;
  final TextStyle? hintTextStyle;
  final double borderRadius;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int minLines;
  final double height;
  final double leftContentPadding;
  final double rightContentPadding;
  final double bottomContentPadding;
  final double topContentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isEnabled;
  final bool isReadOnly;
  final bool obscureText;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.inputTextStyle,
    this.hintTextStyle,
    this.borderRadius = 8.0,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1, // Default maxLines to 1, will be controlled dynamically
    this.minLines = 1,
    this.height = 48.03,
    this.leftContentPadding = 16.69,
    this.rightContentPadding = 0,
    this.bottomContentPadding = 0,
    this.topContentPadding = 0,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.isEnabled,
    this.isReadOnly = false,
    this.obscureText = false,  this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: maxLines == 1 ? height : null, // Height grows dynamically if multiline
      child: TextFormField(
        onTap: onTap,
        enabled: isEnabled,
        readOnly: isReadOnly,
        controller: controller,
        style: inputTextStyle,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : (maxLines > 4 ? 4 : maxLines), // Cap maxLines to 4
        minLines: minLines,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 50,
            minWidth: 30,
            maxWidth: 50,
            minHeight: 30,
          ),
          hintText: hintText,
          hintStyle: hintTextStyle,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.56,
              color: colorC7C7C7,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.56,
              color: grey600,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentPadding: EdgeInsets.only(
            left: leftContentPadding,
            right: rightContentPadding,
            bottom: bottomContentPadding,
            top: topContentPadding,
          ),
          filled: true,
          fillColor: colorF3F3F3,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// Formatter to handle the input formatting for expiry dates
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the length of the text before and after formatting
    final int originalTextLength = oldValue.text.length;
    final int newTextLength = newValue.text.length;

    // Initialize variables
    int selectionIndex = newValue.selection.end;
    String formattedText;

    // Handle empty input
    if (newTextLength == 0) {
      formattedText = '';
    } else if (newTextLength <= 4) {
      // Format year part (1 to 4 digits)
      formattedText = newValue.text;
    } else if (newTextLength == 5) {
      // Ensure correct position for '/'
      if (newValue.text.substring(4, 5) == '/') {
        formattedText = newValue.text.substring(0, 4);
        selectionIndex = 4;
      } else {
        // Format year and add '/' and month
        formattedText = '${newValue.text.substring(0, 4)}/';
        if (RegExp(r'^[2-9]$').hasMatch(newValue.text.substring(4, 5))) {
          formattedText += '0${newValue.text.substring(4, 5)}';
        } else {
          formattedText += newValue.text.substring(4, 5);
        }
        selectionIndex = 6; // Move cursor to after the month part
      }
    } else if (newTextLength <= 7) {
      // Format month part (2 digits)
      String monthPart = newValue.text.substring(5, 7);
      if (int.tryParse(monthPart) != null) {
        int month = int.parse(monthPart);
        if (month >= 1 && month <= 12) {
          formattedText = '${newValue.text.substring(0, 4)}/$monthPart';
          selectionIndex = 7; // Move cursor to end of text
        } else {
          formattedText =
              oldValue.text; // Revert to old value if month is invalid
          selectionIndex = oldValue.selection.end;
        }
      } else {
        formattedText =
            oldValue.text; // Revert to old value if month is invalid
        selectionIndex = oldValue.selection.end;
      }
    } else {
      // Limit to 'yyyy/MM'
      formattedText = newValue.text.substring(0, 7);
      selectionIndex = 7; // Ensure cursor stays at the end
    }

    // Handle backspace
    if (originalTextLength > newTextLength) {
      if (newTextLength == 5) {
        formattedText = formattedText.substring(0, 4);
        selectionIndex = 4;
      } else if (newTextLength == 4 && formattedText.contains('/')) {
        formattedText = formattedText.substring(0, 3);
        selectionIndex = 3;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

// Formatter for credit card numbers with space separation every 4 digits
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove existing spaces from input text
    var inputText = newValue.text.replaceAll(' ', '');

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      // Add space after every 4 characters
      if ((i + 1) % 4 == 0 && (i + 1) != inputText.length) {
        bufferString.write(' ');
      }
    }

    var formattedText = bufferString.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Custom password field with visibility toggle
class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextStyle? inputTextStyle;
  final double borderRadius;
  final String? hintText;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.inputTextStyle,
    this.borderRadius = 8.0,
    this.hintText = '',
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  RxBool obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 48.03,
      child: Obx(() {
        return TextFormField(
          controller: widget.controller,
          style: widget.inputTextStyle,
          obscureText: obscureText.value,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1.56,
                color: grey50,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1.56,
                color: colorC7C7C7,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            contentPadding: const EdgeInsets.only(left: 16.69),
            filled: true,
            hintText: widget.hintText,
            fillColor: colorF3F3F3,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide.none,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                // Toggle password visibility
                obscureText.value = !obscureText.value;
              },
              child: Icon(
                size: 20,
                obscureText.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: black,
              ),
            ),
          ),
          obscuringCharacter: '*',
        );
      }),
    );
  }
}
