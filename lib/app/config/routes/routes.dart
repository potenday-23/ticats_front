import 'package:get/get.dart';
import 'package:ticats/presentation/home/pages/home_page.dart';
import 'package:ticats/presentation/login/binding/login_binding.dart';
import 'package:ticats/presentation/login/pages/login_page.dart';
import 'package:ticats/presentation/register/controller/register_binding.dart';
import 'package:ticats/presentation/register/pages/term_agree_page.dart';
import 'package:ticats/presentation/register/pages/term_detail_page.dart';

import 'route_path.dart';

class Routes {
  static List<GetPage> routes = [
    // Login
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // Home
    GetPage(
      name: RoutePath.home,
      page: () => const HomePage(),
    ),

    // Register
    GetPage(
      name: RoutePath.termAgree,
      page: () => const TermAgreePage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: RoutePath.termDetail,
      page: () => TermDetailPage(),
    ),
  ];
}
