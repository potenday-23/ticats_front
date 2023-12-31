import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/views/ticats_no_ticket_view.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class MyTicketView extends GetView<TicketController> {
  const MyTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TicatsAppBar(
        title: "티켓 만들기",
        actions: [
          Obx(
            () => controller.myTicketList.isEmpty
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(right: 24.w),
                    child: GestureDetector(
                      onTap: () => controller.toggleEditing(),
                      child: Text("편집", style: AppTypeFace.xSmall14Medium),
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.myTicketList.isEmpty) {
          return const TicatsNoTicketView();
        } else {
          Map<Category, List<Ticket>> ticketMap = {};

          for (Ticket ticket in controller.myTicketList) {
            if (ticketMap.containsKey(ticket.category)) {
              ticketMap[ticket.category]!.add(ticket);
            } else {
              ticketMap[ticket.category!] = [ticket];
            }
          }

          return Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: ticketMap.keys.length,
                itemBuilder: (context, index) {
                  return _CategoryListView(
                    categoryName: ticketMap.keys.toList()[index].name,
                    tickets: ticketMap.values.toList()[index],
                  );
                },
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.w),
                    child: TicatsButton(
                      onPressed: () => Get.toNamed(RoutePath.makeTicketInfo),
                      color: AppColor.primaryNormal,
                      child: Text("티켓 만들기", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class _CategoryListView extends GetView<TicketController> {
  const _CategoryListView({required this.categoryName, required this.tickets});

  final String categoryName;
  final List<Ticket> tickets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 36.w),
        Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Text(categoryName, style: AppTypeFace.small18SemiBold),
        ),
        SizedBox(height: 12.w),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 16.w,
            children: [
              SizedBox(width: 8.w),
              for (Ticket ticket in tickets) ...[
                Obx(
                  () => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(width: 163.w, height: 269.h, child: TicketFront(ticket)),
                      if (controller.isEditing.value) ...[
                        Positioned.fill(
                          top: -2.w,
                          right: -2.w,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () async => showDeleteDialog(context, ticket.id!),
                              child: SvgPicture.asset('assets/icons/delete.svg', width: 22.w, height: 22.w),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
