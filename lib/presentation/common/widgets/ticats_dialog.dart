import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_const.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/app/util/email_util.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

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
                            onTap: () => Get.back(result: false),
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
                              Get.back(result: true);
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
            top: -180.w,
            child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/cats/cat_eyes.svg',
                  width: 142.w,
                  height: 87.w,
                  fit: BoxFit.cover,
                )),
          ),
        ],
      );
    },
  );
}

Future<void> showErrorDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: const Text('이메일 전송 실패'),
        content: const Text('기본 메일 앱을 사용할 수 없어요.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요.\n\n${AppConst.ticatsEmail}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
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
                        onTap: () async {
                          Get.toNamed(RoutePath.login);

                          Get.find<HomeController>().tabIndex.value = 0;
                          Get.find<MainController>().changePage(0);

                          await AuthService.to.logout();
                          await Get.find<TicketController>().getTickets();
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

showPostTicketDialog(BuildContext context) async {
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
              padding: EdgeInsets.only(top: 40.w),
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Text("짜잔~\n티켓을 완성했어요!", style: AppTypeFace.xSmall16SemiBold, textAlign: TextAlign.center),
                    SizedBox(height: 12.w),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Get.find<MakeTicketController>().isPrivate.value = !Get.find<MakeTicketController>().isPrivate.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(11.w),
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: Obx(
                                () => Checkbox(
                                  activeColor: AppColor.systemPositiveBlue,
                                  value: Get.find<MakeTicketController>().isPrivate.value,
                                  onChanged: (value) => Get.find<MakeTicketController>().isPrivate.value = value!,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 24.w),
                            child: Text("나만 보기", style: AppTypeFace.small18SemiBold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.w),
                    GetX<MakeTicketController>(builder: (controller) {
                      return GestureDetector(
                        onTap: () async {
                          try {
                            controller.isUploading.value = true;
                            await controller.postTicket();
                            await Get.find<TicketController>().getTickets();
                            controller.isUploading.value = false;

                            Get.back(result: true);
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 56.w,
                          decoration: BoxDecoration(
                            color: AppColor.primaryDark,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14.r),
                              bottomRight: Radius.circular(14.r),
                            ),
                          ),
                          child: Center(
                            child: controller.isUploading.value
                                ? const CircularProgressIndicator()
                                : Text("내 티켓 저장하기", style: AppTypeFace.small18SemiBold.copyWith(color: Colors.white)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            left: 50.w,
            top: -310.w,
            child: Align(alignment: Alignment.center, child: SvgPicture.asset('assets/cats/cat_enjoy.svg')),
          ),
        ],
      );
    },
  );
}

showReportDialog(BuildContext context, Ticket ticket) async {
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
              padding: EdgeInsets.only(top: 60.h),
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Text("티켓을 신고하시겠어요?\n불쾌감을 주는 이미지는 신고 사유에 해당됩니다.", style: AppTypeFace.xSmall16SemiBold, textAlign: TextAlign.center),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
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
                        Flexible(
                          flex: 6,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              try {
                                Get.back();
                                await EmailUtil().sendReportEmail('', '');
                              } catch (e) {
                                debugPrint(e.toString());
                                if (context.mounted) await showErrorDialog(context);
                              }
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
                                child: Text("신고 메일 보내기", style: AppTypeFace.small18SemiBold.copyWith(color: Colors.white)),
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
            top: -180.w,
            child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/cats/cat_eyes.svg',
                  width: 142.w,
                  height: 87.w,
                  fit: BoxFit.cover,
                )),
          ),
        ],
      );
    },
  );
}

showTextDialog(BuildContext context, String text) async {
  return await context.showToast(
    Text(text),
    duration: const Duration(milliseconds: 3500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
    queue: true,
    backgroundColor: Colors.black,
    textStyle: AppTypeFace.xSmall14Medium.copyWith(color: Colors.white),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
    alignment: Alignment.bottomCenter,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 82.h),
  );
}
