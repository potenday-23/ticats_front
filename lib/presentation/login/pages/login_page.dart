import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/login/widgets/sso_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/cats/cat_lick_pink.svg'),
                SizedBox(height: 45.h),
                Text("티캣츠에 오신 것을 환영합니다!", style: AppTypeFace.small20Bold),
                SizedBox(height: 30.h),
                Text("나만의 문화생활 티켓을 꾸며보세요", style: AppTypeFace.small18SemiBold.copyWith(color: AppColor.gray8E)),
                SizedBox(height: 74.h),
                const SSOLoginLayout(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
