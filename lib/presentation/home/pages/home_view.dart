import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/presentation/common/views/ticats_card_view.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

import '../controller/home_controller.dart';
import '../widgets/home_appbar.dart';
import '../widgets/ticats_card_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grayF9,
      appBar: const HomeAppBar(),
      body: GetX<TicketController>(
        builder: (ticketController) {
          if (ticketController.totalTicketList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return TabBarView(
              controller: controller.tabController,
              children: [
                TicatsCardView(ticketList: ticketController.totalTicketList),
                TicatsCardView(ticketList: ticketController.totalTicketList),
              ],
            );
          }
        },
      ),
    );
  }
}
