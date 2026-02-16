import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/file_raw.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/controllers/services_controller.dart';
import 'package:growsfinancial/screens/form_step_screen.dart';
import 'package:growsfinancial/screens/bookkeeping_form_screen.dart';
import 'package:growsfinancial/screens/service_inquiry_form.dart';
import 'package:growsfinancial/utils/constant.dart';

class FilesScreen extends StatefulWidget {
  static const String id = "/FilesScreen";
  final Map arguments;

  const FilesScreen({super.key, required this.arguments});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final ServicesController controller = Get.find();
  final BackdropNavController nav = Get.put(BackdropNavController());

  String serviceID = "", type = "", serviceName = "";

  @override
  void initState() {
    super.initState();
    final arguments = widget.arguments;
    serviceID = arguments['serviceID'].toString();
    type = arguments['type'].toString();
    serviceName = arguments['serviceName'].toString();
    controller.getUser();
    controller.getClientService(serviceID, controller.type.value);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        backgroundColor: backgroundColor,
        body: CommonSafeArea(
          child: Stack(
            children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child:
                    controller.showSpinner.value
                        ? controller.config.loadingView()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: 28,
                              ),
                            ),
                            SizedBox(height: 15),
                            controller.clientServices.isEmpty
                                ? controller.config.noDataView(
                                  msg: "No Records Found!",
                                )
                                : ListView.separated(
                                  itemCount: controller.clientServices.length,
                                  separatorBuilder:
                                      (context, index) => SizedBox(height: 5),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var service =
                                        controller.clientServices[index];
                                    return FileRaw(
                                      title:
                                          "${service['period']} - ${service['name']}",
                                      date: controller.config
                                          .convertDateToString(
                                            service['filled_date'] ??
                                                service['start_date'],
                                          ),
                                      status: service['status_name'] ?? "",
                                      id: service['cs_id'].toString(),
                                      serviceID:
                                          service['service_id'].toString(),
                                      jobStatus: service['job_status'] ?? "1",
                                    );
                                  },
                                ),
                          ],
                        ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: CustomTextIconButton(
                icon: "assets/icons/add-white.png",
                iconSize: 20,
                iconColor: Colors.white,
                orientation: "left",
                title: "Request $serviceName",
                onTap: () {
                  if (serviceName != "T1" && serviceName != "T2") {
                    if (serviceName == "Bookkeeping" &&
                        controller.type.value != "Personal" &&
                        controller.businessData['bookkeeping_fields'] == null) {
                      Get.toNamed(
                        BookKeepingFormScreen.id,
                        arguments: {"serviceID": serviceID, "type": type},
                      );
                    } else {
                      Get.toNamed(
                        ServiceInquiryScreen.id,
                        arguments: {
                          "serviceID": serviceID,
                          "type": controller.type.value,
                        },
                      );
                    }
                  } else {

                    Get.toNamed(
                      FormStepScreen.id,
                      arguments: {"serviceID": serviceID, "type": type,"newRequest":true,},
                    );
                  }
                },
                width: width,
                height: 46,
                color: primaryColor,
                borderRadius: 18,
                borderColor: primaryColor,
                textStyle: titleTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
