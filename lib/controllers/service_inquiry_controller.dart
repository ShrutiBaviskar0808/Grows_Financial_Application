import 'package:flutter/material.dart';
import 'package:flutter_awesome_select_clone/flutter_awesome_select.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/screens/files_screen.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';

class ServiceInquiryController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();

  RxBool showSpinner = false.obs;

  // services raw list from API
  RxList<Map<String, dynamic>> services = <Map<String, dynamic>>[].obs;

  // selected service (full map)
  final Rxn<Map<String, dynamic>> selectedService = Rxn<Map<String, dynamic>>();

  // selected ids
  RxString serviceId = "".obs;
  RxString businessID = "".obs;
  RxString clientID = "".obs;
  RxString type = "".obs;
  String serviceName = "";

  // fields
  final TextEditingController notesController = TextEditingController();

  // errors
  RxString serviceIdError = "".obs;
  RxString notesError = "".obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = (Get.arguments ?? {}) as Map;

    serviceId.value = arguments['serviceID']?.toString() ?? '';
    type.value = arguments['type']?.toString() ?? '';

    loadDropdowns(type.value);
  }

  /// Build choices for SmartSelect
  List<S2Choice<Map<String, dynamic>>> get serviceChoices {
    return services.map((item) {
      final id = (item['id'] ?? '').toString();
      final title = (item['service_name'] ??
          item['name'] ??
          item['title'] ??
          'Service $id')
          .toString();

      return S2Choice<Map<String, dynamic>>(
        value: item,
        title: title,
        meta: id, // optional
      );
    }).toList();
  }

  Future<void> loadDropdowns(String type) async {
    showSpinner(true);
    try {
      final response = await restApi.getServices(type);
      if (response != null && response['result'] == 'success') {
        final list = (response['data'] as List?) ?? [];
        services.value = list.map((e) => Map<String, dynamic>.from(e)).toList();

        // preselect if serviceId passed in arguments
        if (serviceId.value.isNotEmpty) {
          final found = services.firstWhereOrNull(
                (e) => (e['id']?.toString() ?? '') == serviceId.value,
          );
          if (found != null) {
            selectedService.value = found;
            serviceName = found['name'];
          }
        }
      } else {
        config.showToastFailure(response?['msg'] ?? 'Failed to load services');
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
  }

  void onServiceChanged(Map<String, dynamic>? v) {
    selectedService.value = v;
    serviceId.value = (v?['id'] ?? '').toString();
    serviceIdError.value = "";
  }

  bool _validate() {
    bool ok = true;

    if (serviceId.value.isEmpty) {
      serviceIdError.value = "Please select service";
      ok = false;
    }

    return ok;
  }

  Future<void> submitInquiry() async {
    if (!_validate()) return;

    try {
      businessID.value = await config.getStringSharedPreferences("businessID");
      clientID.value = await config.getStringSharedPreferences("id");

      showSpinner(true);

      final response = await restApi.addServiceInquiry(
        clientID.value,
        businessID.value,
        serviceId.value,
        notesController.text.trim(),
        type.value,
      );

      if (response != null && response['result'] == 'success') {
        config.showToastSuccess(response['msg']);
        Get.offNamedUntil(FilesScreen.id, ModalRoute.withName(FilesScreen.id),arguments: {"serviceID": serviceId.value, "type": type.value,
          "serviceName": serviceName,});
      } else {
        config.showToastFailure(response?['msg'] ?? "Failed");
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to submit");
    } finally {
      showSpinner(false);
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
