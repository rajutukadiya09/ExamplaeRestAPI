import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nimodrive/network/model/dashboard_data_model.dart';

import '../../routes/routes.dart';

import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
import '../../widgets/common_text_label.dart';
import '../../widgets/components/loading.dart';
import '../../widgets/protectiondialog.dart';
import '../settings/Settings_Screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController controller = Get.put(DashboardController());
  var isLoading = false.obs;
  var ispath = "";
  bool isGridView = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Change status bar color to your desired color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBlue, // Set the status bar color
      statusBarIconBrightness: Brightness.light, // Set icons to light mode
    ));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.getDashboardApiCall();
    });
   // controller.items.add("/Drive");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("-------------");
      SettingsScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Routes.goBack(); // Replace with your navigation logic
        print(Routes.getCurrentPath());
        controller.getDashboardApiCall();

        return false; // Prevent default back behavior
      },
      child: Scaffold(
          backgroundColor: gray,
          body: Stack(
            children: [
              Obx(() {
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
              case ViewState.loadingDashboardData:
                bodyContent = Stack(
                  children: <Widget>[
                    getBodyWidget(context: context),
                    ProgressBar(
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
          // Add the BottomNavigationBar here


        ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getBodyWidget({required BuildContext context}) {
    return Scaffold(
        body: _selectedIndex == 0
            ? RefreshIndicator(
                onRefresh: () async {
                  await controller.getDashboardApiCall();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      pinned: false,
                      toolbarHeight: 170,
                      // Adjust height if needed
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 80,
                                  ),
                                  const CommonText(
                                    "Dashboard",
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Notification bell logic
                                        },
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isGridView = true;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.grid_view_rounded,
                                                      size: 30,
                                                      color: Colors.black,
                                                    )),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isGridView = false;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.list_sharp,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 10),
                                        // Add margin to the left
                                        child: Image.asset(
                                          imgClude,
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                     /* Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4),
                                          child:controller.items.length>0? DropdownButton(
                                            value:controller. dropdownvalue?? 'Drive',
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: controller.items
                                                .where((item) => item != null) // Filter out null items
                                                .map((String item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                controller.dropdownvalue = newValue!;
                                              });
                                            },
                                          ):SizedBox()
                                        *//*CommonText(
                                          "Drive: C",
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        )
                                      )*//*)*/
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: controller.items.isNotEmpty
                                            ? DropdownButton(
                                          value: controller.items.contains(controller.dropdownvalue)
                                              ? controller.dropdownvalue
                                              : controller.items[0], // Provide fallback value if dropdownvalue is not found
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: controller.items
                                              .where((item) => item != null) // Filter out null items
                                              .map((String item) {
                                            return DropdownMenuItem(
                                              value: item,
                                              child: Text(item),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              controller.dropdownvalue = newValue!;
                                              Routes.setCurrentSelectedPath( controller.dropdownvalue);
                                            });
                                          },
                                        )
                                            : SizedBox(),
                                      )

                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Notification bell logic
                                        },
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {},
                                                    child: CommonText(
                                                      controller.dashboradModelResroot
                                                                  .usedPercent !=
                                                              null
                                                          ? controller
                                                              .dashboradModelResroot
                                                              .usedPercent
                                                              .toString()
                                                          : "0%",
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                      ),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 15, bottom: 15),
                                        child: CommonText(
                                          "${controller.dashboradModelResroot.usedInGB} GB of ${controller.dashboradModelResroot.freeInGB} GB Used",
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Stack(
                                  children: [
                                    // Progress bar
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        // Adjust the value for desired roundness
                                        color: Colors.grey[
                                            300], // Background color for the progress bar
                                      ),
                                      child: LinearProgressIndicator(
                                        value: (controller.dashboradModelResroot
                                                        .usedGB +
                                                    controller
                                                        .dashboradModelResroot
                                                        .freeGB) >
                                                0
                                            ? controller.dashboradModelResroot
                                                    .usedGB /
                                                (controller
                                                        .dashboradModelResroot
                                                        .usedGB +
                                                    controller
                                                        .dashboradModelResroot
                                                        .freeGB)
                                            : 0.0,
                                        // Set default value if denominator is 0
                                        backgroundColor: Colors.transparent,
                                        color: Colors.green,
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Stack(
                                  children: [
                                    CommonText(
                                      "${Routes.getCurrentPath()}",
                                      // Wrap the result in single quotes
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]))
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 25, right: 25, bottom: 200),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.8, // Fill the screen height
                          child: isGridView
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  // Adjust the bottom margin as needed
                                  child: GridView.builder(
                                    itemCount: controller
                                        .dashboardDataModelRes.value.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          10, // Horizontal spacing
                                      mainAxisSpacing: 10, // Vertical spacing
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = controller
                                          .dashboardDataModelRes.value[index];
                                      return Card(
                                          elevation: 3,
                                          child: InkWell(
                                              onTap: () {
                                                print("Card clicked!");
                                                if (item.dir == true) {
                                                  if (item.password?.isEmpty ==
                                                      true) {
                                                    print(
                                                        "Card clicked ${item.path.toString()}");
                                                    Routes.navigateTo(
                                                        routeDashboard,
                                                        item.path.toString());
                                                  }
                                                } else {
                                                  print("Move Details screen");
                                                  print(
                                                      "-----------------------------");
                                                  Routes.navigateToStack(
                                                      routeDetailsScreen,
                                                      item.path.toString(),
                                                      item.name.toString());
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  // Content inside the card (Folder icon and name)
                                                  Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FileUtils.getStringFileType(
                                                                    item.dir,
                                                                    item.name
                                                                        .toString()) ==
                                                                "jpg"
                                                            ? FutureBuilder<
                                                                Uint8List>(
                                                                future: controller
                                                                    .fetchThumbnail(
                                                                        item.path),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            Uint8List>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    // Show a loading indicator while waiting for the image to load
                                                                    return const SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                    );
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    // Handle any errors
                                                                    return const SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child: Center(
                                                                          child:
                                                                              Text('Error loading image')),
                                                                    );
                                                                  } else if (snapshot
                                                                      .hasData) {
                                                                    // Display the image when the data is available
                                                                    return Image
                                                                        .memory(
                                                                      snapshot
                                                                          .data!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                    );
                                                                  } else {
                                                                    // Handle the case where no data is available
                                                                    return const SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          300,
                                                                      child: Center(
                                                                          child:
                                                                              Text('No image available')),
                                                                    );
                                                                  }
                                                                },
                                                              )
                                                            : SvgPicture.asset(
                                                                FileUtils.getStringFileType(
                                                                    item.dir,
                                                                    item.name
                                                                        .toString()),
                                                                width:
                                                                    80.0, // Size of the icon
                                                                height: 80.0,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Text(
                                                          item.name.toString(),
                                                          maxLines: 2,
                                                          // Allow up to 2 lines
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // Show "..." if the text overflows// Folder name
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:
                                                        10, // Distance from the top
                                                    left:
                                                        10, // Distance from the left
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      // Adjust size to fit content
                                                      children: [
                                                        item.isstarred
                                                            ? GestureDetector(
                                                                onTapDown:
                                                                    (TapDownDetails
                                                                        details) {
                                                                  // Handle tap for the first icon
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.star,
                                                                  size:
                                                                      18.0, // Dynamic color
                                                                ),
                                                              )
                                                            : const SizedBox(),

                                                        // Add spacing between icons
                                                        item.password!
                                                                .isNotEmpty
                                                            ? GestureDetector(
                                                                onTapDown:
                                                                    (TapDownDetails
                                                                        details) {
                                                                  // Handle tap for the second icon
                                                                },
                                                                child:
                                                                    Image.asset(
                                                                  imgprotection,
                                                                  height: 18,
                                                                  width: 18,
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:
                                                        10, // Distance from the top
                                                    right:
                                                        0, // Distance from the right
                                                    child: GestureDetector(
                                                      onTapDown: (TapDownDetails
                                                          details) {
                                                        final tapPosition =
                                                            details
                                                                .globalPosition;
                                                        showMenu(
                                                          context: context,
                                                          position: RelativeRect
                                                              .fromLTRB(
                                                            tapPosition.dx,
                                                            tapPosition.dy,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                tapPosition.dx,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                tapPosition.dy,
                                                          ),
                                                          items: [
                                                            PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    imgprotection,
                                                                    height: 18,
                                                                    width: 18,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  item.password!
                                                                          .isNotEmpty
                                                                      ? const Text(
                                                                          "Unlock item")
                                                                      : const Text(
                                                                          "Protection"),
                                                                ],
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.edit,
                                                                    // Replace with your desired icon
                                                                    color: Colors
                                                                        .black, // Optional: Set icon color
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  Text(
                                                                      "Rename"),
                                                                ],
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.copy,
                                                                    // Replace with your desired icon
                                                                    color: Colors
                                                                        .black, // Optional: Set icon color
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  Text("Copy"),
                                                                ],
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.cut,
                                                                    // Replace with your desired icon
                                                                    color: Colors
                                                                        .black, // Optional: Set icon color
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  Text("Cut"),
                                                                ],
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.paste,
                                                                    // Replace with your desired icon
                                                                    color: Colors
                                                                        .black, // Optional: Set icon color
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  Text("Paste"),
                                                                ],
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 1,
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .delete,
                                                                    // Replace with your desired icon
                                                                    color: Colors
                                                                        .black, // Optional: Set icon color
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  // Space between icon and text
                                                                  Text(
                                                                      "Delete"),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ).then((value) {
                                                          if (value != null) {
                                                            debugPrint(
                                                                "Selected Menu Item: $value");
                                                            menuClickListener(
                                                                value,
                                                                context,
                                                                item);
                                                          }
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .more_vert, // Three-dot icon
                                                        size: 20.0,
                                                        color: appBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )));
                                    },
                                  ))
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  // Adjust the bottom margin as needed
                                  child: ListView.builder(
                                    itemCount: controller
                                        .dashboardDataModelRes.value.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item = controller
                                          .dashboardDataModelRes.value[index];
                                      return ListTile(
                                          onTap: () {
                                            print("Card clicked!");
                                            print("Card clicked!" +
                                                item.dir.toString());
                                            print("Card clicked!" +
                                                item.path.toString());
                                            print("Card clicked!" +
                                                item.password.toString());

                                            if (item.dir == true) {
                                              if (item.password?.isEmpty ==
                                                  true) {
                                                Routes.navigateTo(
                                                    routeDashboard,
                                                    item.path.toString());
                                              }
                                            }
                                          },
                                          leading: FileUtils.getStringFileType(
                                                      item.dir,
                                                      item.name.toString()) ==
                                                  "jpg"
                                              ? FutureBuilder<Uint8List>(
                                                  future:
                                                      controller.fetchThumbnail(
                                                          item.path),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<Uint8List>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      // Show a loading indicator while waiting for the image to load
                                                      return const SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      // Handle any errors
                                                      return const SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                                'Error loading image')),
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      // Display the image when the data is available
                                                      return Image.memory(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                        height: 50,
                                                      );
                                                    } else {
                                                      // Handle the case where no data is available
                                                      return const SizedBox(
                                                        width: 300,
                                                        height: 300,
                                                        child: Center(
                                                            child: Text(
                                                                'No image available')),
                                                      );
                                                    }
                                                  },
                                                )
                                              : SvgPicture.asset(
                                                  FileUtils.getStringFileType(
                                                      item.dir,
                                                      item.name.toString()),
                                                  width:
                                                      40.0, // Adjust size to fit well
                                                  height: 40.0,
                                                  fit: BoxFit.contain,
                                                ),
                                          title: Text(
                                            item.name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            // Show "..." if the text overflows// Folder name
                                            maxLines: 2,
                                            // Allow up to 2 lines
                                            textAlign: TextAlign.left,
                                            // Aligns text to the left
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // Ensures the row takes up only the required space
                                            children: [
                                              // Image.memory(_imageData!)
                                              // Add spacing between icons
                                              item.password!.isNotEmpty
                                                  ? GestureDetector(
                                                      onTapDown: (TapDownDetails
                                                          details) {
                                                        // Handle tap for the second icon
                                                      },
                                                      child: Image.asset(
                                                        imgprotection,
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              item.isstarred
                                                  ? IconButton(
                                                      icon: const Icon(
                                                          Icons.star,
                                                          size: 18.0,
                                                          color: appBlue),
                                                      onPressed: () {
                                                        // Handle delete button press
                                                      },
                                                    )
                                                  : const SizedBox(),
                                              GestureDetector(
                                                onTapDown:
                                                    (TapDownDetails details) {
                                                  final tapPosition =
                                                      details.globalPosition;
                                                  showMenu(
                                                    context: context,
                                                    position:
                                                        RelativeRect.fromLTRB(
                                                      tapPosition.dx,
                                                      tapPosition.dy,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          tapPosition.dx,
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height -
                                                          tapPosition.dy,
                                                    ),
                                                    items: [
                                                      PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              imgprotection,
                                                              height: 18,
                                                              width: 18,
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            // Space between icon and text
                                                            item.password!
                                                                    .isNotEmpty
                                                                ? const Text(
                                                                    "Unlock item")
                                                                : const Text(
                                                                    "Protection"),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.edit,
                                                                color: Colors
                                                                    .black),
                                                            SizedBox(width: 10),
                                                            Text("Rename"),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.copy,
                                                              // Replace with your desired icon
                                                              color: Colors
                                                                  .black, // Optional: Set icon color
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Space between icon and text
                                                            Text("Copy"),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.cut,
                                                              // Replace with your desired icon
                                                              color: Colors
                                                                  .black, // Optional: Set icon color
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Space between icon and text
                                                            Text("Cut"),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.paste,
                                                              // Replace with your desired icon
                                                              color: Colors
                                                                  .black, // Optional: Set icon color
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Space between icon and text
                                                            Text("Paste"),
                                                          ],
                                                        ),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 1,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.delete,
                                                              // Replace with your desired icon
                                                              color: Colors
                                                                  .black, // Optional: Set icon color
                                                            ),
                                                            SizedBox(width: 10),
                                                            // Space between icon and text
                                                            Text("Delete"),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ).then((value) {
                                                    if (value != null) {
                                                      debugPrint(
                                                          "Selected Menu Item: $value");
                                                      menuClickListener(
                                                          value, context, item);
                                                    }
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.more_vert,
                                                  // Three-dot menu icon
                                                  size: 24.0,
                                                  color: appBlue,
                                                ),
                                              ),
                                            ],
                                          ) /**/
                                          );
                                    },
                                  )),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _selectedIndex == 2
                ? const SettingsScreen()
                : SizedBox(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: appBlue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Starred',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting ',
            ),
          ],
        ));
  }

  void showProtectionDialog(
      BuildContext context, DashboardDataModelRes itemdata) {
    showDialog(
      context: context,
      builder: (context) {
        return PasswordConfirmDialog(itemdata);
      },
    );
  }

  void menuClickListener(
      int item, BuildContext context, DashboardDataModelRes itemdata) {
    if (item == 1) {
      showProtectionDialog(context, itemdata);
    }
  }
}


/* Stack(
          children: [
            SafeArea(
              child: IndexedStack(
                index: _selectedIndex, // Current index for the stack
                children: _screens.map((screen) {
                  return ;
                }).toList(),
              ),)
          ],
        )*/