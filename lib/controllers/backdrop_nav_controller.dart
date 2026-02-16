import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/document_requests_screen.dart';
import 'package:growsfinancial/screens/files_screen.dart';
import 'package:growsfinancial/screens/profile_screen.dart';
import 'package:growsfinancial/screens/services_screen.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';

class BackdropNavController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();

  var showSpinner = false.obs,
      userData = {}.obs,
      requests = [].obs,
      clientID = "".obs,
      notificationCount = 0.obs;

  // page key (what to render)
  final currentKey = AccountsScreen.id.obs;

  // tab key (what to highlight)
  final activeTabKey = AccountsScreen.id.obs;

  static const String tabHome = AccountsScreen.id;
  static const String tabNotify = DocumentRequestsScreen.id;
  static const String tabWhats = "whatsapp_tab";
  static const String tabProfile = ProfileScreen.id;

  final Map<String, dynamic> args = <String, dynamic>{}.obs;

  final Map<String, Widget Function(Map<String, dynamic>)> _builders = {
    AccountsScreen.id: (_) => AccountsScreen(),
    FilesScreen.id: (a) => FilesScreen(arguments: a),
    ServicesScreen.id: (a) => ServicesScreen(arguments: a),
    DocumentRequestsScreen.id: (_) => DocumentRequestsScreen(),
    ProfileScreen.id: (_) => ProfileScreen(),
    "whatsapp_tab": (_) => const Center(child: Text("WhatsApp")),
  };

  void openPage(String key, {Map<String, dynamic>? arguments}) {
    if (!_builders.containsKey(key)) {
      throw ArgumentError('No screen for key “$key”');
    }

    // ✅ set page
    currentKey.value = key;

    // ✅ set which bottom tab should be active
    if (key == DocumentRequestsScreen.id) {
      activeTabKey.value = tabNotify;
    } else if (key == ProfileScreen.id) {
      activeTabKey.value = tabProfile;
    } else if (key == tabWhats) {
      activeTabKey.value = tabWhats;
    } else {
      // ✅ everything else -> HOME active (including ServicesScreen)
      activeTabKey.value = tabHome;
    }

    args
      ..clear()
      ..addAll(arguments ?? {});
  }

  Widget buildCurrent() {
    final builder = _builders[currentKey.value];
    return builder != null
        ? builder(args)
        : Center(child: Text('No page: ${currentKey.value}'));
  }

  //Back Click
  backClick(didPop, result, BuildContext context) {
    if (didPop) return;
    if (Get.isBottomSheetOpen ?? false) {
      Get.back(); // Close bottom sheet
    }
    if (currentKey.value != AccountsScreen.id) {
      openPage(AccountsScreen.id);
      return;
    } else {
      config.exitAppDialog(context);
    }
  }

  @override
  void onReady() {
    super.onReady();
    getUser();
  }

  void getUser() async {
    try {
      showSpinner.value = true;
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getUser(clientID.value);

        if (response != null && response['result'] == 'success') {
          userData.value = response['data'];
        } else {
          config.showToastFailure(response['msg']);
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    }
    showSpinner.value = false;
    update();
  }

  void getDocumentRequest() async {
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getDocumentRequest(clientID.value);

        if (response != null && response['result'] == 'success') {
          requests.value = response['data'];
        } else {
          requests.value = [];
          // config.showToastFailure(response['msg']);
        }
        notificationCount.value = requests.length;
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
