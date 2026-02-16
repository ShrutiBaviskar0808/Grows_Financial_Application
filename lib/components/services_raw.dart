import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/controllers/services_controller.dart';
import 'package:growsfinancial/screens/files_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class ServicesRaw extends StatelessWidget {
  final ServicesController controller = Get.find();
  final BackdropNavController nav = Get.find();
  final dynamic service;

  ServicesRaw({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final IconData iconData =
        controller.mdiIconMap[service['icon']] ?? Icons.help_outline;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        nav.openPage(
          FilesScreen.id,
          arguments: {
            "serviceID": service['id'],
            "type": service['type'],
            "serviceName": service['name'],
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor, // dark navy in your design
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Icon Area
            SizedBox(
              width: 70,
              height: 60,
              child: Center(
                child: Icon(
                  iconData,
                  size: 34,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // White pill text area
            Expanded(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  service['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
