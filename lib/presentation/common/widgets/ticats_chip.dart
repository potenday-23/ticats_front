import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';

class TicatsChip extends StatelessWidget {
  const TicatsChip(
    this.text, {
    super.key,
    this.child,
    this.padding,
    this.radius = 8,
    this.color,
    this.textColor,
    this.textStyle,
    this.onTap,
  });

  final String text;
  final Widget? child;
  final EdgeInsets? padding;
  final double radius;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color ?? AppColor.primaryLight,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          child: child ??
              Text(
                text,
                style: textStyle?.copyWith(color: textColor ?? Colors.black) ??
                    AppTypeFace.xSmall14Medium.copyWith(color: textColor ?? Colors.black),
              ),
        ),
      ),
    );
  }
}
