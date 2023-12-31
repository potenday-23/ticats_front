import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_typeface.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 80.w,
      leading: Row(
        children: [
          SizedBox(width: 24.w),
          GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset('assets/icons/arrow_left.svg', width: 24.w, height: 24.h),
          ),
        ],
      ),
      title: Text(title ?? "", style: AppTypeFace.small18SemiBold),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}

class CloseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CloseAppBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GestureDetector(onTap: () => Get.back(), child: Icon(Icons.close, size: 24.w)),
        ),
      ],
      title: Text(title ?? "", style: AppTypeFace.small18SemiBold),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}

class TicatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TicatsAppBar({super.key, this.title, this.actions = const []});

  final String? title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: actions,
      title: Text(title ?? "", style: AppTypeFace.small18SemiBold),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.w);
}
