import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/login/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/cats/cat_lick.svg'),
              SizedBox(height: 45.h),
              Text("티캣츠에 오신 것을 환영합니다!", style: AppTypeFace.smallBold),
              SizedBox(height: 30.h),
              Text("나만의 문화생활 티켓을 꾸며보세요", style: AppTypeFace.smallSemiBold.copyWith(color: AppColor.gray8E)),
              SizedBox(height: 74.h),
              _buildSSOLayout(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSSOLayout() {
  return Column(
    children: [
      TicatsButton(
        color: const Color(0xFFFFE300),
        onPressed: () async => await Get.find<LoginController>().loginWithKakao(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/logos/kakao_logo.svg'),
            SizedBox(width: 21.w),
            Text("카카오로 시작하기", style: AppTypeFace.smallSemiBold),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      TicatsButton(
        color: Colors.black,
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/logos/apple_logo.svg'),
            SizedBox(width: 21.w),
            Text("Apple로 시작하기", style: AppTypeFace.smallSemiBold.copyWith(color: Colors.white)),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      TicatsButton(
        color: AppColor.grayC7,
        onPressed: () {},
        child: Text("로그인 없이 둘러보기", style: AppTypeFace.smallSemiBold),
      ),
    ],
  );
}
