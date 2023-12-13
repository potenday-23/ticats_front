import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/app_color.dart';
import 'package:ticats/app/config/app_typeface.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/extension/input_validate.dart';
import 'package:ticats/presentation/common/widgets/ticats_appbar.dart';
import 'package:ticats/presentation/common/widgets/ticats_button.dart';
import 'package:ticats/presentation/register/controller/register_controller.dart';

class RegisterProfilePage extends StatelessWidget {
  const RegisterProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 36.h),
                      Text("사용하실 닉네임과\n프로필을 등록해주세요!", style: AppTypeFace.small20Bold),
                      SizedBox(height: 24.h),
                      const _ProfileImageWidget(),
                      SizedBox(height: 24.h),
                      const _NickNameTextField(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GetX<RegisterController>(
                builder: (controller) {
                  return TicatsButton(
                    onPressed: controller.nickname.value.isNotEmpty ? () => Get.toNamed(RoutePath.selectCategory) : null,
                    child: Text("다음", style: AppTypeFace.small20Bold.copyWith(color: Colors.white)),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: SizedBox(height: 70.w)),
    );
  }
}

class _ProfileImageWidget extends GetView<RegisterController> {
  const _ProfileImageWidget();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Stack(
          children: [
            if (controller.profileImage.value!.path.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(60.w),
                child: Image.asset(controller.profileImage.value!.path, width: 120.w, height: 120.w, fit: BoxFit.cover),
              )
            ] else ...[
              SvgPicture.asset('assets/icons/profile.svg', width: 120.w, height: 120.w)
            ],
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  child: GestureDetector(
                      onTap: () async => await controller.getImage(),
                      child: SvgPicture.asset('assets/icons/camera.svg', width: 32.w, height: 32.w)),
                ),
              ),
            ),
          ],
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
    nickController.text = Get.find<RegisterController>().nickname.value;
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
            bool hasError = true;

            if (value.isNotEmpty && value.length > 10) {
              nickErrorMessage = "10자 이하로 입력해주세요.";
            } else if (!nickController.text.isValidNick()) {
              nickErrorMessage = "닉네임을 확인해주세요.";
            } else if (!await Get.find<RegisterController>().checkNicknameUseCase.execute(nickController.text)) {
              nickErrorMessage = "이미 사용중인 닉네임입니다.";
            } else {
              nickErrorMessage = "";

              hasError = false;
            }

            setState(() {
              if (hasError) {
                Get.find<RegisterController>().nickname.value = "";
              } else {
                Get.find<RegisterController>().nickname.value = nickController.text;
              }
            });
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
