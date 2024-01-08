import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/like_use_cases.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

class TicketController extends GetxController {
  final LikeUseCases likeUseCases = Get.find<LikeUseCases>();
  final TicketUseCases ticketUseCases = Get.find<TicketUseCases>();

  GetLikesUseCase get getLikesUseCase => likeUseCases.getLikesUseCase;
  PostLikeUseCase get postLikeUseCase => likeUseCases.postLikeUseCase;

  DeleteTicketUseCase get deleteTicketUseCase => ticketUseCases.deleteTicketUseCase;
  GetMyTicketUseCase get getMyTicketUseCase => ticketUseCases.getMyTicketUseCase;
  GetTotalTicketUseCase get getTotalTicketUseCase => ticketUseCases.getTotalTicketUseCase;

  RxList<Ticket> myTicketList = <Ticket>[].obs;
  RxList<Ticket> likeTicketList = <Ticket>[].obs;
  RxList<Ticket> totalTicketList = <Ticket>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await getTickets();
  }

  Future<void> deleteTicket(int ticketId) async {
    try {
      await deleteTicketUseCase.execute(ticketId);

      myTicketList.removeWhere((element) => element.id == ticketId);
      likeTicketList.removeWhere((element) => element.id == ticketId);
      totalTicketList.removeWhere((element) => element.id == ticketId);

      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getTickets() async {
    isLoading.value = true;

    myTicketList.clear();
    likeTicketList.clear();
    totalTicketList.clear();

    if (AuthService.to.isLogin) {
      myTicketList.assignAll(await getMyTicketUseCase.execute());
      likeTicketList.assignAll(await getLikesUseCase.execute());

      // HACK : 좋아요한 티켓의 isLike가 null로 옴
      for (int i = 0; i < likeTicketList.length; i++) {
        likeTicketList[i] = likeTicketList[i].copyWith(isLike: true);
      }
    }
    totalTicketList.assignAll(await getTotalTicketUseCase.execute());
    isLoading.value = false;

    update();
  }

  Future<void> likeTicket(Ticket ticket) async {
    try {
      await postLikeUseCase.execute(ticket.id!);

      if (likeTicketList.contains(ticket)) {
        likeTicketList.remove(ticket);
        Fluttertoast.showToast(msg: "좋아요 한 티켓에서 삭제되었습니다!");
      } else {
        likeTicketList.add(ticket);
        Fluttertoast.showToast(msg: "좋아요 한 티켓에 저장되었습니다!");
      }

      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }
}
