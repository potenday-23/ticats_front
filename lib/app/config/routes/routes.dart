import 'package:get/get.dart';
import 'package:ticats/presentation/login/binding/login_binding.dart';
import 'package:ticats/presentation/login/pages/login_page.dart';
import 'package:ticats/presentation/main/controller/main_binding.dart';
import 'package:ticats/presentation/main/pages/main_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_info_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_layout_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_result_page.dart';
import 'package:ticats/presentation/register/controller/register_binding.dart';
import 'package:ticats/presentation/register/pages/register_profile_page.dart';
import 'package:ticats/presentation/register/pages/request_permission_page.dart';
import 'package:ticats/presentation/register/pages/select_category_page.dart';
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

    // Main
    GetPage(
      name: RoutePath.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    // Make Ticket
    GetPage(
      name: RoutePath.makeTicketInfo,
      page: () => const MakeTicketInfoPage(),
    ),
    GetPage(
      name: RoutePath.makeTicketLayout,
      page: () => const MakeTicketLayoutPage(),
    ),
    GetPage(
      name: RoutePath.makeTicketResult,
      page: () => MakeTicketResultPage(),
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
    GetPage(
      name: RoutePath.requestPermssion,
      page: () => const RequestPermissionPage(),
    ),
    GetPage(
      name: RoutePath.registerProfile,
      page: () => const RegisterProfilePage(),
    ),
    GetPage(
      name: RoutePath.selectCategory,
      page: () => const SelectCategoryPage(),
    ),
  ];
}
