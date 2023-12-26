import 'package:get/get.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/usecases/ticket_use_cases.dart';
import 'package:ticats/presentation/main/controller/ticket_controller.dart';

class MakeTicketController extends GetxController {
  TicketUseCases get ticketUseCases => Get.find<TicketUseCases>();
  DeleteTicketUseCase get deleteTicketUseCase => ticketUseCases.deleteTicketUseCase;

  List<Ticket> get myTicketList => Get.find<TicketController>().myTicketList;

  final RxBool isEditing = false.obs;

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }
}
