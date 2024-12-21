import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../network/model/towing_account_model.dart';
import '../network/model/towing_type_model.dart';
import '../utils/app_colors.dart';
import 'common_text_label.dart';

/// A custom dropdown menu widget for selecting `TowAccountFetchModel` items.
class CustomDropDownMenu extends StatelessWidget {
  /// Creates an instance of [CustomDropDownMenu].
  const CustomDropDownMenu({
    super.key,
    required this.list, // List of items to display in the dropdown menu
    required this.onSelectionChange, // Callback when an item is selected
    this.color = red, // Color for the dropdown icon
    this.spinnerSelection, // Currently selected item (if any)
    this.borderColor = Colors.transparent, // Border color for the dropdown menu
    this.bgColor = Colors.white, // Background color for the dropdown menu
  });

  final List<TowAccountFetchModel> list; // List of items for the dropdown
  final TowAccountFetchModel? spinnerSelection; // Selected item
  final Function(TowAccountFetchModel? model)
      onSelectionChange; // Callback for item selection
  final Color color; // Color of the dropdown icon
  final Color borderColor; // Border color
  final Color bgColor; // Background color

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: white, // Background color of the dropdown menu
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        // Dismiss the keyboard when tapping
        child: Container(
          height: 50,
          // Height of the dropdown menu
          alignment: Alignment.center,
          // Center align content
          padding: const EdgeInsets.symmetric(
            horizontal: 15, // Horizontal padding inside the dropdown menu
          ),
          decoration: BoxDecoration(
            color: bgColor, // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
            border: Border.all(
              width: 1.56, // Border width
              color: borderColor, // Border color
            ),
          ),
          child: DropdownButton<TowAccountFetchModel>(
            isDense: true,
            // Reduce the vertical space
            underline: Container(
              height: 0, // No underline
              color: grey50, // Underline color
            ),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.black),
            // Text style for the dropdown
            isExpanded: true,
            // Expand the dropdown to fit the width
            icon: Icon(
              Icons.keyboard_arrow_down, // Icon for dropdown arrow
              color: color, // Icon color
            ),
            onChanged: (TowAccountFetchModel? model) {
              onSelectionChange(model); // Trigger callback on item selection
            },
            hint: Wrap(
              children: <Widget>[
                CommonText(
                  spinnerSelection?.name ?? 'Select Account',
                  // Display selected item name or empty string
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400, // Font weight
                    fontSize: 14.6, // Font size
                    color: black, // Font color
                  ),
                ),
              ],
            ),
            menuMaxHeight: Get.height * 0.7,
            // Max height of the dropdown menu
            borderRadius: BorderRadius.circular(8),
            // Border radius for the dropdown menu
            items: list.map((TowAccountFetchModel model) {
              return DropdownMenuItem<TowAccountFetchModel>(
                value: model, // Item value
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 30, // Height of each item
                      child: CommonText(
                        model.name ?? '', // Display item name
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400), // Item text style
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// A custom dropdown menu widget for selecting `TowingTypeModel` items.
class TowingTypesDropDownMenu extends StatelessWidget {
  /// Creates an instance of [TowingTypesDropDownMenu].
  const TowingTypesDropDownMenu({
    super.key,
    required this.list, // List of items to display in the dropdown menu
    required this.onSelectionChange, // Callback when an item is selected
    this.color = red, // Color for the dropdown icon
    this.spinnerSelection, // Currently selected item (if any)
    this.borderColor = Colors.transparent, // Border color for the dropdown menu
    this.bgColor = Colors.white, // Background color for the dropdown menu
  });

  final List<TowingTypeModel> list; // List of items for the dropdown
  final TowingTypeModel? spinnerSelection; // Selected item
  final Function(TowingTypeModel? model)
      onSelectionChange; // Callback for item selection
  final Color color; // Color of the dropdown icon
  final Color borderColor; // Border color
  final Color bgColor; // Background color

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: white, // Background color of the dropdown menu
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        // Dismiss the keyboard when tapping
        child: Container(
          height: 50,
          // Height of the dropdown menu
          alignment: Alignment.center,
          // Center align content
          padding: const EdgeInsets.symmetric(
            horizontal: 15, // Horizontal padding inside the dropdown menu
          ),
          decoration: BoxDecoration(
            color: bgColor, // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
            border: Border.all(
              width: 1.56, // Border width
              color: borderColor, // Border color
            ),
          ),
          child: DropdownButton<TowingTypeModel>(
            isDense: true,
            // Reduce the vertical space
            underline: Container(
              height: 0, // No underline
              color: grey50, // Underline color
            ),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.black),
            // Text style for the dropdown
            isExpanded: true,
            // Expand the dropdown to fit the width
            icon: Icon(
              Icons.keyboard_arrow_down, // Icon for dropdown arrow
              color: color, // Icon color
            ),
            onChanged: (TowingTypeModel? model) {
              onSelectionChange(model); // Trigger callback on item selection
            },
            hint: Wrap(
              children: <Widget>[
                CommonText(
                  spinnerSelection?.name ?? 'Select Tag',
                  // Display selected item name or empty string
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400, // Font weight
                    fontSize: 14.6, // Font size
                    color: black, // Font color
                  ),
                ),
              ],
            ),
            menuMaxHeight: Get.height * 0.7,
            // Max height of the dropdown menu
            borderRadius: BorderRadius.circular(8),
            // Border radius for the dropdown menu
            items: list.map((TowingTypeModel model) {
              return DropdownMenuItem<TowingTypeModel>(
                value: model, // Item value
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 30, // Height of each item
                      child: CommonText(
                        model.name ?? '', // Display item name
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400), // Item text style
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
