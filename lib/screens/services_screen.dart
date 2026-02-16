import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/services_raw.dart';
import 'package:growsfinancial/controllers/services_controller.dart';

class ServicesScreen extends StatefulWidget {
  static const String id = "/ServicesScreen";
  final Map arguments;

  const ServicesScreen({super.key, required this.arguments,});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ServicesController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.getServices(widget.arguments['type']);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
           SingleChildScrollView(
                child: controller.showSpinner.value
                    ? controller.config.loadingView()
                    :Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
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
                          ListView.separated(
                            itemCount: controller.services.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (context, index) => SizedBox(height: 5),
                            // spacing here
                            itemBuilder: (context, index) {
                              var service = controller.services[index];
                              return ServicesRaw(service: service);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
