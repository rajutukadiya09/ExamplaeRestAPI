import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';

import '../../network/model/tow_drivers_model.dart';
import '../../network/model/tow_service_method_model.dart';
import '../../network/model/tow_vehicles_model.dart';
import '../../network/model/towing_account_model.dart';
import '../../network/model/towing_type_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../utils/folder_utils.dart';
import '../../utils/utility.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_designed_container.dart';
import '../../widgets/common_text_label.dart';
import '../../widgets/common_textfield.dart';
import '../../widgets/components/loading.dart';
import 'inv_controller.dart';
/*

class InvScreen extends StatefulWidget {
  const InvScreen({super.key});

  @override
  State<InvScreen> createState() => _InvScreenState();
}

class _InvScreenState extends State<InvScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final InvController controller = Get.put(InvController());
  final TextEditingController textEditingController = TextEditingController();

  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    controller.selectedIndex = 0;
    controller.tabController = TabController(length: 5, vsync: this);
    AppPref().clearStoredAttachmentIds();
    controller.tabController.index = 0;
    controller.savedSignature.value = '';
    controller.getTowAccountsApiCall();
    controller.getTowingTypesApiCall();
    controller.getTowDriversApiCall();
    controller.getTowVehiclesApiCall();
    controller.getTowVehicleClassApiCall();
    controller.getTowFacilitiesApiCall();
    controller.getTowMethodApiCall();
    controller.getTowServicesApiCall();
    controller.getTowingServerAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: appBlue,
        elevation: 0,
        toolbarHeight: 44,
        // Adjust height if needed
        title: CommonText(
          "New Dispatch",
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    showPopover(
                        context: context,
                        bodyBuilder: (context) =>  Wrap(
                          children: List.generate(controller.towServerAction.value.length, (index) {
                            return ListTile(
                              title: CommonText(controller.towServerAction.value[index].name??''),
                            );
                          },),
                        ),
                        onPop: () => print('Popover was popped!'),
                        direction: PopoverDirection.bottom,
                        width: 200,
                        arrowHeight: 0,
                        arrowWidth: 0
                    );

                  },
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              }
          )
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(left: 8.0, right: 8.0,bottom: Platform.isAndroid?0:30),
        child: PrimaryButton(
          label: 'Submit',
          onTap: () async {
            if (controller.licensePlateCtn.value.text.isNotEmpty &&
                controller.modelCtn.value.text.isNotEmpty &&
                controller.makeCtn.value.text.isNotEmpty &&
                controller.vinCtn.value.text.isNotEmpty &&
                controller.yearCtn.value.text.isNotEmpty) {
              controller.uploadImagesAndCreateRecord();
            } else {
              showCenterFlash(
                message: "All field are mandatory",
                color: red,
                context: Get.context!,
              );
            }
          },
        ),
      ),
      body: Obx(() {
        Widget bodyContent;
        switch (controller.viewState.value) {
          case ViewState.loading:
            bodyContent = Stack(
              children: <Widget>[
                getBodyWidget(context: context),
                ProgressBar(
                  isCard: true,
                ),
              ],
            );
          case ViewState.uploadImgLoading:
            bodyContent = Stack(
              children: <Widget>[
                getBodyWidget(context: context),
                ProgressBar(
                  message: 'Uploading images...',
                  backgroundColor: Colors.transparent,
                  isCard: false,
                ),
              ],
            );
            break;
          case ViewState.error:
          case ViewState.success:
          default:
            bodyContent = getBodyWidget(context: context);
            break;
        }
        return bodyContent;
      }),
    );
  }

  Widget getBodyWidget({required BuildContext context}) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: appBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          // Height of the dropdown menu
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color
                            borderRadius: BorderRadius.circular(10),
                            // Rounded corners
                            border: Border.all(
                              width: 1.56, // Border width
                              color: appBlue, // Border color
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<TowAccountFetchModel>(
                              isExpanded: true,
                              hint: Text(
                                'Select Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: controller.towAccounts.value
                                  .map((TowAccountFetchModel account) {
                                return DropdownMenuItem<
                                    TowAccountFetchModel>(
                                  value: account,
                                  child: Text(
                                    account.name ?? '',
                                    // Display account name
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: controller.selectedTowAccount,
                              onChanged: (TowAccountFetchModel? newValue) {
                                setState(() {
                                  controller.selectedTowAccount =
                                      newValue; // Update selected account
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                height: 40,
                                width: Get.width,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: textEditingController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Search for an account...',
                                      hintStyle:
                                          const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  // Check if the item name contains the search string
                                  var name = item.value?.name ?? '';
                                  return name
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                              // Clear the search value when the menu is closed
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textEditingController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Replace TowingTypesDropDownMenu with DropdownButton2
                        Container(
                          height: 50, // Height of the dropdown menu
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color
                            borderRadius: BorderRadius.circular(10),
                            // Rounded corners
                            border: Border.all(
                              width: 1.56, // Border width
                              color: appBlue, // Border color
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<TowingTypeModel>(
                              isExpanded: true,
                              hint: Text(
                                'Select Towing Type',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: controller.towingTypes.value
                                  .map((TowingTypeModel type) {
                                return DropdownMenuItem<TowingTypeModel>(
                                  value: type,
                                  child: Text(
                                    type.name ?? '',
                                    // Display towing type name
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: controller.selectedTowingType,
                              onChanged: (TowingTypeModel? newValue) {
                                setState(() {
                                  controller.selectedTowingType =
                                      newValue; // Update selected towing type
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                height: 40,
                                width: Get.width,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownSearchData: DropdownSearchData(
                                searchController: textEditingController,
                                searchInnerWidgetHeight: 50,
                                searchInnerWidget: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 4,
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: TextFormField(
                                    expands: true,
                                    maxLines: null,
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      hintText: 'Search for towing type...',
                                      hintStyle:
                                          const TextStyle(fontSize: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                searchMatchFn: (item, searchValue) {
                                  var name = item.value?.name ?? '';
                                  return name
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase());
                                },
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textEditingController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                            maxLines: 4,
                            height: 40,
                            hintText: 'Dispatch Instruction',
                            hintTextStyle:
                                const TextStyle(color: Colors.grey),
                            controller:
                                controller.dispatchInstPlateCtn.value),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    const CommonText(
                      'Photos',
                      textStyle: TextStyle(
                          color: color001928,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    GetBuilder<InvController>(
                        id: invPhotos,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                border: Border.all(color: color6A6A6A10),
                                color: Colors.transparent,
                                shape: BoxShape.circle),
                            child: CommonText(controller
                                .profileAttachments.value.length
                                .toString()),
                          );
                        })
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 86,
                  child: GetBuilder<InvController>(
                      id: invPhotos,
                      builder: (context) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.profileAttachments.value.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  controller.callPickFiles(context: context);
                                },
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: color2E73E2, width: 2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(imgUploadImage),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Upload',
                                        style: TextStyle(color: color2E73E2),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final attachment =
                                controller.profileAttachments.value[index - 1];
                            bool isSelected =
                                controller.selectedIndex == index - 1;

                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.selectedIndex == index - 1) {
                                      controller.selectedIndex = null;
                                    } else {
                                      controller.selectedIndex = index - 1;
                                    }
                                    controller.update([invPhotos]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Stack(
                                        children: [
                                          Image.file(
                                            attachment.file,
                                            width: 86,
                                            height: 86,
                                            fit: BoxFit.cover,
                                          ),
                                          if (isSelected)
                                            Container(
                                              width: 86,
                                              height: 86,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: color2E73E2,
                                                    width: 2),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  // Remove the image from the list
                                                  controller.profileAttachments
                                                      .update((attachments) {
                                                    attachments
                                                        ?.removeAt(index - 1);
                                                  });

                                                  // Adjust the selectedIndex after removal
                                                  if (controller
                                                      .profileAttachments
                                                      .value
                                                      .isEmpty) {
                                                    controller.selectedIndex =
                                                        null;
                                                  } else if (controller
                                                              .selectedIndex !=
                                                          null &&
                                                      controller
                                                              .selectedIndex! >=
                                                          controller
                                                              .profileAttachments
                                                              .value
                                                              .length) {
                                                    // If selectedIndex is out of bounds after deletion
                                                    controller.selectedIndex =
                                                        controller
                                                                .profileAttachments
                                                                .value
                                                                .length -
                                                            1;
                                                  }

                                                  controller.update([
                                                    invPhotos
                                                  ]); // Refresh UI/ Refresh UI
                                                },
                                                icon: const Icon(
                                                    CupertinoIcons.delete,
                                                    color: Colors.white),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.tabs.length, (index) {
                      bool isSelected = controller.selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          controller.setState(ViewState.loading);
                          controller.selectedIndex = index;
                          controller.selectedIndex = index;
                          controller.setState(ViewState.success);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appBlue.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(3.18),
                            border: Border.all(
                              color: isSelected ? appBlue : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            controller.tabs[index],
                            style: TextStyle(
                              fontSize: isSelected ? 18 : 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? Colors.black54 : Colors.black26,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                IndexedStack(
                  index: controller.selectedIndex,
                  clipBehavior: Clip.antiAlias,
                  children: <Widget>[
                    Visibility(
                      visible: controller.selectedIndex == 0,
                      maintainState: true,
                      child: vehicleTab(),
                    ),
                    Visibility(
                      visible: controller.selectedIndex == 1,
                      maintainState: true,
                      child: authTab(context),
                    ),
                    Visibility(
                      visible: controller.selectedIndex == 2,
                      maintainState: true,
                      child: towTab(),
                    ),
                    Visibility(
                      visible: controller.selectedIndex == 3,
                      maintainState: true,
                      child: const CommonText('Release'),
                    ),
                    Visibility(
                      visible: controller.selectedIndex == 4,
                      maintainState: true,
                      child: const CommonText('Impound'),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     CustomContainer(
                //       width: Get.width / 2.3,
                //       imageString: imgFiles,
                //       text: 'Rules',
                //     ),
                //     CustomContainer(
                //       width: Get.width / 2.3,
                //       imageString: imgDoNotTow,
                //       text: 'Do not tow',
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 21),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Material towTab() {
    return Material(
      elevation: 6, // Add elevation for the shadow effect
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText("Driver*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowDriversModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Tow Driver',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.towDrivers.value
                      .map((TowDriversModel towDriver) {
                    return DropdownMenuItem<TowDriversModel>(
                      value: towDriver,
                      child: Text(
                        towDriver.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedTowDriver,
                  onChanged: (TowDriversModel? newValue) {
                    setState(() {
                      controller.selectedTowDriver =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an Driver...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      // Check if the item name contains the search string
                      var name = item.value?.name ?? '';
                      return name
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Vehicle*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowVehiclesModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Vehicle',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.towVehicles.value
                      .map((TowVehiclesModel towVehicle) {
                    return DropdownMenuItem<TowVehiclesModel>(
                      value: towVehicle,
                      child: Text(
                        towVehicle.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedTowVehicle,
                  onChanged: (TowVehiclesModel? newValue) {
                    setState(() {
                      controller.selectedTowVehicle =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an Vehicle...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      // Check if the item name contains the search string
                      var name = item.value?.name ?? '';
                      return name
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Vehicle Class*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowVehicleClassModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Vehicle Class',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.towVehiclesClass.value
                      .map((TowVehicleClassModel towVehicleClass) {
                    return DropdownMenuItem<TowVehicleClassModel>(
                      value: towVehicleClass,
                      child: Text(
                        towVehicleClass.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedTowVehicleClass,
                  onChanged: (TowVehicleClassModel? newValue) {
                    setState(() {
                      controller.selectedTowVehicleClass =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Towing Services*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowServicesModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Tow Services',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.towServices.value
                      .map((TowServicesModel towServices) {
                    return DropdownMenuItem<TowServicesModel>(
                      value: towServices,
                      child: Text(
                        towServices.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedTowServices,
                  onChanged: (TowServicesModel? newValue) {
                    setState(() {
                      controller.selectedTowServices =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an Services...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      // Check if the item name contains the search string
                      var name = item.value?.name ?? '';
                      return name
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Tow Methods*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowMethodModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Tow Method',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.fetchTowMethod.value
                      .map((TowMethodModel fetchTowMethod) {
                    return DropdownMenuItem<TowMethodModel>(
                      value: fetchTowMethod,
                      child: Text(
                        fetchTowMethod.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedTowMethod,
                  onChanged: (TowMethodModel? newValue) {
                    setState(() {
                      controller.selectedTowMethod =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Facilities*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              // Height of the dropdown menu
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                // Background color
                borderRadius: BorderRadius.circular(10),
                // Rounded corners
                border: Border.all(
                  width: 1.56, // Border width
                  color: appBlue, // Border color
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<TowFacilitiesFetchModel>(
                  isExpanded: true,
                  hint: Text(
                    'Select Facilities',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: controller.fetchFacilities.value
                      .map((TowFacilitiesFetchModel fetchFacilities) {
                    return DropdownMenuItem<TowFacilitiesFetchModel>(
                      value: fetchFacilities,
                      child: Text(
                        fetchFacilities.name ?? '', // Display account name
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  value: controller.selectedFacilities,
                  onChanged: (TowFacilitiesFetchModel? newValue) {
                    setState(() {
                      controller.selectedFacilities =
                          newValue; // Update selected account
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: Get.width,
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    maxHeight: 200,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an Facilities...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      // Check if the item name contains the search string
                      var name = item.value?.name ?? '';
                      return name
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  // Clear the search value when the menu is closed
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Entered Vehicle*"),
            const SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => ListTile(
                        title: const Text('Yes'),
                        leading: Radio<String>(
                          value: 'Yes',
                          groupValue:
                              controller.selectedValueForEnteredVehicle.value,
                          onChanged: (String? value) {
                            controller.selectedValueForEnteredVehicle.value =
                                value!;
                            debugPrint(
                                "selected Value For EnteredVehicle::- ${controller.selectedValueForEnteredVehicle.value}");
                          },
                        ),
                      )),
                  Obx(() => ListTile(
                        title: const Text('No'),
                        leading: Radio<String>(
                          value: 'No',
                          groupValue:
                              controller.selectedValueForEnteredVehicle.value,
                          onChanged: (String? value) {
                            controller.selectedValueForEnteredVehicle.value =
                                value!;
                            debugPrint(
                                "selected Value For EnteredVehicle::- ${controller.selectedValueForEnteredVehicle.value}");
                          },
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Vehicle Locked*"),
            const SizedBox(height: 3),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => ListTile(
                        title: const Text('Yes'),
                        leading: Radio<String>(
                          value: 'Yes',
                          groupValue:
                              controller.selectedValueForVehicleLocked.value,
                          onChanged: (String? value) {
                            controller.selectedValueForVehicleLocked.value =
                                value!;
                            debugPrint(
                                "selected Value For EnteredVehicle::- ${controller.selectedValueForVehicleLocked.value}");
                          },
                        ),
                      )
                  ),
                  Obx(() => ListTile(
                        title: const Text('No'),
                        leading: Radio<String>(
                          value: 'No',
                          groupValue:
                              controller.selectedValueForVehicleLocked.value,
                          onChanged: (String? value) {
                            controller.selectedValueForVehicleLocked.value =
                                value!;
                            debugPrint(
                                "selected Value For EnteredVehicle::- ${controller.selectedValueForVehicleLocked.value}");
                          },
                        ),
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const CommonText("Lockout Method*"),
            const SizedBox(height: 3),
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1.56,
                  color:
                      Colors.blue, // Replace with appBlue if defined elsewhere
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() {
                  return DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Method',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: controller.lockOutMethods.value.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(
                          method, // Display method name
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    value: controller.selectedLockOutMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.selectedLockOutMethod =
                            newValue; // Update selected method
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    // Optional: Clear the search value when the menu is closed
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Material authTab(BuildContext context) {
    return Material(
      elevation: 6, // Add elevation for the shadow effect
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText("Authorizing Signature*"),
            const SizedBox(height: 3),
            Obx(() {
              return InkWell(
                onTap: () {
                  if (controller.assetAttachment.value == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 3,
                          title: const Text("Draw signature"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: HandSignature(
                                  type: SignatureDrawType.arc,
                                  color: Colors.red,
                                  control: controller.signatureControl,
                                ),
                              ),
                              PrimaryButton(
                                label: 'Browse file',
                                width: 105,
                                onTap: () async {
                                  controller.signatureControl.clear();
                                  await controller.saveSignature();
                                  controller
                                      .callPickSignature(context: context)
                                      .then(
                                    (value) {
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                controller.signatureControl.clear();
                                await controller.saveSignature();
                              },
                              child: const Text("Restore Signature"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await controller.saveSignature();
                                Get.back();
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  constraints:
                      const BoxConstraints(minHeight: 50, maxHeight: 120),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: controller.assetAttachment.value != null
                      ? Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(controller.assetAttachmentName.value),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      // Clear file and reset name
                                      controller.assetAttachment.value = null;
                                      controller.assetAttachmentName.value = '';
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : controller.savedSignature.value.isNotEmpty
                          ? Image.file(
                              File(controller.savedSignature.value),
                              fit: BoxFit.contain,
                            )
                          : const CommonText(
                              "Signature",
                              textStyle: TextStyle(fontSize: 20),
                            ),
                ),
              );
            }),
            const SizedBox(height: 10),
            const CommonText("Authorizing Time"),
            const SizedBox(height: 3),
            Obx(() {
              return CustomTextField(
                onTap: () async {
                  DateTime? selectedDate;
                  await showCupertinoModalPopup<DateTime>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: white,
                        height: 300,
                        child: CupertinoDatePicker(
                          showDayOfWeek: true,
                          maximumYear: DateTime.now().year,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newDate) {
                            selectedDate = newDate;

                            if (selectedDate != null) {
                              String formattedDate = DateFormat('dd/MM/yyyy')
                                  .format(selectedDate!);
                              controller.authorizingTime.value = formattedDate;
                              controller.authorizingTimeCtn.value.text =
                                  formattedDate;
                            }
                          },
                        ),
                      );
                    },
                  );
                },
                isReadOnly: true,
                height: 40,
                controller: controller.authorizingTimeCtn.value,
              );
            }),
            const SizedBox(height: 10),
            const CommonText("Signer Title*"),
            const SizedBox(height: 3),
            CustomTextField(
              height: 40,
              controller: controller.signerTitleCtn.value,
            ),
            const SizedBox(height: 10),
            const CommonText("Signer Number*"),
            const SizedBox(height: 3),
            CustomTextField(
              height: 40,
              controller: controller.signerNumberCtn.value,
            ),
            const SizedBox(height: 10),
            const CommonText("Signer Address*"),
            const SizedBox(height: 3),
            CustomTextField(
              height: 40,
              controller: controller.signerAddressCtn.value,
            ),
            const SizedBox(height: 10),
            const CommonText("Authorizing Documents"),
            const SizedBox(height: 3),
            Obx(() {
              if (controller.authDocFiles.value.isEmpty) {
                return SecondaryButton(
                  leading: const Icon(Icons.attach_file),
                  label: 'AUTHORIZING DOCUMENTS',
                  // width: 250,
                  onTap: () async {
                    bool result = await InvController.pickFiles(
                      context: context,
                      assetAttachment: controller.authDocFiles,
                      assetAttachmentName: controller.authDocName,
                      viewState: controller.viewState,
                    );

                    if (result) {
                      // File selected, state is automatically managed by Obx
                    }
                  },
                );
              } else {
                // Show file name and remove icon if file is selected
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.authDocFiles.value.length,
                  itemBuilder: (context, index) {
                    final file = controller.authDocFiles.value[index];
                    return Row(
                      key: ValueKey(file),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insert_drive_file,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Text(FolderUtils.getFileName(file.path)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            controller.authDocFiles.value.removeAt(index);
                            controller.authDocFiles.refresh();
                            controller.viewState.value = ViewState.initial;
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            })
          ],
        ),
      ),
    );
  }

  Material vehicleTab() {
    return Material(
      elevation: 6, // Add elevation for the shadow effect
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText("License Plate*"),
            const SizedBox(height: 3),
            CustomTextField(
                height: 40, controller: controller.licensePlateCtn.value),
            const SizedBox(height: 10),
            const CommonText("Model*"),
            const SizedBox(height: 3),
            CustomTextField(height: 40, controller: controller.modelCtn.value),
            const SizedBox(height: 10),
            const CommonText("Make*"),
            const SizedBox(height: 3),
            CustomTextField(height: 40, controller: controller.makeCtn.value),
            const SizedBox(height: 10),
            const CommonText("VIN*"),
            const SizedBox(height: 3),
            CustomTextField(height: 40, controller: controller.vinCtn.value),
            const SizedBox(height: 10),
            const CommonText("Year*"),
            const SizedBox(height: 3),
            CustomTextField(height: 40, controller: controller.yearCtn.value),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
*/
