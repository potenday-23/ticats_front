import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/extension/input_validate.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';
import 'package:ticats/presentation/my_page/controller/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(title: '프로필 수정'),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 36.w),
                const _ProfileImageWidget(),
                SizedBox(height: 24.w),
                const _NickNameTextField(),
                const Spacer(),
                GetX<EditProfileController>(
                  builder: (controller) {
                    return TicatsButton(
                      onPressed: controller.nickname.value.isNotEmpty || controller.profileImage.value!.path.isNotEmpty
                          ? () async {
                              try {
                                await controller.editProfile();
                                await showTextDialog(Get.context!, "프로필이 변경 되었습니다!");
                              } catch (e) {
                                await showTextDialog(Get.context!, "프로필 수정에 실패했습니다.");
                              }
                            }
                          : null,
                      child: Text("확인", style: AppTypeFace.small18Bold.copyWith(color: Colors.white)),
                    );
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ));
  }
}

class _ProfileImageWidget extends GetView<EditProfileController> {
  const _ProfileImageWidget();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: () async => await controller.getImage(),
          child: Stack(
            children: [
              if (controller.profileImage.value!.path.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(600.r),
                  child: Image.file(File(controller.profileImage.value!.path), width: 120.w, height: 120.w, fit: BoxFit.cover),
                )
              ] else ...[
                if (AuthService.to.member!.member!.profileUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.r),
                    child: CachedNetworkImage(
                      imageUrl: AuthService.to.member!.member!.profileUrl!,
                      width: 120.w,
                      height: 120.w,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset('assets/icons/profile.svg', width: 120.w, height: 120.w);
                      },
                    ),
                  ),
                ] else ...[
                  SvgPicture.asset('assets/icons/profile.svg', width: 120.w, height: 120.w)
                ],
              ],
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SvgPicture.asset('assets/icons/camera.svg', width: 32.w, height: 32.w),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NickNameTextField extends StatefulWidget {
  const _NickNameTextField();

  @override
  State<_NickNameTextField> createState() => _NickNameTextFieldState();
}

class _NickNameTextFieldState extends State<_NickNameTextField> {
  final TextEditingController nickController = TextEditingController();

  String nickErrorMessage = "";
  bool get hasNickError => nickErrorMessage.isNotEmpty;

  @override
  void initState() {
    super.initState();
    nickController.text = AuthService.to.member!.member!.nickname!;
  }

  @override
  void dispose() {
    nickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nickController,
          decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: hasNickError ? AppColor.systemError : AppColor.gray63)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hasNickError ? AppColor.systemError : AppColor.gray63)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: hasNickError ? AppColor.systemError : AppColor.gray63)),
            hintText: "티케팅하는 고양이",
            hintStyle: AppTypeFace.small18SemiBold.copyWith(color: AppColor.gray8E),
          ),
          scrollPadding: const EdgeInsets.only(bottom: 200),
          onChanged: (value) async {
            final Debouncer debouncer = Debouncer();

            bool hasError = true;

            debouncer.debounce(
              duration: const Duration(milliseconds: 100),
              onDebounce: () async {
                if (value.isNotEmpty && value.length > 10) {
                  nickErrorMessage = "10자 이하로 입력해주세요.";
                } else if (!nickController.text.isValidNick()) {
                  nickErrorMessage = "닉네임을 확인해주세요.";
                } else if (!await Get.find<EditProfileController>().checkNicknameUseCase.execute(nickController.text)) {
                  nickErrorMessage = "이미 사용중인 닉네임입니다.";
                } else {
                  nickErrorMessage = "";

                  hasError = false;
                }

                setState(() {
                  if (hasError) {
                    Get.find<EditProfileController>().nickname.value = "";
                  } else {
                    Get.find<EditProfileController>().nickname.value = nickController.text;
                  }
                });
              },
            );
          },
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        SizedBox(height: 4.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(nickErrorMessage, style: AppTypeFace.xSmall14Medium.copyWith(color: AppColor.systemError)),
            Text("${nickController.text.length}/10",
                style: AppTypeFace.xSmall14Medium.copyWith(
                  color: hasNickError ? AppColor.systemError : AppColor.gray8E,
                )),
          ],
        ),
      ],
    );
  }
}
