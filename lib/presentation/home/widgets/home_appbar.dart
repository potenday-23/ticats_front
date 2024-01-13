import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

import '../controller/home_controller.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.grayF9,
      automaticallyImplyLeading: false,
      toolbarHeight: 56.w,

      // leading
      leadingWidth: 72.w,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
        child: GestureDetector(
          onTap: () => Get.toNamed(RoutePath.selectCategory),
          child: SvgPicture.asset('assets/icons/category.svg', width: 24.w, height: 24.w),
        ),
      ),

      // title tabbar
      centerTitle: true,
      title: TabBar(
        onTap: (value) {
          TicketController ticketController = Get.find<TicketController>();

          if (value == 0 && controller.oldTabIndex.value == 0 && ticketController.totalTicketList.isNotEmpty) {
            controller.totalPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else if (value == 1 && controller.oldTabIndex.value == 1 && ticketController.myTicketList.isNotEmpty) {
            controller.myPageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        },
        // Misc
        controller: controller.tabController,
        tabs: controller.tabs,
        isScrollable: true,
        padding: EdgeInsets.zero,
        tabAlignment: TabAlignment.center,

        // label Decoration
        labelColor: Colors.black,
        labelStyle: AppTypeFace.small18Bold,

        // unselectedLabel Decoration
        unselectedLabelColor: AppColor.gray8E,
        unselectedLabelStyle: AppTypeFace.small18Bold,

        // divider & indicator Decoration
        dividerColor: Colors.transparent,
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2)),
        indicatorPadding: EdgeInsets.symmetric(horizontal: -8.w),
        indicatorColor: Colors.transparent,

        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),

      // actions
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
          child: GestureDetector(
            onTap: () => Get.toNamed(RoutePath.searchTicket),
            child: SvgPicture.asset('assets/icons/search.svg', width: 24.w, height: 24.w),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}
