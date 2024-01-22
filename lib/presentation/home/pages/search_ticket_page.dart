import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_chip.dart';
import 'package:ticats/presentation/home/controller/search_ticket_controller.dart';

class SearchTicketPage extends GetView<SearchTicketController> {
  const SearchTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Misc
        automaticallyImplyLeading: false,
        toolbarHeight: 56.w,

        // Empty leading
        leadingWidth: 0,

        // Title
        title: const _FilterTitleTextField(),
        titleSpacing: 0,

        // Actions
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 24.w, 16.h),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.close, size: 24.w),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (AuthService.to.isLogin) ...[
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("내 티켓만 보기", style: AppTypeFace.small18SemiBold),
                  Obx(
                    () => CupertinoSwitch(
                      activeColor: AppColor.primaryDark,
                      value: controller.isMyTicket.value,
                      onChanged: (value) => controller.isMyTicket.value = value,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 28.h),
            Text("기간", style: AppTypeFace.small18SemiBold),
            SizedBox(height: 12.h),
            Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  TicatsChip(
                    "일주일",
                    onTap: () => controller.dateType.value = "week",
                    color: controller.dateType.value == "week" ? null : AppColor.grayE5,
                    textColor: controller.dateType.value == "week" ? Colors.white : null,
                  ),
                  TicatsChip(
                    "한 달",
                    onTap: () => controller.dateType.value = "month",
                    color: controller.dateType.value == "month" ? null : AppColor.grayE5,
                    textColor: controller.dateType.value == "month" ? Colors.white : null,
                  ),
                  TicatsChip(
                    "6개월",
                    onTap: () => controller.dateType.value = "6month",
                    color: controller.dateType.value == "6month" ? null : AppColor.grayE5,
                    textColor: controller.dateType.value == "6month" ? Colors.white : null,
                  ),
                  TicatsChip(
                    controller.dateType.value == "day"
                        ? "${DateFormat('yy.MM.dd').format(controller.rangeStart.value!)} ~ ${DateFormat('yy.MM.dd').format(controller.rangeEnd.value!)}"
                        : "직접 지정",
                    onTap: () async {
                      List<DateTime?>? result = await showCalendarDatePicker2Dialog(
                        dialogBackgroundColor: Colors.white,
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          calendarType: CalendarDatePicker2Type.range,
                          lastDate: DateTime.now(),
                        ),
                        dialogSize: const Size(325, 400),
                        value: [],
                        borderRadius: BorderRadius.circular(15),
                      );

                      if (result != null && result.length == 2) {
                        controller.rangeStart.value = result[0];
                        controller.rangeEnd.value = result[1];

                        controller.dateType.value = "day";
                      } else if (result != null && result.length == 1) {
                        controller.rangeStart.value = result[0];
                        controller.rangeEnd.value = result[0];

                        controller.dateType.value = "day";
                      }
                    },
                    color: controller.dateType.value == "day" ? null : AppColor.grayE5,
                    textColor: controller.dateType.value == "day" ? Colors.white : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Text("카테고리", style: AppTypeFace.small18SemiBold),
            SizedBox(height: 12.h),
            Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (Category category in TicatsService.to.ticatsCategories)
                    TicatsChip(
                      category.name,
                      onTap: () {
                        if (controller.categoryList.contains(category.name)) {
                          controller.categoryList.remove(category.name);
                        } else {
                          controller.categoryList.add(category.name);
                        }
                      },
                      color: controller.categoryList.contains(category.name) ? null : AppColor.grayE5,
                      textColor: controller.categoryList.contains(category.name) ? Colors.white : null,
                    ),
                ],
              ),
            ),
            const Spacer(),
            TicatsButton(
              color: AppColor.primaryNormal,
              onPressed: () async {
                Get.toNamed(RoutePath.searchTicketResult);
                await controller.searchTicket();

                await GAUtil().sendGAButtonEvent('search_button', {
                  'search_text': controller.searchTextController.text,
                  'search_date': controller.dateType.value,
                  'search_start_date': controller.rangeStart.value.toString(),
                  'search_end_date': controller.rangeEnd.value.toString(),
                  'search_category': controller.categoryList.toString(),
                });
              },
              child: Text(
                "검색하기",
                style: AppTypeFace.small18Bold.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }
}

class _FilterTitleTextField extends GetView<SearchTicketController> {
  const _FilterTitleTextField();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: SizedBox(
        height: 48.h,
        child: TextField(
          controller: controller.searchTextController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColor.grayF2,
            hintText: '티켓을 검색해보세요!',
            hintStyle: AppTypeFace.xSmall16SemiBold.copyWith(color: AppColor.gray8E),
            prefixIconConstraints: BoxConstraints(minWidth: 60.w),
            prefixIcon: Icon(Icons.search, size: 24.w),
            prefixIconColor: Colors.black,
            contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
          ),
          style: AppTypeFace.xSmall16SemiBold,
        ),
      ),
    );
  }
}
