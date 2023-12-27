import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';

class ResignController extends GetxController {
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  ResignMemberUseCase get resignMemberUseCase => memberUseCases.resignMemberUseCase;

  RxBool isResignAgree = false.obs;
  RxList<int> resignReasonList = <int>[].obs;

  Future<void> postResign() async {
    try {
      await resignMemberUseCase.execute(resignReasonList);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
