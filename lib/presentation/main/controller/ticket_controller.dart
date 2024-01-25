import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/app/service/auth_service.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/like_use_cases.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';
import 'package:ticats/presentation/common/widgets/ticats_dialog.dart';

class TicketController extends GetxController {
  final LikeUseCases likeUseCases = Get.find<LikeUseCases>();
  final TicketUseCases ticketUseCases = Get.find<TicketUseCases>();

  GetLikesUseCase get getLikesUseCase => likeUseCases.getLikesUseCase;
  PostLikeUseCase get postLikeUseCase => likeUseCases.postLikeUseCase;

  ChangeTicketVisibleUseCase get changeTicketVisibleUseCase => ticketUseCases.changeTicketVisibleUseCase;
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

  Future<void> changeTicketVisible(Ticket ticket, bool isPrivate) async {
    try {
      await changeTicketVisibleUseCase.execute(ticket.id!, isPrivate);

      myTicketList.remove(ticket);
      myTicketList.add(ticket.copyWith(isPrivate: isPrivate ? "PRIVATE" : "PUBLIC"));
      myTicketList.sort((a, b) => b.ticketDate.compareTo(a.ticketDate));

      if (isPrivate) {
        totalTicketList.remove(ticket);
      } else {
        totalTicketList.add(ticket.copyWith(isPrivate: isPrivate ? "PRIVATE" : "PUBLIC"));
        totalTicketList.sort((a, b) => b.ticketDate.compareTo(a.ticketDate));
      }

      if (likeTicketList.contains(ticket)) {
        likeTicketList.remove(ticket);
        likeTicketList.add(ticket.copyWith(isPrivate: isPrivate ? "PRIVATE" : "PUBLIC"));
        likeTicketList.sort((a, b) => b.ticketDate.compareTo(a.ticketDate));
      }

      update();
    } catch (e) {
      debugPrint(e.toString());
    }
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
      myTicketList.assignAll(await getMyTicketUseCase.execute(categorys: AuthService.to.member!.member!.categorys));
      likeTicketList.assignAll(await getLikesUseCase.execute());
    }
    totalTicketList.assignAll(await getTotalTicketUseCase.execute(categorys: AuthService.to.member?.member?.categorys ?? []));
    isLoading.value = false;

    update();
  }

  Future<void> getTotalTicket() async {
    isLoading.value = true;

    totalTicketList.clear();
    likeTicketList.clear();

    totalTicketList.assignAll(await getTotalTicketUseCase.execute(categorys: AuthService.to.member?.member?.categorys ?? []));
    if (AuthService.to.isLogin) {
      likeTicketList.assignAll(await getLikesUseCase.execute());
    }

    isLoading.value = false;

    update();
  }

  Future<void> likeTicket(Ticket ticket) async {
    try {
      await postLikeUseCase.execute(ticket.id!);

      if (likeTicketList.contains(ticket)) {
        likeTicketList.remove(ticket);
        await showTextDialog(Get.context!, "좋아요 한 티켓에서 삭제되었습니다!");
      } else {
        likeTicketList.add(ticket);
        await showTextDialog(Get.context!, "좋아요 한 티켓에 저장되었습니다!");
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
