import 'package:get/get.dart';
import 'package:pjspaul_admin/route/app_routes.dart';
import 'package:pjspaul_admin/view/page/login/login_screen.dart';
import 'package:pjspaul_admin/view/page/main/main_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
     GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
    ),
  ];
}
