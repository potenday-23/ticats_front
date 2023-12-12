import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';

import '../controller/main_controller.dart';

class MainBottomNavBar extends GetView<MainController> {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).padding.bottom + 66.w,
      child: const Column(
        children: [
          Divider(height: 1, color: Color(0xFFE5E5EA)),
          Row(
            children: [
              _NavBarItem("홈", index: 0, iconName: 'home'),
              _NavBarItem("티켓 만들기", index: 1, iconName: 'ticats'),
              _NavBarItem("마이페이지", index: 2, iconName: 'person'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends GetView<MainController> {
  const _NavBarItem(this.title, {required this.index, required this.iconName});

  final String title;
  final int index;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => controller.changePage(index),
          child: Column(children: [
            SizedBox(height: 8.h),
            SvgPicture.asset(
              controller.selectedIndex == index ? 'assets/icons/${iconName}_active.svg' : 'assets/icons/$iconName.svg',
              width: 24.w,
              height: 24.w,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTypeFace.xSmallBold.copyWith(
                color: controller.selectedIndex == index ? AppColor.primaryDark : AppColor.gray63,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
