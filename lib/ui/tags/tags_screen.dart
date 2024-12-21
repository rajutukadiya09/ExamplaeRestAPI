import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../widgets/common_designed_container.dart';
import '../../widgets/common_text_label.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            title: const CommonText(
              "Tags",
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            elevation: 0,
            pinned: true,
            toolbarHeight: 50,
            // Adjust height if needed
            flexibleSpace: Container(
              height: Get.height / 2.5,
              decoration: const BoxDecoration(
                color: appBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(top: 20, left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(
                      imageString: imgGlowStar,
                      text: 'Favorites',
                    ),
                    CustomContainer(
                      imageString: imgGlowFile,
                      text: 'Group by',
                    ),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
