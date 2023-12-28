import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/login/widgets/sso_login_button.dart';

class AlterLoginPage extends StatelessWidget {
  const AlterLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CloseAppBar(title: ''),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 59.w),
            RichText(
              text: TextSpan(
                style: AppTypeFace.small20Bold.copyWith(color: Colors.black),
                children: const [
                  TextSpan(text: "티캣츠", style: TextStyle(color: AppColor.primaryNormal)),
                  TextSpan(text: "는 로그인 후\n이용이 가능해요"),
                ],
              ),
            ),
            SizedBox(height: 30.w),
            Text("간편한 SNS로그인으로\n나만의 문화생활 티켓을 꾸며보세요", style: AppTypeFace.small18SemiBold.copyWith(color: AppColor.gray8E)),
            const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: -120.w,
                  right: -13.w,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset('assets/cats/cat_lick.svg', width: 86.w, height: 139.w),
                  ),
                ),
                const SSOLoginLayout(needGuestButton: false),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 90.w),
          ],
        ),
      ),
    );
  }
}
