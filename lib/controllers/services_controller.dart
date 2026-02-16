import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServicesController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  var showSpinner = false.obs,
      userData = {}.obs,
      businessData = {}.obs,
      title = "".obs,
      type = "".obs,
      clientID = "".obs,
      businessID = "".obs,
      serviceID = "".obs,
      services = [].obs,
      documentGroups = [].obs,
      clientServices = [].obs,
      clientService = <String, dynamic>{}.obs;

  // Map the icon string from API to MdiIcons/IconData
  final Map<String, IconData> mdiIconMap = {
    "mdi-account-outline": MdiIcons.accountOutline,
    "mdi-dolly": MdiIcons.dolly,
    "mdi-cash": MdiIcons.cash,
    "mdi-notebook-edit-outline": MdiIcons.notebookEditOutline,
    "mdi-book-information-variant": MdiIcons.bookInformationVariant,
    "mdi-office-building-marker-outline": MdiIcons.officeBuildingMarkerOutline,
    "mdi-credit-card-check-outline": MdiIcons.creditCardCheckOutline,
    "mdi-cash-check": MdiIcons.cashCheck,
    // Add more as needed!
  };

  var formDataMap = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  void getServices(String type) async {
    showSpinner(true);
    try {
      this.type.value = type;
      var response = await restApi.getServices(type);
      if (response != null && response['result'] == 'success') {
        services.value = response['data'];
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  void getServiceDetail(String id) async {
    showSpinner(true);
    try {
      var response = await restApi.getClientService(
        id,
        clientID.value,
        serviceID.value,
      );
      if (response != null && response['result'] == 'success') {
        clientService.value = Map<String, dynamic>.from(response['data'] ?? {});

        if (clientService['records'] != null &&
            clientService['records'].isNotEmpty) {
          final formDataStr = clientService['records']['form_data'];
          documentGroups.assignAll(clientService['document_groups'] ?? []);

          log(formDataStr);
          formDataMap.value = json.decode(formDataStr);
        }
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  void getUser() async {
    showSpinner(true);
    try {
      businessID.value = await config.getStringSharedPreferences("businessID");
      clientID.value = await config.getStringSharedPreferences("id");
      if (businessID.value.isNotEmpty) {
        var response = await restApi.getBusiness(businessID.value);

        if (response != null && response['result'] == 'success') {
          businessData.value = response['data'];
          title.value = response['data']['corporation_business_name'];
        }
      }
      var response = await restApi.getUser(clientID.value);

      if (response != null && response['result'] == 'success') {
        userData.value = response['data'];
        if (businessID.isEmpty) {
          title.value = response['data']['name'];
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }

  void getClientService(String serviceID, String type) async {
    showSpinner(true);
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (type == "Business") {
        businessID.value = await config.getStringSharedPreferences(
          "businessID",
        );
      }
      var response = await restApi.getClientServices(
        clientID.value,
        serviceID,
        type,
        businessID.value,
      );

      if (response != null && response['result'] == 'success') {
        clientServices.value = response['data'];
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
    update();
  }
}
