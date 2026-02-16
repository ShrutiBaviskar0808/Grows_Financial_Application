import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/customer_detail_raw.dart';
import 'package:growsfinancial/controllers/services_controller.dart';
import 'package:growsfinancial/screens/documents_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class FileDetailsScreen extends StatefulWidget {
  static const String id = "/FileDetailsScreen";
  const FileDetailsScreen({super.key});

  @override
  State<FileDetailsScreen> createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  final ServicesController controller = Get.find();

  @override
  void initState() {
    super.initState();
    final arguments = (Get.arguments ?? {}) as Map;
    controller.getServiceDetail(arguments['cs_id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      final formData = controller.formDataMap; // RxMap
      return Scaffold(
        appBar: CustomAppBar(automaticallyImplyLeading: true),
        backgroundColor: backgroundColor,
        body: CommonSafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.documentGroups.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextButton(
                      width: width,
                      height: 46,
                      color: primaryColor,
                      borderRadius: 50,
                      borderColor: primaryColor,
                      textStyle: titleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      title: "View Documents",
                      onTap: () => Get.toNamed(DocumentsScreen.id),
                    ),
                  ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FORM DETAILS",
                            style: titleTextStyle.copyWith(
                              fontSize: 18,
                              color: primaryColor,
                            ),
                          ),
                          ...formData.entries.map((entry) {
                            final value = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomerDetailRaw(
                                title: entry.key.toString(),
                                detail: value is List ? value.join(', ') : value.toString(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
