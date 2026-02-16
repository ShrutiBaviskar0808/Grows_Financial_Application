import 'package:get/get.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/controllers/app_state_controller.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/controllers/form_controller.dart';
import 'package:growsfinancial/controllers/bookkeeping_form_controller.dart';
import 'package:growsfinancial/controllers/service_inquiry_controller.dart';
import 'package:growsfinancial/controllers/services_controller.dart';

// Import other controllers as needed
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Load all controllers eagerly
    Get.put<AppStateController>(AppStateController());
    Get.lazyPut<BackdropNavController>(
      () => BackdropNavController(),
      fenix: true,
    );
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<AccountController>(() => AccountController(), fenix: true);
    Get.lazyPut<ServicesController>(() => ServicesController(), fenix: true);
    Get.lazyPut<FormController>(() => FormController(), fenix: true);
    Get.lazyPut<BookkeepingFormController>(
      () => BookkeepingFormController(),
      fenix: true,
    );
    Get.lazyPut<ServiceInquiryController>(
      () => ServiceInquiryController(),
      fenix: true,
    );
  }
}
