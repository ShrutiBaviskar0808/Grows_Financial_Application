import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growsfinancial/utils/constant.dart';

class CircleImage extends StatelessWidget {
  final String imagePath, accountType;
  final double height, width, margin, spreadRadius, blurRadius;
  final Color color;
  final VoidCallback? onTap; // 👈 new

  const CircleImage({
    super.key,
    required this.height,
    required this.width,
    required this.margin,
    required this.spreadRadius,
    required this.blurRadius,
    required this.color,
    required this.imagePath,
    required this.accountType,
    this.onTap, // 👈 new
  });

  bool get hasImage =>
      imagePath.isNotEmpty &&
          imagePath.toLowerCase() != "null"; // safety if API returns "null"

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // tap only when no image (you can allow change later)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasImage)
            Container(
              height: height,
              width: width,
              margin: EdgeInsets.all(margin),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color,
                    spreadRadius: spreadRadius,
                    blurRadius: blurRadius,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(imageUrl + imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryColor,
              child: Icon(
                accountType == "Business"
                    ? FontAwesomeIcons.briefcase
                    : FontAwesomeIcons.user,
                color: Colors.white,
              ),
            ),
            /*Container(
              height: height,
              width: width,
              margin: EdgeInsets.all(margin),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
                boxShadow: [
                  BoxShadow(
                    color: color,
                    spreadRadius: spreadRadius,
                    blurRadius: blurRadius,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.add_a_photo, // 👈 + camera icon when no profile_pic
                  color: primaryColor,
                  size: 24,
                ),
              ),
            ),*/
        ],
      ),
    );
  }
}
