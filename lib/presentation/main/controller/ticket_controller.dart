import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

class TicketController extends GetxController {
  final TicketUseCases ticketUseCases = Get.find<TicketUseCases>();

  DeleteTicketUseCase get deleteTicketUseCase => ticketUseCases.deleteTicketUseCase;
  GetMyTicketUseCase get getMyTicketUseCase => ticketUseCases.getMyTicketUseCase;
  GetTotalTicketUseCase get getTotalTicketUseCase => ticketUseCases.getTotalTicketUseCase;

  RxList<Ticket> myTicketList = <Ticket>[].obs;
  RxList<Ticket> totalTicketList = <Ticket>[].obs;

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
      totalTicketList.removeWhere((element) => element.id == ticketId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getTickets() async {
    myTicketList.assignAll(await getMyTicketUseCase.execute());
    totalTicketList.assignAll(await getTotalTicketUseCase.execute());
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }
}
