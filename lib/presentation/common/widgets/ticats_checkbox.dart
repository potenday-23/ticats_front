import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticats/app/config/app_color.dart';

class TicatsCheckBox extends StatelessWidget {
  const TicatsCheckBox({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: SizedBox(
        width: 18.w,
        height: 18.w,
        child: Checkbox(
          activeColor: AppColor.systemPositiveBlue,
          value: value,
          onChanged: onChanged,
          splashRadius: 0.0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
