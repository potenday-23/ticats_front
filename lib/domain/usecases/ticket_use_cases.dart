import 'package:get/get.dart';

import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class TicketUseCases {
  final TicketRepository _repository = Get.find<TicketRepository>();

  GetMyTicketUseCase get getMyTicketUseCase => Get.put(GetMyTicketUseCase(_repository));
  GetTotalTicketUseCase get getTotalTicketUseCase => Get.put(GetTotalTicketUseCase(_repository));
}

class GetMyTicketUseCase {
  final TicketRepository _repository;
  GetMyTicketUseCase(this._repository);

  Future<List<Ticket>> execute({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<Ticket> result = await _repository.getMyTicket();

    return result;
  }
}

class GetTotalTicketUseCase {
  final TicketRepository _repository;
  GetTotalTicketUseCase(this._repository);

  Future<List<Ticket>> execute({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<Ticket> result = await _repository.getTotalTicket();

    return result;
  }
}