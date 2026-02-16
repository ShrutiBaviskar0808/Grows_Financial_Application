import 'package:get/get.dart';
import 'package:growsfinancial/screens/dashboard_screen.dart';
import 'package:growsfinancial/screens/document_requests_screen.dart';
import 'package:growsfinancial/screens/documents_screen.dart';
import 'package:growsfinancial/screens/file_details_screen.dart';
import 'package:growsfinancial/screens/files_screen.dart';
import 'package:growsfinancial/screens/form_step_screen.dart';
import 'package:growsfinancial/screens/form_t1_step1_screen.dart';
import 'package:growsfinancial/screens/form_t1_step2_screen.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/form_t1_step3_screen.dart';
import 'package:growsfinancial/screens/form_t2_step1_screen.dart';
import 'package:growsfinancial/screens/form_t2_step2_screen.dart';
import 'package:growsfinancial/screens/form_year_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/screens/login_screen.dart';
import 'package:growsfinancial/screens/no_internet_screen.dart';
import 'package:growsfinancial/screens/bookkeeping_form_screen.dart';
import 'package:growsfinancial/screens/profile_screen.dart';
import 'package:growsfinancial/screens/register_screen.dart';
import 'package:growsfinancial/screens/reset_password_screen.dart';
import 'package:growsfinancial/screens/service_inquiry_form.dart';
import 'package:growsfinancial/screens/services_screen.dart';
import 'package:growsfinancial/screens/splash_screen.dart';
import 'package:growsfinancial/screens/upload_documents_screen.dart';
import 'package:growsfinancial/undefined_view.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(name: SplashScreen.id, page: () => const SplashScreen()),
    GetPage(name: NoInternetScreen.id, page: () => const NoInternetScreen()),
    GetPage(name: HomeScreen.id, page: () => HomeScreen()),
    GetPage(name: LoginScreen.id, page: () => LoginScreen()),
    GetPage(name: RegisterScreen.id, page: () => RegisterScreen()),
    GetPage(name: ProfileScreen.id, page: () => ProfileScreen()),
    GetPage(name: ResetPasswordScreen.id, page: () => ResetPasswordScreen()),
    GetPage(name: DashboardScreen.id, page: () => DashboardScreen()),
    GetPage(name: AccountsScreen.id, page: () => AccountsScreen()),
    GetPage(
      name: DocumentRequestsScreen.id,
      page: () => DocumentRequestsScreen(),
    ),
    GetPage(
      name: UploadDocumentsScreen.id,
      page: () => UploadDocumentsScreen(),
    ),
    GetPage(name: DocumentsScreen.id, page: () => DocumentsScreen()),
    GetPage(name: ServicesScreen.id, page: () => ServicesScreen(arguments: {})),
    GetPage(name: FilesScreen.id, page: () => FilesScreen(arguments: {},)),
    GetPage(name: FileDetailsScreen.id, page: () => FileDetailsScreen()),
    GetPage(name: FormStepScreen.id, page: () => FormStepScreen()),
    GetPage(name: FormYearScreen.id, page: () => FormYearScreen()),
    GetPage(name: FormT1Step1Screen.id, page: () => FormT1Step1Screen()),
    GetPage(name: FormT1Step2Screen.id, page: () => FormT1Step2Screen()),
    GetPage(name: FormT1Step3Screen.id, page: () => FormT1Step3Screen()),
    GetPage(name: FormT2Step1Screen.id, page: () => FormT2Step1Screen()),
    GetPage(name: FormT2Step2Screen.id, page: () => FormT2Step2Screen()),
    GetPage(
      name: BookKeepingFormScreen.id,
      page: () => BookKeepingFormScreen(),
    ),
    GetPage(name: ServiceInquiryScreen.id, page: () => ServiceInquiryScreen()),
    GetPage(
      name: '/undefined',
      page: () => const UndefinedView(name: 'Undefined Route'),
    ),
  ];
}
