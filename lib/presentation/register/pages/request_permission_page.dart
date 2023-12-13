import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/permission_service.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';

class RequestPermissionPage extends StatelessWidget {
  const RequestPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36.h),
              Text(
                "티캣츠에서 나만의 티켓을 꾸미기 위해\n접근 권한 동의를 받고있어요.",
                style: AppTypeFace.small20Bold,
              ),
              SizedBox(height: 36.h),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/gallery.svg',
                      width: 40.w,
                      height: 40.w,
                    ),
                    SizedBox(height: 8.h),
                    Text("갤러리", style: AppTypeFace.small18SemiBold.copyWith(color: AppColor.gray48)),
                    SizedBox(height: 8.h),
                    Text(
                      "티켓 이미지 등록 등 서비스 이용 시,\n이미지 등 콘텐츠 접근(필수 권한)",
                      style: AppTypeFace.xSmall16SemiBold.copyWith(color: AppColor.gray63),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TicatsButton(
                onPressed: () async {
                  await PermissionService.to.requestPhotoPermission();

                  Get.toNamed(RoutePath.registerProfile);
                },
                child: Text("다음", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
              ),
              SizedBox(height: 86.h),
            ],
          ),
        ),
      ),
    );
  }
}
