import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/register_entity.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/usecases/auth_use_cases.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';
import 'package:ticats/presentation/common/pages/crop_image_page.dart';

class RegisterController extends GetxController {
  final AuthUseCases authUseCases = Get.find<AuthUseCases>();
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  CheckNicknameUseCase get checkNicknameUseCase => memberUseCases.checkNicknameUseCase;
  RegisterUseCase get registerUseCase => authUseCases.registerUseCase;

  // Profile
  RxString nickname = "".obs;
  Rx<XFile?> profileImage = XFile("").obs;

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(image.path, quality: 95);

        var imagePath = Get.to(() => CropImagePage(image: compressedImage!, isProfile: true));

        if (imagePath != null) {
          profileImage.value = XFile(await imagePath);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Term
  bool get isAllAgree => isAgreeList.contains(false) ? false : true;
  bool get isRequiredAgree => isAgreeList[0] && isAgreeList[1];

  RxList<bool> isAgreeList = <bool>[false, false, false, false].obs;

  void setAllAgree() {
    if (!isAllAgree) {
      isAgreeList.assignAll([true, true, true, true]);
    } else {
      isAgreeList.assignAll([false, false, false, false]);
    }
  }

  // Register
  Future<void> register() async {
    final RegisterEntity registerEntity = RegisterEntity(
      socialId: AuthService.to.tempMemberOAuth!.socialId,
      socialType: AuthService.to.tempMemberOAuth!.socialType,
      pushAgree: isAgreeList[2] ? "AGREE" : "DISAGREE",
      marketingAgree: isAgreeList[3] ? "AGREE" : "DISAGREE",
      nickname: nickname.value,
      profileImage: profileImage.value,
      categorys: [],
    );

    try {
      TicatsMember member = await registerUseCase.execute(registerEntity);

      await AuthService.to.setMember(member);
      await AuthService.to.setMemberOAuth(AuthService.to.tempMemberOAuth!);

      Get.toNamed(RoutePath.main);
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
    }
  }
}
