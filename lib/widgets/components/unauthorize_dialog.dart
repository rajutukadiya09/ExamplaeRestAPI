import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nimodrive/widgets/components/spacings.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../common_button.dart';
import '../common_text_label.dart';

/// A dialog that shows when a user is unauthorized or logged out due to invalid token/session
class UnAuthorizeDialog extends StatelessWidget {
  const UnAuthorizeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Spacings.custom20, // Custom spacing for rounded corners
        ),
      ),
      content: const CommonText(
        msgUnauthorizedAccess,
        // Text to display the unauthorized access message
        maxLines: 4, // Limit the message to 4 lines
      ),
      actions: <Widget>[
        PrimaryButton(
          onTap: () async {
            Get.back(); // Close the dialog
            Get.offAllNamed(routeSignIn); // Navigate to sign-in screen
          },
          label: 'Ok',
          // Button label
          padding: Spacings.custom12,
          // Padding for the button
          textStyles: const TextStyle(
            fontWeight: FontWeight.w600,
            color: white, // White text color for the button label
          ),
          enabledColor: appBlue, // Blue color for the enabled button
        ),
      ],
    );
  }
}
