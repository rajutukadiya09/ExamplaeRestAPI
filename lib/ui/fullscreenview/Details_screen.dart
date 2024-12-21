import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/PdfThumbnailWidget.dart';
import '../../utils/ThumbnailWidget.dart';
import '../../utils/app_colors.dart';
import '../../utils/utility.dart';
import 'Details_controller.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final DetailsController controller = Get.put(DetailsController());
  var isLoading = false.obs;

  // Access the arguments
  final arguments = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBlue, // Set the status bar color
      statusBarIconBrightness: Brightness.light, // Set icons to light mode
    ));
    print("--->${arguments["path"]}");
    print("--->${arguments["name"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      body: getBodyWidget(context: context),
    );
  }

  Widget getBodyWidget({required BuildContext context}) {
    return Container(
      color: FileUtils.getStringFileType(
          false, arguments["name"].toString()) == "jpg"
          ?Colors.black:Colors.white,
      child: Stack(
        children: [
          Text(arguments["name"]) ,
          Center(
              child:FileUtils.getStringFileType(
                  false, arguments["name"].toString()) == "jpg"
                  ? ThumbnailWidget(
                  path: arguments["path"], controller: controller)
                  : BlobPdfViewer(
                url: arguments["path"], // Replace with your PDF URL
              ) ),
          Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                  icon: FileUtils.getStringFileType(
                              false, arguments["name"].toString()) ==
                          "jpg"
                      ? const Icon(Icons.close_sharp, color: Colors.white)
                      : const Icon(Icons.close_sharp, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  })),
          Positioned(
              top: 20,
              right: 0,
              child: IconButton(
                  icon: FileUtils.getStringFileType(
                              false, arguments["name"].toString()) ==
                          "jpg"
                      ? const Icon(Icons.download, color: Colors.white)
                      : const Icon(Icons.download, color: Colors.black),
                  onPressed: () {
                    controller.downloadFile(
                        arguments["path"], arguments["name"]);
                  }))
        ],
      ),
    );
  }
}
