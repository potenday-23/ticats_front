import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';

import '../controller/login_controller.dart';

class SSOLoginLayout extends GetView<LoginController> {
  const SSOLoginLayout({
    super.key,
    this.needGuestButton = true,
  });

  final bool needGuestButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TicatsButton(
          color: const Color(0xFFFFE300),
          onPressed: () async => await controller.login(SSOType.kakao),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/logos/kakao_logo.svg'),
              SizedBox(width: 21.w),
              Text("카카오로 시작하기", style: AppTypeFace.small18SemiBold),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (GetPlatform.isIOS) ...[
          TicatsButton(
            color: Colors.black,
            onPressed: () async => await controller.login(SSOType.apple),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/logos/apple_logo.svg'),
                SizedBox(width: 21.w),
                Text("Apple로 시작하기", style: AppTypeFace.small18SemiBold.copyWith(color: Colors.white)),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
        if (needGuestButton) ...[
          TicatsButton(
            color: AppColor.grayC7,
            onPressed: () async {
              Get.offAllNamed(RoutePath.main);
              await GAUtil().sendGAButtonEvent('login_guest_button', {'press': true});
            },
            child: Text("로그인 없이 둘러보기", style: AppTypeFace.small18SemiBold),
          ),
        ],
      ],
    );
  }
}
