import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticats/presentation/common/views/ticats_grid_view.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class LikePage extends GetView<TicketController> {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: "좋아요한 티켓"),
      body: TicatsGridView(ticketList: controller.likeTicketList),
    );
  }
}
