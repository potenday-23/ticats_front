import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/views/ticats_grid_view.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class LikePage extends GetView<TicketController> {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: "좋아요 한 티켓"),
      body: Obx(() {
        if (controller.likeTicketList.isEmpty) {
          return Center(
            child: Text(
              "좋아요 한 티켓이 없어요.\n좋아요 버튼을 누르면\n이곳에서 모아볼 수 있어요!",
              style: AppTypeFace.small20Bold.copyWith(color: AppColor.grayAE),
              textAlign: TextAlign.center,
            ),
          );
        }

        return TicatsGridView(ticketList: controller.likeTicketList);
      }),
    );
  }
}
