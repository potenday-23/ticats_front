import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';

class TicatsNoTicketView extends StatelessWidget {
  const TicatsNoTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(RoutePath.makeTicketInfo),
            child: SvgPicture.asset(
              'assets/images/no_ticket.svg',
              width: 163.w,
              height: 269.w,
            ),
          ),
          SizedBox(height: 35.h),
          Center(
            child: Text(
              "아직 만든 티켓이 없어요.\n티캣이를 눌러 \n티켓을 만들어보세요!",
              style: AppTypeFace.small20Bold.copyWith(color: AppColor.grayAE),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
