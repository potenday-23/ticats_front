import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/permission_service.dart';
import 'package:ticats/presentation/common/enum/term_type.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_checkbox.dart';

import '../controller/register_controller.dart';

class TermAgreePage extends StatelessWidget {
  const TermAgreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36.h),
              Text("원활한 서비스 이용을 위해\n약관에 동의해주세요.", style: AppTypeFace.small20Bold),
              SizedBox(height: 26.h),
              const _BuildTermCheckBox(),
              const Spacer(),
              GetX<RegisterController>(
                builder: (controller) {
                  return TicatsButton(
                    onPressed: () async {
                      if (controller.isRequiredAgree) {
                        if (await PermissionService.to.checkPhotoPermission()) {
                          Get.toNamed(RoutePath.registerProfile);
                        } else {
                          Get.toNamed(RoutePath.requestPermssion);
                        }
                      }
                    },
                    color: controller.isRequiredAgree ? null : AppColor.grayC7,
                    child: Text("다음", style: AppTypeFace.small18Bold.copyWith(color: Colors.white)),
                  );
                },
              ),
              SizedBox(height: 86.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTermCheckBox extends GetView<RegisterController> {
  const _BuildTermCheckBox();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(children: [
        GestureDetector(
          onTap: () => controller.setAllAgree(),
          child: Row(
            children: [
              TicatsCheckBox(value: controller.isAllAgree, onChanged: (value) => controller.setAllAgree()),
              Text("모두 동의합니다.", style: AppTypeFace.small18SemiBold),
            ],
          ),
        ),
        Divider(height: 1.h, color: const Color(0xFFE5E5EA)),
        SizedBox(height: 14.h),
        for (TermType term in TermType.values) _TermCheckBoxWidget(index: term.index, termType: term),
      ]);
    });
  }
}

class _TermCheckBoxWidget extends GetView<RegisterController> {
  const _TermCheckBoxWidget({required this.index, required this.termType});

  final int index;
  final TermType termType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.isAgreeList[index] = !controller.isAgreeList[index],
          child: Row(
            children: [
              TicatsCheckBox(
                value: controller.isAgreeList[index],
                onChanged: (value) => controller.isAgreeList[index] = !controller.isAgreeList[index],
              ),
              Row(
                children: [
                  Text(termType.isRequired ? "[필수] " : "[선택] ", style: AppTypeFace.xSmall14Medium),
                  Text(termType.termName, style: AppTypeFace.xSmall14Medium),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 14.w),
        GestureDetector(
          onTap: () => Get.toNamed(RoutePath.termDetail, arguments: termType),
          child: Text("보기", style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.gray8E)),
        ),
      ],
    );
  }
}
