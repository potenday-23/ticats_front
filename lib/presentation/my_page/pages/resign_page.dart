import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/my_page/controller/resign_controller.dart';

class ResignPage extends GetView<ResignController> {
  const ResignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CloseAppBar(title: "회원 탈퇴"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36.h),
              Text("${AuthService.to.member!.member!.nickname}님과 이별인가요..?\n너무 아쉬워요.", style: AppTypeFace.small20Bold),
              SizedBox(height: 16.h),
              Text("계정을 삭제하면, 내가 만든 티켓과 정보 등\n모든 활동 정보가 사라지게 됩니다.", style: AppTypeFace.xSmall16SemiBold),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Obx(
                        () => Checkbox(
                          activeColor: AppColor.systemPositiveBlue,
                          value: controller.isResignAgree.value,
                          onChanged: (value) => controller.isResignAgree.value = value!,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => controller.isResignAgree.value = !controller.isResignAgree.value,
                      child: Text("회원 탈퇴 유의사항을 확인했으며 이에 동의합니다.", style: AppTypeFace.xSmall14Medium)),
                ],
              ),
              SizedBox(height: 36.h),
              Row(
                children: [
                  Text(
                    "계정을 삭제하시려는 이유를 알려주세요.",
                    style: AppTypeFace.xSmall16SemiBold,
                  ),
                  const Spacer(),
                  Text("중복 선택 가능", style: AppTypeFace.xSmall12Regular.copyWith(color: AppColor.systemPositiveBlue)),
                ],
              ),
              SizedBox(height: 16.h),
              const _ReasonButton("만들고 싶은 티켓이 없어요", id: 1),
              SizedBox(height: 16.h),
              const _ReasonButton("티켓 커스텀 기능이 아쉬워요", id: 2),
              SizedBox(height: 16.h),
              const _ReasonButton("더 좋은 어플을 찾았어요", id: 3),
              SizedBox(height: 16.h),
              const _ReasonButton("계정을 새로 만들고 싶어요", id: 4),
              SizedBox(height: 16.h),
              const _ReasonButton("기타", id: 5),
              SizedBox(height: 33.h),
              Obx(
                () => TicatsButton(
                  onPressed: () async => controller.postResign(),
                  color: controller.isResignAgree.value && controller.resignReasonList.isNotEmpty
                      ? AppColor.systemPositiveBlue
                      : AppColor.grayE5,
                  child: Text("탈퇴하기", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonButton extends GetView<ResignController> {
  const _ReasonButton(this.text, {required this.id});

  final int id;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (controller.resignReasonList.contains(id)) {
            controller.resignReasonList.remove(id);
          } else {
            controller.resignReasonList.add(id);
          }
        },
        child: Container(
          width: double.maxFinite,
          height: 42.h,
          decoration: BoxDecoration(
            border: controller.resignReasonList.contains(id) ? null : Border.all(color: AppColor.grayE5),
            borderRadius: BorderRadius.circular(16.r),
            color: controller.resignReasonList.contains(id) ? AppColor.systemPositiveBlue : null,
          ),
          child: Center(
            child: Text(
              text,
              style: AppTypeFace.xSmall14Medium.copyWith(color: controller.resignReasonList.contains(id) ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
