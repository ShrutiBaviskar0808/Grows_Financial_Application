import 'package:flutter/material.dart';
import 'package:flutter_awesome_select_clone/flutter_awesome_select.dart';
import 'package:get/get.dart';

import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/service_inquiry_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class ServiceInquiryScreen extends StatelessWidget {
  static const String id = "/ServiceInquiryScreen";

  ServiceInquiryScreen({super.key});

  final ServiceInquiryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(
          () => Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: controller.showSpinner.value
              ? controller.config.loadingView()
              : CommonSafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Service Inquiry",
                    style: titleTextStyle.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 15),

                // ===== Service dropdown (Map) =====
                SmartSelect<Map<String, dynamic>?>.single(
                  title: 'Select Service (Required)',
                  selectedValue: controller.selectedService.value,
                  choiceItems: controller.serviceChoices,
                  onChange: (sel) => controller.onServiceChanged(sel.value),
                  modalType: S2ModalType.bottomSheet,
                  modalFilter: true,
                  tileBuilder: (context, state) {
                    final selectedTitle =
                        state.selected.title ?? "Choose service";
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Select Service (Required)",
                        style: titleTextStyle,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          selectedTitle,
                          style: TextStyle(
                            color: controller.serviceIdError.value.isEmpty
                                ? Colors.black87
                                : Colors.red,
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      onTap: state.showModal,
                    );
                  },
                ),

                if (controller.serviceIdError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 2),
                    child: Text(
                      controller.serviceIdError.value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // ===== Notes =====
                CustomTextField(
                  focusedBorderColor: primaryColor,
                  borderColor: grey2,
                  hintText: "What kind of service you want? (Optional)",
                  textController: controller.notesController,
                  hintColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  maxLines: 4,
                  errorText: controller.notesError.value,
                  onChanged: (_) => controller.notesError.value = "",
                ),

                const SizedBox(height: 12),

                CustomTextButton(
                  title: "Submit Inquiry",
                  onTap: controller.submitInquiry,
                  width: width,
                  height: 56,
                  color: primaryColor,
                  borderRadius: 15,
                  textStyle: titleTextStyle.copyWith(color: Colors.white),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
