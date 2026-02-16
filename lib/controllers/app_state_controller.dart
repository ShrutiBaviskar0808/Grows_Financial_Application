import 'dart:developer';

import 'package:get/get.dart';

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:growsfinancial/service/push_notification_manager.dart';

class AppStateController extends GetxController {
  PushNotificationsManager notificationsManager = PushNotificationsManager();
  StreamSubscription? _sub;

  @override
  void onReady() {
    super.onReady();
    _initUniLinks();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // request permission / token / local notification setup / routing
    notificationsManager.localNotificationInit();
    notificationsManager.configNotificationRouting();
  }

  Future<void> _initUniLinks() async {
    try {
      final appLinks = AppLinks();
      _sub = appLinks.uriLinkStream.listen(
        (Uri? link) {
          if (link != null) {
            if (link.toString().contains('success')) {
              log("Payment Successful");
            } else if (link.toString().contains('cancel')) {
              log("Payment Failed");
            }
          }
        },
        onError: (err) {
          log("Error in link stream: $err");
        },
      );
    } catch (e) {
      log("Error initializing uni links: $e");
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
