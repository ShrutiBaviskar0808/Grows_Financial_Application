import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/document_requests_screen.dart';
import 'package:growsfinancial/screens/profile_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class CustomBottomTab extends StatelessWidget {
  final BackdropNavController nav;

  const CustomBottomTab({super.key, required this.nav});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(asset: "assets/icons/home.png", key: AccountsScreen.id),

          _item(
            asset: "assets/icons/bell.png",
            key: DocumentRequestsScreen.id,
            showBadge: true, // 🔥 only here
          ),

          _item(asset: "assets/icons/whatsapp.png", key: "whatsapp_tab"),

          _item(asset: "assets/icons/profile.png", key: ProfileScreen.id),
        ],
      ),
    );
  }

  Widget _item({
    required String asset,
    required String key,
    bool showBadge = false,
  }) {
    return Obx(() {
      final active = nav.activeTabKey.value == key;
      final count = nav.notificationCount.value;

      return InkWell(
        onTap: () {
          nav.openPage(key);

          // optional: clear count when clicking notifications

        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            border:
                active
                    ? const Border(
                      bottom: BorderSide(color: Colors.white, width: 3),
                    )
                    : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(asset, height: 30),
              /// 🔴 Badge
              if (showBadge && count > 0)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        count > 99 ? "99+" : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
