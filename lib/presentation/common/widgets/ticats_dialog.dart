import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

showDeleteDialog(BuildContext context, int ticketId) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            scrollable: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            elevation: 0,
            content: Padding(
              padding: EdgeInsets.only(top: 60.w),
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Text("티켓을 삭제하시겠어요?\n삭제한 티켓은 복구되지 않습니다.", style: AppTypeFace.xSmall16SemiBold, textAlign: TextAlign.center),
                    SizedBox(height: 36.w),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => Get.back(),
                            child: Container(
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: AppColor.grayE5,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(14.r),
                                ),
                              ),
                              child: Center(
                                child: Text("아니요", style: AppTypeFace.small18SemiBold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await Get.find<TicketController>().deleteTicket(ticketId);
                              Get.back();
                            },
                            child: Container(
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: AppColor.systemPositiveBlue,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(14.r),
                                ),
                              ),
                              child: Center(
                                child: Text("네", style: AppTypeFace.small18SemiBold.copyWith(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 50.w,
            top: -210.w,
            child: Align(alignment: Alignment.centerLeft, child: SvgPicture.asset('assets/cats/cat_eyes.svg')),
          ),
        ],
      );
    },
  );
}

showLogoutDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollable: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        elevation: 0,
        content: Padding(
          padding: EdgeInsets.only(top: 36.h),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Text("로그아웃 하시겠어요?", style: AppTypeFace.xSmall16SemiBold, textAlign: TextAlign.center),
                SizedBox(height: 36.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.back(),
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColor.grayE5,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14.r),
                            ),
                          ),
                          child: Center(
                            child: Text("취소", style: AppTypeFace.small18SemiBold),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          AuthService.to.logout();
                          Get.find<MainController>().changePage(0);
                          Get.back();
                        },
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColor.systemPositiveBlue,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(14.r),
                            ),
                          ),
                          child: Center(
                            child: Text("확인", style: AppTypeFace.small18SemiBold.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
