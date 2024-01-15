import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';
import 'package:ticats/presentation/common/pages/crop_image_page.dart';

class EditProfileController extends GetxController {
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  CheckNicknameUseCase get checkNicknameUseCase => memberUseCases.checkNicknameUseCase;
  PatchMemberUseCase get registerUseCase => memberUseCases.patchMemberUseCase;

  // Profile
  RxString nickname = "".obs;
  Rx<XFile?> profileImage = XFile("").obs;

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(image.path, quality: 75);

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

  // Register
  Future<void> editProfile() async {
    try {
      Member member = await registerUseCase.execute(nickname.value, profileImage.value);

      await AuthService.to.setMember(AuthService.to.member!.copyWith(member: member));

      Get.back();
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: $e");
      }
      rethrow;
    }
  }
}
