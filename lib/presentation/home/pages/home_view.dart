import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/presentation/common/views/ticats_card_view.dart';
import 'package:ticats/presentation/common/views/ticats_grid_view.dart';
import 'package:ticats/presentation/common/views/ticats_no_ticket_view.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

import '../controller/home_controller.dart';
import '../widgets/home_appbar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: GetX<TicketController>(
        builder: (ticketController) {
          if (ticketController.isLoading.value) {
            return const _BuildTicketLoadingView();
          } else if (ticketController.totalTicketList.isEmpty) {
            return const TicatsNoTicketView();
          } else {
            return const _BuildTabBarView();
          }
        },
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: AppColor.primaryNormal.withOpacity(0.5),
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          splashColor: AppColor.primaryNormal.withOpacity(0.5),
          onPressed: () async {
            if (controller.tabIndex.value == 0) {
              controller.totalHomeViewType.value =
                  controller.totalHomeViewType.value == HomeViewType.card ? HomeViewType.grid : HomeViewType.card;

              await GAUtil()
                  .sendGAButtonEvent('view_type_button', {'type': controller.totalHomeViewType.value == HomeViewType.card ? 0 : 1});
            } else {
              controller.myHomeViewType.value =
                  controller.myHomeViewType.value == HomeViewType.card ? HomeViewType.grid : HomeViewType.card;

              await GAUtil().sendGAButtonEvent('view_type_button', {'type': controller.myHomeViewType.value == HomeViewType.card ? 0 : 1});
            }
          },
          child: Obx(
            () => controller.tabIndex.value == 0
                ? controller.totalHomeViewType.value == HomeViewType.card
                    ? SvgPicture.asset('assets/icons/grid_view.svg')
                    : SvgPicture.asset('assets/icons/card_view.svg')
                : controller.myHomeViewType.value == HomeViewType.card
                    ? SvgPicture.asset('assets/icons/grid_view.svg')
                    : SvgPicture.asset('assets/icons/card_view.svg'),
          ),
        ),
      ),
    );
  }
}

class _BuildTicketLoadingView extends GetView<HomeController> {
  const _BuildTicketLoadingView();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.totalHomeViewType.value == HomeViewType.card) {
          return StackedCardCarousel(
            type: StackedCardCarouselType.fadeOutStack,
            initialOffset: 24.h,
            spaceBetweenItems: 588.h,
            items: [
              for (int i = 0; i < 3; i++)
                SizedBox(
                  height: 564.h,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Image.asset('assets/tickets/ticket_$i.png'),
                  ),
                ),
            ],
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Wrap(
              spacing: 16.w,
              runSpacing: 18.w,
              children: [
                for (int i = 0; i < 6; i++)
                  SizedBox(
                    width: 163.w,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Image.asset('assets/tickets/ticket_${i % 3}.png'),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _BuildTabBarView extends StatefulWidget {
  const _BuildTabBarView();

  @override
  State<_BuildTabBarView> createState() => _BuildTabBarViewState();
}

class _BuildTabBarViewState extends State<_BuildTabBarView> with AutomaticKeepAliveClientMixin {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GetX<TicketController>(
      builder: (ticketController) {
        return TabBarView(
          controller: homeController.tabController,
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await Get.find<TicketController>().getTotalTicket();
              },
              child: IndexedStack(
                index: homeController.totalHomeViewType.value.index,
                children: [
                  TicatsCardView(
                      controller: homeController.totalPageController, ticketList: ticketController.totalTicketList, isMain: true),
                  TicatsGridView(ticketList: ticketController.totalTicketList),
                ],
              ),
            ),
            if (ticketController.myTicketList.isNotEmpty) ...[
              IndexedStack(
                index: homeController.myHomeViewType.value.index,
                children: [
                  TicatsCardView(controller: homeController.myPageController, ticketList: ticketController.myTicketList),
                  TicatsGridView(ticketList: ticketController.myTicketList),
                ],
              ),
            ] else ...[
              const TicatsNoTicketView(),
            ],
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
