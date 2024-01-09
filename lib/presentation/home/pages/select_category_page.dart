import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';

class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text("관심 있는 카테고리를 선택해주세요.", style: AppTypeFace.small20Bold),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 24.h,
                children: [for (final Category category in TicatsService.to.ticatsCategories) _CategorySelectWidget(category)],
              ),
              SizedBox(height: 23.h),
              TicatsButton(
                child: Text("저장하기", style: AppTypeFace.small18Bold.copyWith(color: Colors.white)),
                onPressed: () async => await Get.find<HomeController>().saveCategory(),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 29.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySelectWidget extends GetView<HomeController> {
  const _CategorySelectWidget(this.category);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (controller.categoryList.contains(category.name)) {
            controller.categoryList.remove(category.name);
          } else {
            controller.categoryList.add(category.name);
          }
        },
        child: controller.categoryList.contains(category.name)
            ? Stack(
                children: [
                  CachedNetworkImage(imageUrl: category.clickImage, width: 163.w, height: 121.h, fit: BoxFit.contain),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(category.name, style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  CachedNetworkImage(imageUrl: category.basicImage, width: 163.w, height: 121.h, fit: BoxFit.contain),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(category.name, style: AppTypeFace.small20Bold),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
