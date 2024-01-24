import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/ticats_service.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_chip.dart';
import 'package:ticats/presentation/make_ticket/controller/make_ticket_controller.dart';

class MakeTicketInfoPage extends GetView<MakeTicketController> {
  const MakeTicketInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackAppBar(title: "티켓 만들기"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _SelectImageWidget(),
              SizedBox(height: 20.w),
              const _TicketNameWidget(),
              SizedBox(height: 46.w),
              const _SelectCategoryWidget(),
              SizedBox(height: 36.w),
              _SelectDateWidget(context),
              SizedBox(height: 36.w),
              const _SelectRatingWidget(),
              SizedBox(height: 36.w),
              const _SelectMemoWidget(),
              SizedBox(height: 24.w),
              Obx(
                () => TicatsButton(
                  onPressed: controller.isEnable
                      ? () {
                          controller.makeTicket();
                          Get.toNamed(RoutePath.makeTicketLayout);
                        }
                      : null,
                  color: AppColor.primaryNormal,
                  child: Text("티켓 만들기", style: AppTypeFace.small18Bold.copyWith(color: Colors.white)),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectImageWidget extends GetView<MakeTicketController> {
  const _SelectImageWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await controller.getImage(),
      child: Obx(
        () => Column(
          children: [
            if (controller.ticketImage.value!.path.isNotEmpty) ...[
              SizedBox(height: 16.w),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.file(File(controller.ticketImage.value!.path), width: 310.w, fit: BoxFit.fitWidth))
            ] else ...[
              SizedBox(height: 32.w),
              Text("이미지를 필수로 등록해주세요!", style: AppTypeFace.xSmall16SemiBold.copyWith(color: AppColor.gray98)),
              SvgPicture.asset('assets/images/image.svg'),
              SizedBox(height: 20.w),
            ],
          ],
        ),
      ),
    );
  }
}

class _TicketNameWidget extends GetView<MakeTicketController> {
  const _TicketNameWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("* ", style: AppTypeFace.small18SemiBold.copyWith(color: AppColor.systemError)),
        Expanded(
          child: TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              counter: const SizedBox(),
              hintText: "티켓 제목을 입력해주세요.",
              hintStyle: AppTypeFace.small18SemiBold.copyWith(color: AppColor.gray98),
            ),
            style: AppTypeFace.small18SemiBold,
            maxLength: 20,
            onChanged: (value) => controller.titleTextLength.value = value.length,
          ),
        ),
      ],
    );
  }
}

class _SelectCategoryWidget extends GetView<MakeTicketController> {
  const _SelectCategoryWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(" * ", style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.systemError)),
            Text("카테고리를 선택해주세요.", style: AppTypeFace.xSmall14Medium),
          ],
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              for (Category category in TicatsService.to.ticatsCategories) ...[
                TicatsChip(
                  category.name,
                  onTap: () async {
                    controller.selectedCategory.value = category;
                    await GAUtil().sendGAButtonEvent('make_ticket_category_button', {'category': category.name});
                  },
                  color: controller.selectedCategory.value.id == category.id ? null : AppColor.grayF2,
                  textColor: controller.selectedCategory.value.id == category.id ? Colors.white : null,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectDateWidget extends GetView<MakeTicketController> {
  const _SelectDateWidget(this.context);

  final BuildContext context;

  void _showDatePicker() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: controller.selectedDate.value,
            maximumDate: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              controller.selectedDate.value = newDate;
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(" * ", style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.systemError)),
            Text("언제 관람했나요?", style: AppTypeFace.xSmall14Medium),
          ],
        ),
        SizedBox(height: 10.h),
        Obx(
          () => TicatsChip(
            DateFormat("yyyy년 MM월 dd일 (E)").format(controller.selectedDate.value),
            color: AppColor.grayF2,
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
            onTap: () {
              _showDatePicker();
            },
          ),
        ),
      ],
    );
  }
}

class _SelectRatingWidget extends GetView<MakeTicketController> {
  const _SelectRatingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(" * ", style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.systemError)),
            Text("감상은 어땠나요? 별점을 선택해주세요.", style: AppTypeFace.xSmall14Medium),
          ],
        ),
        SizedBox(height: 10.h),
        RatingBar(
          initialRating: 4.5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          glow: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: SvgPicture.asset('assets/tickets/star_full.svg', width: 32.w, height: 32.w),
            half: SvgPicture.asset('assets/tickets/star_half.svg', width: 32.w, height: 32.w),
            empty: SvgPicture.asset('assets/tickets/star_empty.svg', width: 32.w, height: 32.w),
          ),
          onRatingUpdate: (rating) => controller.selectedRating.value = rating,
        ),
      ],
    );
  }
}

class _SelectMemoWidget extends GetView<MakeTicketController> {
  const _SelectMemoWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("메모를 입력해주세요.", style: AppTypeFace.xSmall14Medium),
        SizedBox(height: 10.h),
        Obx(
          () => Stack(
            children: [
              TextField(
                controller: controller.memoController,
                maxLines: 6,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  counterText: "",
                  filled: true,
                  fillColor: AppColor.grayF2,
                  hintText: "메모를 입력해주세요.",
                  hintStyle: AppTypeFace.small18SemiBold.copyWith(color: AppColor.grayAE),
                ),
                style: AppTypeFace.small18SemiBold,
                onChanged: (value) => controller.memoTextLength.value = value.length,
                maxLength: 100,
                scrollPadding: const EdgeInsets.only(bottom: 300),
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              Positioned.fill(
                right: 12.w,
                bottom: 12.h,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("${controller.memoTextLength.value}/100",
                      style: AppTypeFace.xSmall14Medium.copyWith(
                        color: controller.memoTextLength <= 100 ? AppColor.grayAE : AppColor.systemError,
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
