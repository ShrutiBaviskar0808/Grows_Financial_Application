import 'dart:developer';

import 'package:flutter_awesome_select_clone/flutter_awesome_select.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/files_screen.dart';
import 'package:growsfinancial/screens/form_step_screen.dart';
import 'package:growsfinancial/screens/form_t1_step2_screen.dart';
import 'package:growsfinancial/screens/form_t1_step3_screen.dart';
import 'package:growsfinancial/screens/form_t2_step1_screen.dart';
import 'package:growsfinancial/screens/form_t2_step2_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/canadian_postal_code_formatter.dart';
import 'package:growsfinancial/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  DateTime currentDate = DateTime.now();
  final BackdropNavController nav = Get.find();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController spouseFirstNameController = TextEditingController();
  TextEditingController spouseMiddleNameController = TextEditingController();
  TextEditingController spouseLastNameController = TextEditingController();
  TextEditingController spouseDobController = TextEditingController();
  TextEditingController maritalStatusChangeDateController =
      TextEditingController();
  TextEditingController dateOfArrivalController = TextEditingController();
  TextEditingController currentAddress1Controller = TextEditingController();
  TextEditingController currentAddress2Controller = TextEditingController();
  TextEditingController currentCityController = TextEditingController();
  TextEditingController currentPostalCodeController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sinController = TextEditingController();
  TextEditingController referController = TextEditingController();
  TextEditingController corporationNameController = TextEditingController();
  TextEditingController corporationNumberController = TextEditingController();
  TextEditingController businessAddress1Controller = TextEditingController();
  TextEditingController businessAddress2Controller = TextEditingController();
  TextEditingController businessCityController = TextEditingController();
  TextEditingController businessPostalCodeController = TextEditingController();
  TextEditingController incorporationDateController = TextEditingController();
  TextEditingController businessNumberController = TextEditingController();
  TextEditingController businessActivityController = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode middleNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode dobNode = FocusNode();
  FocusNode spouseFirstNameNode = FocusNode();
  FocusNode spouseMiddleNameNode = FocusNode();
  FocusNode spouseLastNameNode = FocusNode();
  FocusNode spouseDobNode = FocusNode();
  FocusNode maritalStatusChangeDateNode = FocusNode();
  FocusNode dateOfArrivalNode = FocusNode();
  FocusNode currentAddress1Node = FocusNode();
  FocusNode currentAddress2Node = FocusNode();
  FocusNode currentCityNode = FocusNode();
  FocusNode currentPostalCodeNode = FocusNode();
  FocusNode currentStateNode = FocusNode();
  FocusNode address1Node = FocusNode();
  FocusNode address2Node = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode postalCodeNode = FocusNode();
  FocusNode stateNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode sinNode = FocusNode();
  FocusNode referNode = FocusNode();
  FocusNode corporationNameNode = FocusNode();
  FocusNode corporationNumberNode = FocusNode();
  FocusNode corporationTypeNode = FocusNode();
  FocusNode businessAddress1Node = FocusNode();
  FocusNode businessAddress2Node = FocusNode();
  FocusNode businessCityNode = FocusNode();
  FocusNode businessPostalCodeNode = FocusNode();
  FocusNode businessStateNode = FocusNode();
  FocusNode incorporationDateNode = FocusNode();
  FocusNode businessNumberNode = FocusNode();
  FocusNode businessActivityNode = FocusNode();
  FocusNode sameAddressNode = FocusNode();
  FocusNode residencyStatusNode = FocusNode();
  FocusNode maritalStatusNode = FocusNode();
  FocusNode spouseStatusNode = FocusNode();
  FocusNode maritalStatusChangeNode = FocusNode();
  FocusNode taxFileNode = FocusNode();
  FocusNode taxYearsNode = FocusNode();
  FocusNode dependentChildrenNode = FocusNode();
  FocusNode dependentParentNode = FocusNode();
  FocusNode firstTimeFillingNode = FocusNode();
  FocusNode fileForEarlierNode = FocusNode();
  FocusNode craAccountNode = FocusNode();
  FocusNode businessAccountNode = FocusNode();
  FocusNode salariedEmployeesNode = FocusNode();
  FocusNode studyOptionsNode = FocusNode();
  FocusNode investmentExpensesNode = FocusNode();
  FocusNode businessRentingPropertyNode = FocusNode();
  FocusNode acknowledgmentNode = FocusNode();

  List<S2Choice<String>> residencyOptions = [],
      maritalOptions = [],
      statesOptions = [],
      yesNoOptions = [],
      taxYearsOptions = [],
      taxFileOptions = [],
      corporationTypeOptions = [],
      salariedEmployeesOptions = [],
      studyingOptions = [],
      investmentExpensesOptions = [],
      businessRentingPropertyOptions = [];

  RxList<String> selectedYears = [""].obs,
      selectedCorporationType = [""].obs,
      selectedTaxFile = [""].obs,
      selectedInvestmentExpenses = [""].obs,
      selectedBusinessRentingProperty = [""].obs,
      selectedStudying = [""].obs,
      selectedSalariedEmployees = [""].obs;
  var showSpinner = false.obs,
      formFilled = false.obs,
      profileVerified = false.obs,newRequest=false.obs;
  var userData = {}.obs,
      businessData = {}.obs,
      title = "".obs,
      firstNameError = "".obs,
      middleNameError = "".obs,
      lastNameError = "".obs,
      dobError = "".obs,
      currentAddress1Error = "".obs,
      currentAddress2Error = "".obs,
      currentCityError = "".obs,
      currentStateError = "".obs,
      currentPostalCodeError = "".obs,
      address1Error = "".obs,
      address2Error = "".obs,
      cityError = "".obs,
      stateError = "".obs,
      postalCodeError = "".obs,
      corporationNameError = "".obs,
      corporationNumberError = "".obs,
      corporationTypeError = "".obs,
      businessAddress1Error = "".obs,
      businessAddress2Error = "".obs,
      businessCityError = "".obs,
      businessStateError = "".obs,
      businessPostalCodeError = "".obs,
      incorporationDateError = "".obs,
      businessNumberError = "".obs,
      businessActivityError = "".obs,
      taxFileError = "".obs,
      phoneError = "".obs,
      emailError = "".obs,
      sinError = "".obs,
      sameAddressError = "".obs,
      residencyStatusError = "".obs,
      maritalStatusError = "".obs,
      spouseStatusError = "".obs,
      spouseFirstNameError = "".obs,
      spouseMiddleNameError = "".obs,
      spouseLastNameError = "".obs,
      spouseDobError = "".obs,
      maritalStatusChangeError = "".obs,
      maritalStatusChangeDateError = "".obs,
      arrivalDateError = "".obs,
      taxYearsError = "".obs,
      childDependentError = "".obs,
      parentDependentError = "".obs,
      firstTimeFillingError = "".obs,
      fileForEarlierError = "".obs,
      craAccountError = "".obs,
      businessAccountError = "".obs,
      acknowledgmentError = "".obs,
      selectedResidency = "".obs,
      selectedMarital = "".obs,
      selectedState = "".obs,
      currentSelectedState = "".obs,
      businessSelectedState = "".obs,
      years = [].obs,
      acknowledgment = [].obs,
      selectedAcknowledgment = [].obs,
      serviceID = "".obs,
      type = "".obs,
      businessID = "".obs,
      clientID = "".obs,
      csID = "".obs,
      infoText = "".obs,
      period = "".obs,
      dob = "".obs,
      spouseDob = "".obs,
      maritalStatusDate = "".obs,
      dateArrival = "".obs,
      incorporationDate = "".obs,
      state = "".obs,
      currentState = "".obs,
      businessState = "".obs,
      sameAddress = "".obs,
      statusOfResidence = "".obs,
      maritalStatus = "".obs,
      spouseStatus = "".obs,
      maritalStatusChange = "".obs,
      dependentChildren = "".obs,
      dependentParent = "".obs,
      firstTimeFilling = "".obs,
      fileForEarlier = "".obs,
      craAccount = "".obs,
      businessAccount = "".obs,
      phone = "".obs,
      countryCode = "+1".obs,
      clientService = {};
  String serviceName = "";

  Map<String, dynamic> step1FormData = {},
      step2FormData = {},
      step3FormData = {};

  @override
  void onInit() {
    super.onInit();
    getUser();
    formYears();
    final arguments = (Get.arguments ?? {}) as Map;
    serviceID.value = arguments['serviceID']?.toString() ?? '';
    type.value = arguments['type']?.toString() ?? '';
    serviceName = arguments['serviceName']?.toString() ?? '';
    log("Service ID : $serviceID,Type: $type");
  }

  bool canSubmit() {
    return period.value.isNotEmpty &&
        profileVerified.value == true &&
        formFilled.value == true;
  }

  String? submitErrorMessage() {
    if (period.value.isEmpty) return "Please select Year first.";
    if (!profileVerified.value) {
      return "Please complete/verify your Profile first.";
    }
    if (!formFilled.value) return "Please fill Tax Info first.";
    return null;
  }

  void getServiceDetail() async {
    showSpinner(true);
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      var response = await restApi.getClientService(
        "0",
        clientID.value,
        serviceID.value,
      );
      if (response != null && response['result'] == 'success') {
        clientService = response['data'];
        csID.value = clientService['cs_id'].toString();
        period.value = clientService['period'];
        profileVerified.value = clientService['profile_verified'] == 1;
        formFilled.value =
            clientService['records'] != null &&
            clientService['records'].isNotEmpty;
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

  Future<void> verifyProfile() async {
    showSpinner(true);
    try {
      if (csID.value.isEmpty) {
        config.showToastFailure("csID missing");
        return;
      }

      final res = await restApi.verifyProfile(csID.value);

      if (res != null && res['result'] == 'success') {
        profileVerified(true);
        config.showToastSuccess(res['msg'] ?? "Profile Verified");
        Get.back(); // close sheet
      } else {
        config.showToastFailure(res?['msg'] ?? "Verification failed");
      }
    } catch (e) {
      config.showToastFailure("Verification failed");
    } finally {
      showSpinner(false);
      update();
    }
  }


  void formYears() async {
    try {
      showSpinner(true);
      var response = await restApi.formYears();
      if (response != null && response['result'] == 'success') {
        years.value = response['data'];
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

  void submitForm() async {
    try {
      showSpinner(true);
      clientID.value = await config.getStringSharedPreferences("id");
      businessID.value = await config.getStringSharedPreferences("businessID");
      var response = await restApi.formOptions(
        clientID.value,
        serviceID.value,
        type.value,
        businessID.value,
        period.value,
      );

      if (response != null && response['result'] == 'success') {
        var data = response['data'];
        csID.value = data['cs_id']?.toString() ?? "";

        taxYearsOptions =
            (data['taxYears'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        yesNoOptions =
            (data['yesNoChoices'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        residencyOptions =
            (data['residencyChoices'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        statesOptions =
            (data['states'] as List<dynamic>)
                .cast<String>()
                .map<S2Choice<String>>(
                  (s) => S2Choice<String>(value: s, title: s),
                )
                .toList();
        if (type.value == "Business" && businessID.value.isNotEmpty) {
          corporationTypeOptions =
              (data['corporationType'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          taxFileOptions =
              (data['taxFile'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          Get.toNamed(FormT2Step1Screen.id,arguments: {
            "serviceID": serviceID.value,
            "type": type.value,
            "serviceName": serviceName,
          },);
        } else {
          acknowledgment.value = data['acknowledgment'];
          infoText.value = """${data['infoText']}""";

          salariedEmployeesOptions =
              (data['salariedEmployees'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          studyingOptions =
              (data['studyingOptions'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          businessRentingPropertyOptions =
              (data['businessRentingProperty'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          investmentExpensesOptions =
              (data['investmentExpenses'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          maritalOptions =
              (data['maritalChoices'] as List<dynamic>)
                  .cast<String>()
                  .map<S2Choice<String>>(
                    (s) => S2Choice<String>(value: s, title: s),
                  )
                  .toList();
          Get.offNamed(FormStepScreen.id);
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
  }

  void submitStep1() async {
    try {
      showSpinner(true);

      if (type.value == "Personal") {
        if (!_validatePersonalStep1()) {
          showSpinner(false);

          return;
        }
        // Collect all fields into the map
        step1FormData = {
          /*"firstName": firstNameController.text,
          "middleName": middleNameController.text,
          "lastName": lastNameController.text,
          "dob": dob.value,*/
          "address1": address1Controller.text,
          "address2": address2Controller.text,
          "city": cityController.text,
          "postalCode": postalCodeController.text,
          "currentAddress1": currentAddress1Controller.text,
          "currentAddress2": currentAddress2Controller.text,
          "currentCity": currentCityController.text,
          "currentPostalCode": currentPostalCodeController.text,
         /* "phone": countryCode.value + phone.value,
          "email": emailController.text,
          "sin": sinController.text,*/
          "state": state.value,
          "currentState": currentState.value,
          "sameAddress": sameAddress.value,
          "statusOfResidence": statusOfResidence.value,
          "maritalStatus": maritalStatus.value,
          "spouseFirstName": spouseFirstNameController.text,
          "spouseMiddleName": spouseMiddleNameController.text,
          "spouseLastName": spouseLastNameController.text,
          "spouseDob": spouseDob.value,
          "maritalStatusChange": maritalStatusChange.value,
          "maritalStatusDate": maritalStatusDate.value,
          "dependentChildren": dependentChildren.value,
          "dependentParent": dependentParent.value,
          "firstTimeFilling": firstTimeFilling.value,
          "dateArrival": dateArrival.value,
          "fileForEarlier": fileForEarlier.value,
          "selectedYears": selectedYears.toList(),
          "craAccount": craAccount.value,
          "businessAccount": businessAccount.value,
          "refer": referController.text,
        };
        Get.toNamed(FormT1Step2Screen.id,arguments: {
          "serviceID": serviceID.value,
          "type": type.value,
          "serviceName": serviceName,
        },);
      }
      if (type.value == "Business") {
        // Collect all fields into the map
        if (!_validateBusinessStep1()) {
          showSpinner(false);

          return;
        }
        step1FormData = {
          "corporationName": corporationNameController.text,
          "corporationNumber": corporationNumberController.text,
          "corporationType": selectedCorporationType.toList(),
          "businessAddress1": businessAddress1Controller.text,
          "businessAddress2": businessAddress2Controller.text,
          "businessCity": businessCityController.text,
          "businessPostalCode": businessPostalCodeController.text,
          "businessState": businessState.value,
          "incorporationDate": incorporationDateController.text,
          "businessNumber": businessNumberController.text,
          "businessActivity": businessActivityController.text,
          "taxFile": selectedTaxFile.toList(),
          "fileForEarlier": fileForEarlier.value,
          "selectedYears": selectedYears.toList(),
        };
        Get.toNamed(FormT2Step2Screen.id,arguments: {
          "serviceID": serviceID.value,
          "type": type.value,
          "serviceName": serviceName,
        },);
      }
      // Pass map to next step (optional: only if you want it in arguments)
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    } finally {
      showSpinner(false);
    }
  }

  void submitStep2() async {
    try {
      showSpinner(true);

      // Collect all step 2 fields
      if (type.value == "Personal") {
        step2FormData = {
          "selectedSalariedEmployees": selectedSalariedEmployees.toList(),
          "selectedStudying": selectedStudying.toList(),
          "selectedBusinessRentingProperty":
              selectedBusinessRentingProperty.toList(),
          "selectedInvestmentExpenses": selectedInvestmentExpenses.toList(),
        };
        Get.toNamed(FormT1Step3Screen.id,arguments: {
          "serviceID": serviceID.value,
          "type": type.value,
          "serviceName": serviceName,
        },);
      }
      if (type.value == "Business") {
        if (!_validateBusinessStep2()) {
          showSpinner(false);

          return;
        }
        step2FormData = {
          "firstName": firstNameController.text,
          "middleName": middleNameController.text,
          "lastName": lastNameController.text,
          "dob": dob.value,
          "address1": address1Controller.text,
          "address2": address2Controller.text,
          "city": cityController.text,
          "postalCode": postalCodeController.text,
          "state": state.value,
          "phone": phoneController.text,
          "email": emailController.text,
          "sin": sinController.text,
          "statusOfResidence": statusOfResidence.value,
        };
        // Merge step 1 and step 2 maps
        final fullFormData = {...step1FormData, ...step2FormData};

        // Submit to API (adjust API method as needed)
        var response = await restApi.addClientService(csID.value, fullFormData);

        if (response != null && response['result'] == 'success') {
          // Optionally, do navigation or show success
          config.showToastSuccess(response['msg']);

          Get.offNamedUntil(
            HomeScreen.id,
            ModalRoute.withName(HomeScreen.id),
          );
          nav.openPage(
            FilesScreen.id,
            arguments: {
              "serviceID": serviceID.value,
              "type": type.value,
              "serviceName": serviceName,
            },
          );
        } else {
          config.showToastFailure(response?['msg'] ?? 'Unknown Error');
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to submit data");
    } finally {
      showSpinner(false);
    }
  }

  void submitStep3() async {
    try {
      showSpinner(true);

      // Collect all step 2 fields
      if (type.value == "Personal") {
        if (!_requireList(
          "Acknowledgment",
          selectedAcknowledgment,
          acknowledgmentError,
          acknowledgmentNode,
        )) {
          showSpinner(false);

          return;
        }
        step3FormData = {
          "selectedAcknowledgment": selectedAcknowledgment.toList(),
        };
      }

      // Merge step 1 and step 2 maps
      final fullFormData = {
        ...step1FormData,
        ...step2FormData,
        ...step3FormData,
      };

      // Submit to API (adjust API method as needed)
      var response = await restApi.addClientService(csID.value, fullFormData);

      if (response != null && response['result'] == 'success') {
        // Optionally, do navigation or show success
        config.showToastSuccess(response['msg']);
        Get.offNamedUntil(
          HomeScreen.id,
          ModalRoute.withName(HomeScreen.id),
        );
        nav.openPage(
          FilesScreen.id,
          arguments: {
            "serviceID": serviceID.value,
            "type": type.value,
            "serviceName": serviceName,
          },
        );
      } else {
        config.showToastFailure(response?['msg'] ?? 'Unknown Error');
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to submit data");
    } finally {
      showSpinner(false);
    }
  }

  void selectPeriod(String year) {
    period.value = year;
  }

  void handleDatePick({
    required BuildContext context,
    required DateTime currentDate,
    required TextEditingController controller,
    required RxString value,
    RxString? errorText,
  }) async {
    DateTime dateTime = await config.pickDate(context, currentDate);
    if (dateTime != currentDate) {
      controller.text = DateFormat.yMMMMd().format(dateTime);
      value.value = DateFormat('yyyy-MM-dd').format(dateTime);
      errorText!.value = "";
    }
  }

  void handleDropdownChange({
    required String? value,
    required RxString target,
  }) {
    target.value = value ?? '';
  }

  void handleRadioChange({
    required RxInt radioValue,
    required RxString resultValue,
    required int? value,
    required List choices,
  }) {
    radioValue.value = value ?? 0;
    // Find the matching text for this value
    final item = choices.firstWhere(
      (e) => e['value'] == value,
      orElse: () => null,
    );
    resultValue.value = item?['text'] ?? '';
  }

  void handleCheckBoxChange({
    required bool? checked,
    required String value,
    required List list,
    required RxString errorText,
  }) {
    if (checked == true) {
      if (!list.contains(value)) list.add(value);
    } else {
      list.remove(value);
    }
    errorText.value = "";
  }

  /// SmartSelect SINGLE (like dropdown) — stores selected value & title text
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

  /// SmartSelect MULTIPLE — stores selected values & a joined titles string
  void handleS2MultiChange<T>({
    required S2MultiSelected<T> selected,
    required RxList<T> selectedValuesTarget,
    // required RxString resultTextTarget,
    RxString? errorText,
    String separator = ', ',
  }) {
    selectedValuesTarget.assignAll(selected.value);
    // final titles = selected.choice?.map((c) => c.title).toList() ?? const [];
    // resultTextTarget.value = titles.join(separator);
    errorText!.value = "";
  }

  //Validation
  bool _isEmail(String s) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
    return re.hasMatch(s.trim());
  }

  bool _isPhone(String s) {
    // Accept 10–15 digits (strip spaces/dashes)
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 10 && digits.length <= 15;
  }

  /// Canadian SIN Luhn check (9 digits)
  bool _isValidSIN(String s) {
    final digits = s.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 9) return false;

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      int d = int.parse(digits[i]);
      if ((i % 2) == 1) {
        // double every 2nd digit (0-based index)
        d *= 2;
        if (d > 9) d = d - 9;
      }
      sum += d;
    }
    return sum % 10 == 0;
  }

  bool _requireDropdownStr(
    String label,
    RxString value,
    RxString errorTarget,
    FocusNode focusNode,
  ) {
    if (value.value.isEmpty) {
      errorTarget.value = "$label is required";
      config.showToastFailure(errorTarget.value);
      focusNode.requestFocus();

      return false;
    }
    errorTarget.value = ""; // clear error if valid
    return true;
  }

  bool _requireText(
    String label,
    String c,
    RxString errorTarget,
    FocusNode focusNode,
  ) {
    if (c.trim().isEmpty) {
      errorTarget.value = "$label is required";
      config.showToastFailure(errorTarget.value);
      focusNode.requestFocus();

      return false;
    }
    errorTarget.value = "";
    return true;
  }

  /// Validate Canadian postal with your existing formatter
  bool _requirePostal(
    String label,
    String value,
    RxString errorTarget,
    FocusNode focusNode,
  ) {
    if (!CanadianPostalCodeFormatter.isValid(value)) {
      errorTarget.value = "Enter a valid $label like M8V 1E2";
      config.showToastFailure(errorTarget.value);
      focusNode.requestFocus();

      return false;
    }
    return true;
  }

  bool _requireDate(
    String label,
    RxString v,
    RxString errorTarget,
    FocusNode focusNode,
  ) {
    if (v.value.isEmpty) {
      errorTarget.value = "$label is required";
      config.showToastFailure(errorTarget.value);
      focusNode.requestFocus();

      return false;
    }
    return true;
  }

  bool _requireList<T>(
    String label,
    List<T> list,
    RxString errorTarget,
    FocusNode focusNode,
  ) {
    if (list.isEmpty) {
      errorTarget.value = "Please select $label";
      config.showToastFailure(errorTarget.value);
      focusNode.requestFocus();

      return false;
    }
    return true;
  }

  bool phoneSubmit(text) {
    if (!_requireText("Phone", phoneController.text, phoneError, phoneNode)) {
      return false;
    }
    if (!_isPhone(phoneController.text)) {
      phoneError.value = "Enter a valid phone number";
      phoneNode.requestFocus();
      return false;
    }
    return true;
  }

  bool _validatePersonalStep1() {
    // clearFocus();
    // Basic identity
   /* if (!_requireText(
      "First name",
      firstNameController.text,
      firstNameError,
      firstNameNode,
    )) {
      return false;
    }
    if (!_requireText(
      "Last name",
      lastNameController.text,
      lastNameError,
      lastNameNode,
    )) {
      return false;
    }
    if (!_requireDate("Date of birth", dob, dobError, dobNode)) return false;
*/
    // Current address (all required)
    if (!_requireText(
      "Current Address Line 1",
      currentAddress1Controller.text,
      currentAddress1Error,
      currentAddress1Node,
    )) {
      return false;
    }
    if (!_requireText(
      "Current City",
      currentCityController.text,
      currentCityError,
      currentCityNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Current Province",
      currentState,
      currentStateError,
      currentStateNode,
    )) {
      return false;
    }
    if (!_requirePostal(
      "Current Postal Code",
      currentPostalCodeController.text,
      currentPostalCodeError,
      currentPostalCodeNode,
    )) {
      return false;
    }

    // If not same address on Dec 31, require the Dec 31 address block
    final differentAddress = sameAddress.value == "No";
    if (differentAddress) {
      if (!_requireText(
        "Address Line 1 (Dec 31, 2024)",
        address1Controller.text,
        address1Error,
        address1Node,
      )) {
        return false;
      }
      if (!_requireText(
        "City (Dec 31, 2024)",
        cityController.text,
        cityError,
        cityNode,
      )) {
        return false;
      }
      if (!_requireDropdownStr(
        "Province (Dec 31, 2024)",
        state,
        stateError,
        stateNode,
      )) {
        return false;
      }
      if (!_requirePostal(
        "Postal Code (Dec 31, 2024)",
        postalCodeController.text,
        postalCodeError,
        postalCodeNode,
      )) {
        return false;
      }
    }

    // Contact
    /*if (!_requireText("Phone", phoneController.text, phoneError, phoneNode)) {
      return false;
    }
    if (!_isPhone(phoneController.text)) {
      phoneError.value = "Enter a valid phone number";
      phoneNode.requestFocus();
      return false;
    }
    if (!_requireText("Email", emailController.text, emailError, emailNode)) {
      return false;
    }
    if (!_isEmail(emailController.text)) {
      emailError.value = "Enter a valid email address";
      emailNode.requestFocus();
      return false;
    }

    // SIN (required)
    if (!_requireText(
      "Social Insurance Number",
      sinController.text,
      sinError,
      sinNode,
    )) {
      return false;
    }
    final sinDigits = sinController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (!_isValidSIN(sinDigits)) {
      sinError.value = "Enter a valid 9-digit SIN";
      config.showToastFailure(sinError.value);
      sinNode.requestFocus();

      return false;
    }
*/
    // Dropdowns
    if (!_requireDropdownStr(
      "Same Address",
      sameAddress,
      sameAddressError,
      sameAddressNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Status of Residence",
      statusOfResidence,
      residencyStatusError,
      residencyStatusNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Marital Status",
      maritalStatus,
      maritalStatusError,
      maritalStatusNode,
    )) {
      return false;
    }

    // Spouse details if Married
    final married = maritalStatus.value == "Married";
    if (married) {
      if (!_requireDropdownStr(
        "Is your spouse in Canada (Yes/No)",
        spouseStatus,
        spouseStatusError,
        spouseStatusNode,
      )) {
        return false;
      }

      // If spouse exists (either way), you said these are required:
      if (!_requireText(
        "Spouse First Name",
        spouseFirstNameController.text,
        spouseFirstNameError,
        spouseFirstNameNode,
      )) {
        return false;
      }
      if (!_requireText(
        "Spouse Last Name",
        spouseLastNameController.text,
        spouseLastNameError,
        spouseLastNameNode,
      )) {
        return false;
      }
      if (!_requireDate(
        "Spouse DOB",
        spouseDob,
        spouseDobError,
        spouseDobNode,
      )) {
        return false;
      }
    }

    // Marital status change
    if (!_requireText(
      "Marital Status Change",
      maritalStatusChange.value,
      maritalStatusChangeError,
      maritalStatusChangeNode,
    )) {
      return false;
    }
    if (maritalStatusChange.value == "Yes") {
      if (!_requireDate(
        "Date of marital status change",
        maritalStatusDate,
        maritalStatusChangeDateError,
        maritalStatusChangeDateNode,
      )) {
        return false;
      }
    }

    // First time filing => arrival date required
    if (firstTimeFilling.value == "Yes") {
      if (!_requireDate(
        "Date of Arrival",
        dateArrival,
        arrivalDateError,
        dateOfArrivalNode,
      )) {
        return false;
      }
    }

    // Filing earlier years => at least one year
    if (fileForEarlier.value == "Yes") {
      if (!_requireList(
        "at least one previous tax year",
        selectedYears,
        taxYearsError,
        taxYearsNode,
      )) {
        return false;
      }
    }

    return true;
  }

  bool _validateBusinessStep1() {
    // clearFocus();
    if (!_requireText(
      "Corporation Name",
      corporationNameController.text,
      corporationNameError,
      corporationNameNode,
    )) {
      return false;
    }
    if (!_requireText(
      "Corporation Number",
      corporationNumberController.text,
      corporationNumberError,
      corporationNumberNode,
    )) {
      return false;
    }
    if (!_requireList(
      "Corporation Type",
      selectedCorporationType,
      corporationTypeError,
      corporationTypeNode,
    )) {
      return false;
    }

    if (!_requireText(
      "Business Address Line 1",
      businessAddress1Controller.text,
      businessAddress1Error,
      businessAddress1Node,
    )) {
      return false;
    }
    if (!_requireText(
      "Business City",
      businessCityController.text,
      businessCityError,
      businessCityNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Business Province",
      businessState,
      businessStateError,
      businessStateNode,
    )) {
      return false;
    }
    if (!_requirePostal(
      "Business Postal Code",
      businessPostalCodeController.text,
      businessPostalCodeError,
      businessPostalCodeNode,
    )) {
      return false;
    }

    if (!_requireText(
      "Incorporation Date",
      incorporationDateController.text,
      incorporationDateError,
      incorporationDateNode,
    )) {
      return false;
    }
    if (!_requireText(
      "Business Number",
      businessNumberController.text,
      businessNumberError,
      businessNumberNode,
    )) {
      return false;
    }
    if (!_requireText(
      "Business Activity",
      businessActivityController.text,
      businessActivityError,
      businessActivityNode,
    )) {
      return false;
    }

    if (!_requireList("Tax File", selectedTaxFile, taxFileError, taxFileNode)) {
      return false;
    }

    if (fileForEarlier.value == "Yes") {
      if (!_requireList(
        "at least one previous tax year",
        selectedYears,
        taxYearsError,
        taxYearsNode,
      )) {
        return false;
      }
    }
    return true;
  }

  bool _validateBusinessStep2() {
    // clearFocus();
    // Basic identity
    if (!_requireText(
      "First name",
      firstNameController.text,
      firstNameError,
      firstNameNode,
    )) {
      return false;
    }
    if (!_requireText(
      "Last name",
      lastNameController.text,
      lastNameError,
      lastNameNode,
    )) {
      return false;
    }
    if (!_requireDate("Date of birth", dob, dobError, dobNode)) return false;

    // Current address (all required)
    if (!_requireText(
      "Current Address Line 1",
      currentAddress1Controller.text,
      currentAddress1Error,
      currentAddress1Node,
    )) {
      return false;
    }
    if (!_requireText(
      "Current City",
      currentCityController.text,
      currentCityError,
      currentCityNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Current Province",
      currentState,
      currentStateError,
      currentStateNode,
    )) {
      return false;
    }
    if (!_requirePostal(
      "Current Postal Code",
      currentPostalCodeController.text,
      currentPostalCodeError,
      currentPostalCodeNode,
    )) {
      return false;
    }

    // Contact
    if (!_requireText("Phone", phoneController.text, phoneError, phoneNode)) {
      return false;
    }
    if (!_isPhone(phoneController.text)) {
      phoneError.value = "Enter a valid phone number";
      phoneNode.requestFocus();
      return false;
    }
    if (!_requireText("Email", emailController.text, emailError, emailNode)) {
      return false;
    }
    if (!_isEmail(emailController.text)) {
      emailError.value = "Enter a valid email address";
      emailNode.requestFocus();
      return false;
    }

    // SIN (required)
    if (!_requireText(
      "Social Insurance Number",
      sinController.text,
      sinError,
      sinNode,
    )) {
      return false;
    }
    final sinDigits = sinController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (!_isValidSIN(sinDigits)) {
      sinError.value = "Enter a valid 9-digit SIN";
      config.showToastFailure(sinError.value);
      sinNode.requestFocus();

      return false;
    }

    // Dropdowns
    if (!_requireDropdownStr(
      "Same Address",
      sameAddress,
      sameAddressError,
      sameAddressNode,
    )) {
      return false;
    }
    if (!_requireDropdownStr(
      "Status of Residence",
      statusOfResidence,
      residencyStatusError,
      residencyStatusNode,
    )) {
      return false;
    }

    return true;
  }

  void clearFocus() {
    firstNameNode.dispose();
    middleNameNode.dispose();
    lastNameNode.dispose();
    dobNode.dispose();
    spouseFirstNameNode.dispose();
    spouseMiddleNameNode.dispose();
    spouseLastNameNode.dispose();
    spouseDobNode.dispose();
    maritalStatusChangeDateNode.dispose();
    dateOfArrivalNode.dispose();
    currentAddress1Node.dispose();
    currentAddress2Node.dispose();
    currentCityNode.dispose();
    currentPostalCodeNode.dispose();
    currentStateNode.dispose();
    address1Node.dispose();
    address2Node.dispose();
    cityNode.dispose();
    postalCodeNode.dispose();
    stateNode.dispose();
    phoneNode.dispose();
    emailNode.dispose();
    sinNode.dispose();
    referNode.dispose();
    corporationNameNode.dispose();
    corporationNumberNode.dispose();
    corporationTypeNode.dispose();
    businessAddress1Node.dispose();
    businessAddress2Node.dispose();
    businessCityNode.dispose();
    businessPostalCodeNode.dispose();
    businessStateNode.dispose();
    incorporationDateNode.dispose();
    businessNumberNode.dispose();
    businessActivityNode.dispose();
    sameAddressNode.dispose();
    residencyStatusNode.dispose();
    maritalStatusNode.dispose();
    spouseStatusNode.dispose();
    maritalStatusChangeNode.dispose();
    taxFileNode.dispose();
    taxYearsNode.dispose();
    dependentChildrenNode.dispose();
    dependentParentNode.dispose();
    firstTimeFillingNode.dispose();
    fileForEarlierNode.dispose();
    craAccountNode.dispose();
    businessAccountNode.dispose();
    salariedEmployeesNode.dispose();
    studyOptionsNode.dispose();
    investmentExpensesNode.dispose();
    businessRentingPropertyNode.dispose();
    acknowledgmentNode.dispose();
  }
}
