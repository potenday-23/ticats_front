import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/usecases/member_use_cases.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';
import 'package:ticats/presentation/home/controller/home_controller.dart';
import 'package:ticats/presentation/main/controller/main_controller.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class ResignController extends GetxController {
  final MemberUseCases memberUseCases = Get.find<MemberUseCases>();

  ResignMemberUseCase get resignMemberUseCase => memberUseCases.resignMemberUseCase;

  RxBool isResignAgree = false.obs;
  RxList<int> resignReasonList = <int>[].obs;

  Future<void> postResign() async {
    try {
      await resignMemberUseCase.execute(resignReasonList);

      await AuthService.to.logout();

      Get.find<HomeController>().tabIndex.value = 0;
      Get.find<MainController>().changePage(0);

      await Get.find<TicketController>().getTickets();

      Get.back();

      await showTextDialog(Get.context!, "회원 탈퇴가 완료되었습니다 ㅜ.ㅜ");
    } catch (e) {
      debugPrint(e.toString());
      await showTextDialog(Get.context!, "회원 탈퇴 중 문제가 발생하였습니다.");
    }
  }
}
