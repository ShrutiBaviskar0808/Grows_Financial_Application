import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/screens/file_details_screen.dart';

class FileRaw extends StatelessWidget {
  final String title, date, status, id, serviceID;
  final int jobStatus;

  const FileRaw({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.id,
    required this.serviceID,
    required this.jobStatus,
  });

  @override
  Widget build(BuildContext context) {
    final bool showOrange = jobStatus == 0;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (serviceID == "1") {
          Get.toNamed(FileDetailsScreen.id, arguments: {"cs_id": id});
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Stack(
          children: [
            // Orange back (full, but only left will be visible)
            if (showOrange)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6A00),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),

            // Navy front card (shift right to show orange strip)
            Container(
              margin: EdgeInsets.only(left: showOrange ? 14 : 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0B3A55),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // IMPORTANT
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // title pill
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/user-check.png",
                          height: 56,
                          color: Colors.white,
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 46,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0B3A55),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _infoRow(
                      icon: "assets/icons/calendar.png",
                      text: "Filled Date : $date",
                    ),
                    const SizedBox(height: 10),

                    _infoRow(
                      icon: "assets/icons/info.png",
                      text: "Status : $status",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required String icon, required String text}) {
    return Row(
      children: [
        Image.asset(icon, height: 20, color: Colors.white.withValues(alpha: 0.9)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
