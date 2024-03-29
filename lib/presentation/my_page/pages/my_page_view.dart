import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/app/util/ga_util.dart';
import 'package:ticats/domain/entities/version.dart';
import 'package:ticats/domain/usecases/my_page_use_cases.dart';
import 'package:ticats/presentation/common/enum/term_type.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class MyPageView extends GetView<AuthService> {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TicatsAppBar(title: "마이페이지"),
      body: Obx(
        () => Column(
          children: [
            if (AuthService.to.member!.member != null) ...[
              const _MyProfileWidget(),
            ] else ...[
              const _GuestProfileWidget(),
            ],
            const _MyPageListView(),
          ],
        ),
      ),
    );
  }
}

class _MyPageListView extends StatelessWidget {
  const _MyPageListView();

  Future<Map<String, String>> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try {
      String packageVersion = packageInfo.version;
      Version latestVersion = await Get.find<MyPageUseCases>().getVersionUseCase.execute();

      return {
        "packageVersion": packageVersion,
        "latestVersion": latestVersion.version,
      };
    } catch (e) {
      debugPrint(e.toString());
    }
    return {
      "packageVersion": 'unknown',
      "latestVersion": 'unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MyPageTile(
          "공지사항",
          icon: "notice",
          onTap: () => Get.toNamed(RoutePath.notice),
        ),
        _MyPageTile(
          "문의하기",
          icon: "inquery",
          onTap: () => Get.toNamed(RoutePath.inquery),
        ),
        _MyPageTile(
          "서비스 이용 약관",
          icon: "doc",
          onTap: () => Get.toNamed(RoutePath.termDetail, arguments: TermType.termOfUse),
        ),
        _MyPageTile(
          "개인정보 수집 및 이용",
          icon: "user_privacy",
          onTap: () => Get.toNamed(RoutePath.termDetail, arguments: TermType.privacyPolicy),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/exchange.svg', width: 24.w, height: 24.w),
                SizedBox(width: 12.w),
                Text("버전 정보", style: AppTypeFace.xSmall14Medium),
                SizedBox(width: 14.w),
                FutureBuilder<Map<String, String>>(
                  future: _getVersion(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      String packageVersion = snapshot.data['packageVersion'];
                      String latestVersion = snapshot.data['latestVersion'];

                      return Expanded(
                        child: Row(
                          children: [
                            Text(packageVersion, style: AppTypeFace.xSmall16SemiBold.copyWith(color: AppColor.gray63)),
                            const Spacer(),
                            Text(packageVersion == latestVersion ? "최신 버전입니다." : "업데이트가 필요합니다($latestVersion).",
                                style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.gray98)),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => Column(
            children: [
              if (AuthService.to.member!.member != null) ...[
                _MyPageTile(
                  "로그아웃",
                  icon: "logout",
                  onTap: () async {
                    showLogoutDialog(context);

                    await GAUtil().sendGAButtonEvent('logout_button', {});
                  },
                ),
                _MyPageTile(
                  "탈퇴하기",
                  icon: "quit",
                  onTap: () => Get.toNamed(RoutePath.resign),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MyProfileWidget extends StatelessWidget {
  const _MyProfileWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Obx(
                  () => Row(
                    children: [
                      if (AuthService.to.member!.member!.profileUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: AuthService.to.member!.member!.profileUrl!,
                            width: 56.w,
                            height: 56.w,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              return SvgPicture.asset('assets/icons/profile.svg', width: 56.w, height: 56.w);
                            },
                          ),
                        ),
                      ] else ...[
                        SvgPicture.asset('assets/icons/profile.svg', width: 56.w, height: 56.w)
                      ],
                      SizedBox(width: 18.w),
                      Text(AuthService.to.member!.member!.nickname!, style: AppTypeFace.small18SemiBold),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.toNamed(RoutePath.editProfile),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.grayE5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(14.w, 4.w, 12.w, 4.w),
                            child: Row(
                              children: [
                                Text("프로필 수정", style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.gray8E)),
                                SizedBox(width: 8.w),
                                SvgPicture.asset('assets/icons/edit.svg', width: 16.w, height: 16.w),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                Container(
                  height: 56.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: AppColor.grayF2),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.find<HomeController>().tabController.index = 1;
                            Get.find<MainController>().changePage(0);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("내 티켓", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63)),
                              Obx(() => Text(Get.find<TicketController>().myTicketList.length.toString(), style: AppTypeFace.xSmall12Bold)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const VerticalDivider(thickness: 1, width: 1, color: AppColor.grayC7),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Get.toNamed(RoutePath.statistics),
                          child: Center(child: Text("통계 보기", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const VerticalDivider(thickness: 1, width: 1, color: AppColor.grayC7),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Get.toNamed(RoutePath.like),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("좋아요 한 티켓", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63)),
                              Obx(() =>
                                  Text(Get.find<TicketController>().likeTicketList.length.toString(), style: AppTypeFace.xSmall12Bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: AppColor.grayE5, height: 1),
        ],
      ),
    );
  }
}

class _GuestProfileWidget extends StatelessWidget {
  const _GuestProfileWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.toNamed(RoutePath.alterLogin),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: AppColor.grayC7), borderRadius: BorderRadius.circular(16.r)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.w),
                              child: Text("로그인", style: AppTypeFace.small20Bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Get.toNamed(RoutePath.alterLogin),
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: AppColor.grayC7), borderRadius: BorderRadius.circular(16.r)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.w),
                              child: Text("회원가입", style: AppTypeFace.small20Bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Get.toNamed(RoutePath.alterLogin),
                  child: Container(
                    height: 56.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r), color: AppColor.grayF2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(child: Text("내 티켓", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const VerticalDivider(thickness: 1, color: AppColor.grayC7),
                        ),
                        Expanded(
                          child: Center(child: Text("통계 보기", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const VerticalDivider(thickness: 1, color: AppColor.grayC7),
                        ),
                        Expanded(
                          child: Center(child: Text("좋아요한 티켓", style: AppTypeFace.xSmall12Bold.copyWith(color: AppColor.gray63))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: AppColor.grayE5, height: 1),
        ],
      ),
    );
  }
}

class _MyPageTile extends StatelessWidget {
  const _MyPageTile(this.title, {required this.icon, this.onTap});

  final String title;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              SvgPicture.asset('assets/icons/$icon.svg', width: 24.w, height: 24.w),
              SizedBox(width: 12.w),
              Text(title, style: AppTypeFace.xSmall14Medium),
            ],
          ),
        ),
      ),
    );
  }
}
