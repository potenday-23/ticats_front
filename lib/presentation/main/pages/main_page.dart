import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.selectedIndex]),
      bottomNavigationBar: const _TicatsBottomNavBar(),
    );
  }
}

class _TicatsBottomNavBar extends GetView<MainController> {
  const _TicatsBottomNavBar();

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
              _TicatsNavItem("홈", index: 0, iconName: 'home'),
              _TicatsNavItem("티켓 만들기", index: 1, iconName: 'ticats'),
              _TicatsNavItem("마이페이지", index: 2, iconName: 'person'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicatsNavItem extends GetView<MainController> {
  const _TicatsNavItem(this.title, {required this.index, required this.iconName});

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
