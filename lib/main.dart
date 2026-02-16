import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/screens/splash_screen.dart';
import 'package:growsfinancial/service/app_bindings.dart';
import 'package:growsfinancial/service/router.dart';
import 'package:growsfinancial/undefined_view.dart';
import 'firebase_options.dart';
import 'service/push_notification_manager.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationsManager = PushNotificationsManager();
  notificationsManager.localNotificationInit();

  log("Handling a background message: ${message.messageId}");

  if (message.data['isScheduled'] == "true") {
    notificationsManager.notificationHandle(message);
  } else {
    notificationsManager.onSelectNotification(message.data['type']);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Grows Financial",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'nunito',
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      initialRoute: SplashScreen.id,
      initialBinding: AppBindings(),
      getPages: AppRoutes.routes,
      navigatorKey: navigatorKey,
      unknownRoute: GetPage(
        name: '/undefined',
        page: () => const UndefinedView(name: 'Undefined Route'),
      ),
    );
  }
}
