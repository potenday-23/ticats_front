import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

final ScrollController scrollController = ScrollController();

class MakeTicketLayoutPage extends GetView<MakeTicketController> {
  const MakeTicketLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: "티켓 만들기"),
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(children: [
          const _MakeTicketTabBarWidget(),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.selectedLayoutTabIndex.value == 0) {
              return const _SelectTicketTypeWidget();
            } else if (controller.selectedLayoutTabIndex.value == 1) {
              return const _SelectTicketLayoutWidget();
            } else {
              return const SizedBox();
            }
          }),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            color: AppColor.grayF9,
            child: Center(
              child: Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
                  child: Column(
                    children: [
                      if (controller.selectedLayoutTabIndex.value == 0) ...[
                        SizedBox(width: 342.w, height: 564.w, child: TicketFront(controller.ticket.value)),
                        SizedBox(height: 40.w),
                        TicatsButton(
                          color: AppColor.primaryNormal,
                          child: Text(
                            "다음",
                            style: AppTypeFace.small20Bold.copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            controller.selectedLayoutTabIndex.value = 1;
                            scrollController.animateTo(0, duration: const Duration(microseconds: 2000), curve: Curves.easeIn);
                          },
                        ),
                      ] else if (controller.selectedLayoutTabIndex.value == 1) ...[
                        SizedBox(width: 342.w, height: 564.w, child: TicketBack(controller.ticket.value)),
                        SizedBox(height: 40.w),
                        TicatsButton(
                          color: AppColor.primaryNormal,
                          child: Text("다음", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                          onPressed: () {
                            controller.selectedLayoutTabIndex.value = 2;
                            scrollController.animateTo(0, duration: const Duration(microseconds: 2000), curve: Curves.easeIn);
                          },
                        ),
                      ] else ...[
                        SizedBox(width: 342.w, height: 564.w, child: TicketBack(controller.ticket.value)),
                        SizedBox(height: 40.w),
                        TicatsButton(
                          color: AppColor.primaryNormal,
                          child: Text("완료", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                          onPressed: () async {
                            try {
                              await controller.postTicket(true);
                              Get.offNamedUntil(RoutePath.makeTicketResult, ModalRoute.withName(RoutePath.main));
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        ),
                      ],
                      SizedBox(height: 20.w),
                    ],
                  ),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MakeTicketTabBarWidget extends GetView<MakeTicketController> {
  const _MakeTicketTabBarWidget();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FlutterToggleTab(
        width: 80.w,
        height: 48.h,
        marginSelected: controller.selectedLayoutTabIndex.value == 0
            ? EdgeInsets.fromLTRB(4.w, 4.h, 0, 4.h)
            : controller.selectedLayoutTabIndex.value == 1
                ? EdgeInsets.fromLTRB(0, 4.h, 0, 4.h)
                : EdgeInsets.fromLTRB(0, 4.h, 4.w, 4.h),
        labels: const ["티켓 모양", "레이아웃", "글자 색"],
        icons: [
          controller.selectedLayoutTabIndex.value == 0 ? Icons.check : null,
          controller.selectedLayoutTabIndex.value == 1 ? Icons.check : null,
          controller.selectedLayoutTabIndex.value == 2 ? Icons.check : null,
        ],
        iconSize: 18.w,
        isShadowEnable: false,
        selectedLabelIndex: (index) => controller.selectedLayoutTabIndex.value = index,
        selectedIndex: controller.selectedLayoutTabIndex.value,
        selectedBackgroundColors: const [AppColor.primaryLight],
        selectedTextStyle: AppTypeFace.xSmall14Medium.copyWith(color: Colors.white),
        unSelectedBackgroundColors: const [AppColor.grayF2],
        unSelectedTextStyle: AppTypeFace.xSmall14Medium.copyWith(color: Colors.black),
      ),
    );
  }
}

class _SelectTicketTypeWidget extends GetView<MakeTicketController> {
  const _SelectTicketTypeWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.57.w),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () {
                      controller.selectedTicketTypeIndex.value = i;
                      controller.makeTicket();
                    },
                    child: SvgPicture.asset(
                      controller.selectedTicketTypeIndex.value == i
                          ? "assets/tickets/ticket_${i}_icon_active.svg"
                          : "assets/tickets/ticket_${i}_icon.svg",
                      width: 61.w,
                      height: 100.w,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectTicketLayoutWidget extends GetView<MakeTicketController> {
  const _SelectTicketLayoutWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.65.w),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 3; i++)
                  GestureDetector(
                    onTap: () {
                      controller.selectedTicketLayoutIndex.value = i;
                      controller.makeTicket();
                    },
                    child: SvgPicture.asset(
                      controller.selectedTicketLayoutIndex.value == i
                          ? "assets/tickets/ticket_${i}_layout_active.svg"
                          : "assets/tickets/ticket_${i}_layout.svg",
                      width: 75.w,
                      height: 75.w,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
