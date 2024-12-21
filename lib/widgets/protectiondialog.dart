import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nimodrive/network/model/dashboard_data_model.dart';

import '../ui/dashboard/dashboard_controller.dart';
import '../utils/app_colors.dart';

class PasswordConfirmDialog extends StatefulWidget {
  final DashboardDataModelRes? itemdata; // Declare the name parameter
  PasswordConfirmDialog(this.itemdata);

  @override
  _PasswordConfirmDialogState createState() => _PasswordConfirmDialogState();
}

class _PasswordConfirmDialogState extends State<PasswordConfirmDialog> {
  final DashboardController controller = Get.put(DashboardController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String errorMessage = '';

  void _validatePasswords() {
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    if (widget.itemdata?.password?.isEmpty == true) {
      if (password.isEmpty || confirmPassword.isEmpty) {
        setState(() {
          errorMessage = "Both fields are required.";
        });
      } else if (password != confirmPassword) {
        setState(() {
          errorMessage = "Passwords do not match.";
        });
      } else {
        setState(() {
          errorMessage = '';
        });
        //  // Close the dialog
        /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password Confirmed: $password')),
      );*/

        controller.getProtectionApiCall(
            widget.itemdata, password, context, controller);
      }
    } else {
      if (password.isEmpty) {
        setState(() {
          errorMessage = "Password field are required.";
        });
      } else {
        setState(() {
          errorMessage = '';
        });
        controller.getProtectionApiCall(
            widget.itemdata, password, context, controller);
      }
    }
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: widget.itemdata?.password != null &&
                      widget.itemdata!.password!.isEmpty
                  ? const Text(
                      'Enter Password to Lock Folder',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Enter Password to Unlock Folder',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),
            // Password input field (full-width)
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  errorText: errorMessage.isNotEmpty ? errorMessage : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Password input field (full-width)
            widget.itemdata?.password != null &&
                    widget.itemdata!.password!.isEmpty
                ? SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        errorText:
                            errorMessage.isNotEmpty ? errorMessage : null,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            Row(
              children: [
                // First button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _validatePasswords,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blue59a9ff, foregroundColor: white),
                    child: widget.itemdata?.password != null &&
                            widget.itemdata!.password!.isEmpty
                        ? const Text('Lock')
                        : const Text('UnLock'),
                  ),
                ),
                // Add a small gap between the buttons if needed
                const SizedBox(width: 10), // Adjust width as needed
                // Second button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _dismissDialog,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: gray6c757d, foregroundColor: white),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            )
            // Confirm button
            ,
          ],
        ),
      ),
    );
  }
}
