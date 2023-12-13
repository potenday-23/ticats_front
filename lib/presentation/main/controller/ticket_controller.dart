import 'package:get/get.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

class TicketController extends GetxController {
  final TicketUseCases ticketUseCases = Get.find<TicketUseCases>();

  GetMyTicketUseCase get getMyTicketUseCase => ticketUseCases.getMyTicketUseCase;
  GetTotalTicketUseCase get getTotalTicketUseCase => ticketUseCases.getTotalTicketUseCase;

  RxList<Ticket> myTicketList = <Ticket>[].obs;
  RxList<Ticket> totalTicketList = <Ticket>[].obs;

  @override
  void onInit() async {
    super.onInit();

    totalTicketList.assignAll(await getTotalTicketUseCase.execute());
    myTicketList.assignAll(await getMyTicketUseCase.execute());
  }
}
