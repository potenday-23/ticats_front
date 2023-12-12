import 'package:get/get.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';

class TicketController extends GetxController {
  get getTotalTicketUseCase => Get.find<TicketUseCases>().getTotalTicketUseCase;

  RxList<Ticket> totalTicketList = <Ticket>[].obs;

  @override
  void onInit() async {
    super.onInit();

    totalTicketList.assignAll(await getTotalTicketUseCase.execute());
  }
}
