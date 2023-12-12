import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';

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
      leadingWidth: 48.w,
      leading: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.w, 0, 16.w),
        child: SvgPicture.asset('assets/icons/category.svg', width: 24.w, height: 24.w),
      ),

      // title tabbar
      centerTitle: true,
      title: TabBar(
        // Misc
        controller: controller.tabController,
        tabs: controller.tabs,
        isScrollable: true,
        padding: EdgeInsets.zero,

        // label Decoration
        labelColor: Colors.black,
        labelStyle: AppTypeFace.smallBold,

        // unselectedLabel Decoration
        unselectedLabelColor: AppColor.gray8E,
        unselectedLabelStyle: AppTypeFace.smallBold,

        // divider & indicator Decoration
        dividerColor: Colors.transparent,
        indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2)),
        indicatorPadding: EdgeInsets.symmetric(horizontal: -8.w),
        indicatorColor: Colors.transparent,

        splashFactory: NoSplash.splashFactory,
      ),

      // actions
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16.w, 24.w, 16.w),
          child: GestureDetector(onTap: () {}, child: SvgPicture.asset('assets/icons/search.svg', width: 24.w, height: 24.w)),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}
