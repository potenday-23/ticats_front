import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';

class RegisterController extends GetxController {
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  CheckNicknameUseCase get checkNicknameUseCase => memberUseCases.checkNicknameUseCase;

  // Profile
  RxString nickname = "".obs;
  Rx<XFile?> profileImage = XFile("").obs;

  Future<void> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      profileImage.value = await picker.pickImage(source: ImageSource.gallery);
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
}
