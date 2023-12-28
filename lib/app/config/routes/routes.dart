import 'package:get/get.dart';
import 'package:ticats/presentation/login/binding/login_binding.dart';
import 'package:ticats/presentation/login/pages/alter_login_page.dart';
import 'package:ticats/presentation/login/pages/login_page.dart';
import 'package:ticats/presentation/main/controller/main_binding.dart';
import 'package:ticats/presentation/main/pages/main_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_info_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_layout_page.dart';
import 'package:ticats/presentation/make_ticket/pages/make_ticket_result_page.dart';
import 'package:ticats/presentation/my_page/pages/inquery_page.dart';
import 'package:ticats/presentation/my_page/pages/like_page.dart';
import 'package:ticats/presentation/my_page/pages/my_statistics_page.dart';
import 'package:ticats/presentation/my_page/pages/notice_page.dart';
import 'package:ticats/presentation/my_page/pages/resign_page.dart';
import 'package:ticats/presentation/register/controller/register_binding.dart';
import 'package:ticats/presentation/register/pages/register_profile_page.dart';
import 'package:ticats/presentation/register/pages/request_permission_page.dart';
import 'package:ticats/presentation/home/pages/select_category_page.dart';
import 'package:ticats/presentation/register/pages/term_agree_page.dart';
import 'package:ticats/presentation/register/pages/term_detail_page.dart';

import 'route_path.dart';

class Routes {
  static List<GetPage> routes = [
    // Home
    GetPage(
      name: RoutePath.selectCategory,
      page: () => const SelectCategoryPage(),
    ),

    // Login
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RoutePath.alterLogin,
      page: () => const AlterLoginPage(),
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

    // My Page
    GetPage(
      name: RoutePath.notice,
      page: () => const NoticePage(),
    ),
    GetPage(
      name: RoutePath.noticeDetail,
      page: () => NoticeDetailPage(),
    ),
    GetPage(
      name: RoutePath.like,
      page: () => const LikePage(),
    ),
    GetPage(
      name: RoutePath.inquery,
      page: () => const InqueryPage(),
    ),
    GetPage(
      name: RoutePath.resign,
      page: () => const ResignPage(),
    ),
    GetPage(
      name: RoutePath.statistics,
      page: () => const StatisticsPage(),
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
  ];
}
