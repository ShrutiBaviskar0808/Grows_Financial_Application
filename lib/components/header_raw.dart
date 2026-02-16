import 'package:flutter/material.dart';
import 'package:growsfinancial/utils/constant.dart';

class HeaderRaw extends StatelessWidget {
  final String userName;
  final String profileImage;
  final VoidCallback? onMenuTap;
  final bool isMenuVisible;

  const HeaderRaw({
    super.key,
    required this.userName,
    required this.profileImage,
    this.onMenuTap,
    this.isMenuVisible = true,
  });

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return "Good Morning !";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon !";
    } else {
      return "Good Evening !";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          // left avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: primaryColor),
          ),
          const SizedBox(width: 12),

          // name + greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello $userName,",
                  style: titleTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: boldFont,
                  ),
                ),
                Text(
                  getGreeting(),
                  style: titleTextStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // ✅ right menu icon
          Visibility(
            visible: isMenuVisible,
            child: IconButton(
              onPressed: onMenuTap,
              icon: Image.asset(
                "assets/icons/menu.png",
                height: 30,
                color: Colors.white, // only works if icon is single color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
