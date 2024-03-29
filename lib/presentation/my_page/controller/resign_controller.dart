import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/app/config/routes/route_path.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';

class ResignController extends GetxController {
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  ResignMemberUseCase get resignMemberUseCase => memberUseCases.resignMemberUseCase;

  RxBool isResignAgree = false.obs;
  RxList<int> resignReasonList = <int>[].obs;

  Future<void> postResign() async {
    try {
      await resignMemberUseCase.execute(resignReasonList);

      await AuthService.to.logout();

      Get.offAllNamed(RoutePath.login);

      await showTextDialog(Get.context!, "회원 탈퇴가 완료되었습니다 ㅜ.ㅜ");
    } catch (e) {
      debugPrint(e.toString());
      await showTextDialog(Get.context!, "회원 탈퇴 중 문제가 발생하였습니다.");
    }
  }
}
