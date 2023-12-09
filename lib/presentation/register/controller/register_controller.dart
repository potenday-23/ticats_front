import 'package:get/get.dart';

class RegisterController extends GetxController {
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
