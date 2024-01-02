import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/presentation/common/widgets/ticats_ticket.dart';

class TicatsGridView extends StatelessWidget {
  const TicatsGridView({super.key, required this.ticketList});

  final List<Ticket> ticketList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Wrap(
          spacing: 16.w,
          runSpacing: 18.w,
          children: [
            for (final ticket in ticketList)
              SizedBox(
                width: 163.w,
                height: 269.h,
                child: TicketFront(ticket),
              ),
          ],
        ),
      ),
    );
  }
}
