import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_bottom_tab.dart';
import 'package:growsfinancial/components/header_raw.dart';
import 'package:growsfinancial/components/navigation_menu.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BackdropNavController nav = Get.find<BackdropNavController>();

  @override
  void initState() {
    super.initState();
    nav.getUser();
    nav.getDocumentRequest();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult:
          (didPop, result) => nav.backClick(didPop, result, context),
      child: CommonSafeArea(
        child: BackdropScaffold(
          backgroundColor: primaryColor,
          backLayer: Builder(
            builder: (context) {
              return Container(
                color: backgroundColor,
                child: NavigationMenu(
                  onClose: () {
                    Backdrop.of(context).fling(); // ✅ no null crash
                  },
                ),
              );
            },
          ),
          frontLayerShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),

          // ✅ Front layer with proper backdrop context
          frontLayer: Container(
            color: primaryColor, // ✅ keeps top blue
            child: Builder(
              builder: (ctx) {
                return Column(
                  children: [
                    HeaderRaw(
                      userName: nav.userData['name'] ?? "",
                      profileImage: "",
                      onMenuTap: () {
                        Backdrop.of(ctx).fling(); // ✅ no null crash
                      },
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Obx(
                          () => nav.buildCurrent(),
                        ), // ✅ body changes, header fixed
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ✅ show/hide bottom tab based on controller
          bottomNavigationBar: CustomBottomTab(nav: nav),
        ),
      ),
    );
  }
}
