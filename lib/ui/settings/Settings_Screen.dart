import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../widgets/common_text_label.dart';
import 'Settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController controller = Get.put(SettingsController());
  var isLoading = false.obs;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    // Change status bar color to your desired color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBlue, // Set the status bar color
      statusBarIconBrightness: Brightness.light, // Set icons to light mode
    ));
    // controller.getDashboardApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      body: getBodyWidget(context: context),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("-------------------_onItemTapped----------");
      Routes.navigateTo(
          routeDashboard,
          "");
    });
  }

  Widget getBodyWidget({required BuildContext context}) {
    return Scaffold(
        body:Stack(
      children: [
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: false,
                toolbarHeight: 50,
                // Adjust height if needed
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                      children: [
                        // Text in the center
                        const CommonText(
                          "Settings",
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10), // Add spacing between text and line
                        // Horizontal line
                        Container(
                          height: 0.5, // Thickness of the line
                          width: double.infinity, // Full-width line
                          color: Colors.grey, // Line color
                        ),
                      ],
                    ),
                  ),

                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  child: Column(children: [

                    // Add settings options below
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text("Account"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Notifications"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Logout"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        await AppPref().logout();
                        Get.offAllNamed(
                          routeSignIn,
                        );
                      },
                    ),
                    const Divider(),
                  ],),

                ),
              )
            ],
          ),

        ),

      ],
    ),
      );
  }
}

