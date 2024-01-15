import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/views/ticats_grid_view.dart';
import 'package:ticats/presentation/home/controller/search_ticket_controller.dart';

class SearchTicketResultPage extends GetView<SearchTicketController> {
  const SearchTicketResultPage({super.key});

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
        title: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Get.back(),
          child: const IgnorePointer(child: _FilterTitleTextField()),
        ),
        titleSpacing: 0,

        // Actions
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 24.w, 16.h),
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.back();
              },
              child: Icon(Icons.close, size: 24.w),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.searchTicketList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("검색 결과가 없어요.\n다른 티켓을 검색해보세요!", style: AppTypeFace.small20Bold.copyWith(color: AppColor.grayAE)),
                SizedBox(height: 24.w),
                SvgPicture.asset('assets/cats/cat_lick.svg', width: 78.1.w, height: 126.w),
              ],
            ),
          );
        } else {
          return TicatsGridView(ticketList: controller.searchTicketList, isSearch: true);
        }
      }),
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
          readOnly: true,
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
