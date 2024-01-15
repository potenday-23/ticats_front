import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:ticats/app/config/app_color.dart';
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
          onPressed: () {
            if (controller.tabIndex.value == 0) {
              controller.totalHomeViewType.value =
                  controller.totalHomeViewType.value == HomeViewType.card ? HomeViewType.grid : HomeViewType.card;
            } else {
              controller.myHomeViewType.value =
                  controller.myHomeViewType.value == HomeViewType.card ? HomeViewType.grid : HomeViewType.card;
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

class _BuildTicketLoadingView extends StatelessWidget {
  const _BuildTicketLoadingView();

  @override
  Widget build(BuildContext context) {
    return StackedCardCarousel(
      type: StackedCardCarouselType.fadeOutStack,
      initialOffset: 24.h,
      spaceBetweenItems: 588.h,
      items: [
        SizedBox(
          height: 564.h,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Image.asset('assets/tickets/ticket_0.png'),
          ),
        ),
        SizedBox(
          height: 564.h,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Image.asset('assets/tickets/ticket_1.png'),
          ),
        ),
        SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Image.asset('assets/tickets/ticket_2.png'),
          ),
        )
      ],
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
            IndexedStack(
              index: homeController.totalHomeViewType.value.index,
              children: [
                TicatsCardView(controller: homeController.totalPageController, ticketList: ticketController.totalTicketList, isMain: true),
                TicatsGridView(ticketList: ticketController.totalTicketList),
              ],
            ),
            if (ticketController.myTicketList.isNotEmpty) ...[
              IndexedStack(
                index: homeController.myHomeViewType.value.index,
                children: [
                  TicatsCardView(controller: homeController.myPageController, ticketList: ticketController.myTicketList, hasLike: false),
                  TicatsGridView(ticketList: ticketController.myTicketList, hasLike: false),
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
