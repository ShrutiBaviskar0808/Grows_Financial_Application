import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/screens/upload_documents_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class DocumentRequestRaw extends StatelessWidget {
  final dynamic request;

  const DocumentRequestRaw({required this.request, super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find();
    String title =
        "${request['document_title']}-${request['category_name']} For ${request['service_name'] ?? "N/A"}";
    String status = request['status'] == 0 ? "Requested" : "Uploaded";
    return InkWell(
      onTap: () {
        Get.toNamed(
          UploadDocumentsScreen.id,
          arguments: {
            "cs_id": request['cs_id'].toString(),
            "request_id": request['request_id'].toString(),
            "category_id": request['category_id'].toString(),
            "title": title,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.5, 0.5),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: titleTextStyle.copyWith(fontSize: 15)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.circleUser, size: 12),
                            const SizedBox(width: 5.0),
                            Text(
                              "${request['client_name']}",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: request['business_name'] != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.briefcase, size: 12),
                              const SizedBox(width: 5.0),
                              Text(
                                "${request['business_name']}",
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.calendarDays, size: 12),
                            const SizedBox(width: 5.0),
                            Text(
                              "Requested Date : ${controller.config.convertDate(request['addedOn'])}",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.circleInfo, size: 12),
                            const SizedBox(width: 5.0),
                            Text(
                              "Status : $status",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              "${request['description']}",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 22,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
