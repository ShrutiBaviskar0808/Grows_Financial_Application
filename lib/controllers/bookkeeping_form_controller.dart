import 'dart:developer';

import 'package:flutter_awesome_select_clone/flutter_awesome_select.dart';
import 'package:growsfinancial/screens/service_inquiry_form.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookkeepingFormController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  DateTime currentDate = DateTime.now();

  final TextEditingController fiscalYearEndController = TextEditingController();
  final TextEditingController bankAccountsController = TextEditingController();
  final TextEditingController creditCardsController = TextEditingController();
  final TextEditingController lineOfCreditController = TextEditingController();
  final TextEditingController loanController = TextEditingController();
  final TextEditingController staffEmployeeController = TextEditingController();
  final TextEditingController partnersOwnersController =
      TextEditingController();
  final TextEditingController folderByFrequencyController =
      TextEditingController();

  // Dropdown selections (Rx)
  final RxString clientID = "".obs;
  final RxString serviceID = "".obs;
  final RxString type = "".obs;
  final RxString businessID = "".obs;
  final RxString fiscalYearEnd = "".obs;
  final RxString bookkeepingSoftware = "".obs;
  final RxString frequencyOfWork = "".obs;

  // Errors
  final RxString fiscalYearEndError = "".obs;
  final RxString bankAccountsError = "".obs;
  final RxString creditCardsError = "".obs;
  final RxString lineOfCreditError = "".obs;
  final RxString loanError = "".obs;
  final RxString staffEmployeeError = "".obs;
  final RxString bookkeepingSoftwareError = "".obs;
  final RxString partnersOwnersError = "".obs;
  final RxString frequencyOfWorkError = "".obs;

  // Options
  List<S2Choice<String>> fiscalYearEndOptions = [],
      bookkeepingSoftwareOptions = [],
      frequencyOptions = [];

  var showSpinner = false.obs;

  FocusNode fiscalYearEndNode = FocusNode();
  FocusNode bookKeepingSoftwareNode = FocusNode();
  FocusNode frequencyNode = FocusNode();

  // SINGLE
  void handleS2SingleChange<T>({
    required S2SingleSelected<T> selected,
    // required RxString selectedValueTarget, // storing String ids
    required RxString resultTextTarget, // storing human labels
    RxString? errorText,
  }) {
    final v = selected.value?.toString() ?? '';
    final t = selected.choice?.title ?? v;
    // selectedValueTarget.value = v;
    resultTextTarget.value = t;
    errorText!.value = "";
  }

  @override
  void onInit() {
    super.onInit();
    loadOptions();
    final arguments = (Get.arguments ?? {}) as Map;
    serviceID.value = arguments['serviceID']?.toString() ?? '';
    type.value = arguments['type']?.toString() ?? '';
    log("Service ID : $serviceID,Type: $type");
  }

  // Simple helper
  bool _isPositiveInt(String v) {
    final n = int.tryParse(v.trim());
    return n != null && n >= 0;
  }

  void onFrequencyChanged<T>(S2SingleSelected<T> selected ) {
    frequencyOfWork.value = selected.value?.toString() ?? "";
    frequencyOfWorkError.value = "";

    // Auto folder name
    if (frequencyOfWork.value.isNotEmpty) {
      folderByFrequencyController.text =
      "Bookkeeping/${frequencyOfWork.value.replaceAll(' ', '_')}";
    } else {
      folderByFrequencyController.clear();
    }
  }

  void loadOptions() async {
    try {
      showSpinner(true);
      clientID.value = await config.getStringSharedPreferences("id");
      businessID.value = await config.getStringSharedPreferences("businessID");
      var response = await restApi.bookKeepingFormOptions(businessID.value);

      if (response != null && response['result'] == 'success') {
        var data = response['data'];

        fiscalYearEndOptions =
            (data['fiscalYears'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        bookkeepingSoftwareOptions =
            (data['bookKeepingSoftware'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        frequencyOptions =
            (data['frequencyOfWork'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
  }

  // Submit
  void submitBookkeepingForm() async {
    // Clear previous errors
    fiscalYearEndError.value = "";
    bankAccountsError.value = "";
    creditCardsError.value = "";
    lineOfCreditError.value = "";
    loanError.value = "";
    staffEmployeeError.value = "";
    bookkeepingSoftwareError.value = "";
    partnersOwnersError.value = "";
    frequencyOfWorkError.value = "";

    bool ok = true;

    if (fiscalYearEnd.value.isEmpty) {
      fiscalYearEndError.value = "Required";
      ok = false;
    }

    if (!_isPositiveInt(bankAccountsController.text)) {
      bankAccountsError.value = "Enter valid number";
      ok = false;
    }

    if (!_isPositiveInt(creditCardsController.text)) {
      creditCardsError.value = "Enter valid number";
      ok = false;
    }

    if (!_isPositiveInt(lineOfCreditController.text)) {
      lineOfCreditError.value = "Enter valid number";
      ok = false;
    }

    if (!_isPositiveInt(loanController.text)) {
      loanError.value = "Enter valid number";
      ok = false;
    }

    if (!_isPositiveInt(staffEmployeeController.text)) {
      staffEmployeeError.value = "Enter valid number";
      ok = false;
    }

    if (bookkeepingSoftware.value.isEmpty) {
      bookkeepingSoftwareError.value = "Required";
      ok = false;
    }

    if (!_isPositiveInt(partnersOwnersController.text)) {
      partnersOwnersError.value = "Enter valid number";
      ok = false;
    }

    if (frequencyOfWork.value.isEmpty) {
      frequencyOfWorkError.value = "Required";
      ok = false;
    }

    if (!ok) return;

    // ✅ Build payload
    final payload = {
      "fiscal_year_end": fiscalYearEnd.value,
      "bank_accounts": int.parse(bankAccountsController.text.trim()),
      "credit_cards": int.parse(creditCardsController.text.trim()),
      "line_of_credit": int.parse(lineOfCreditController.text.trim()),
      "loan": int.parse(loanController.text.trim()),
      "staff_employee": int.parse(staffEmployeeController.text.trim()),
      "bookkeeping_software": bookkeepingSoftware.value,
      "partners_owners": int.parse(partnersOwnersController.text.trim()),
      "frequency_of_work": frequencyOfWork.value,
      "folder_by_frequency": folderByFrequencyController.text.trim(),
    };

    var response = await restApi.addBookKeepingDetails(businessID.value, payload);

    if (response != null && response['result'] == 'success') {
      // Optionally, do navigation or show success
      config.showToastSuccess(response['msg']);
      Get.toNamed(ServiceInquiryScreen.id, arguments: {"serviceID": serviceID.value, "type": type});
    } else {
      config.showToastFailure(response?['msg'] ?? 'Unknown Error');
    }
  }
}
