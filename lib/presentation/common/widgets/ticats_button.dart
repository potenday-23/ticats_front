import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticats/app/config/app_color.dart';

class TicatsButton extends StatelessWidget {
  const TicatsButton({super.key, required this.child, this.color, this.gradient, required this.onPressed});

  final Widget child;
  final Color? color;
  final LinearGradient? gradient;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.maxFinite,
        height: 56.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: color ?? AppColor.systemPositiveBlue,
          gradient: gradient,
        ),
        child: Center(child: child),
      ),
    );
  }
}
