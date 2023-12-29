import 'package:get/get.dart';

import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';

class TicketUseCases {
  final TicketRepository _repository = Get.find<TicketRepository>();

  DeleteTicketUseCase get deleteTicketUseCase => Get.put(DeleteTicketUseCase(_repository));
  GetMyTicketUseCase get getMyTicketUseCase => Get.put(GetMyTicketUseCase(_repository));
  GetTotalTicketUseCase get getTotalTicketUseCase => Get.put(GetTotalTicketUseCase(_repository));
  PostTicketUseCase get postTicketUseCase => Get.put(PostTicketUseCase(_repository));
  SearchTicketUseCase get searchTicketUseCase => Get.put(SearchTicketUseCase(_repository));
}

class DeleteTicketUseCase {
  final TicketRepository _repository;
  DeleteTicketUseCase(this._repository);

  Future<void> execute(int ticketId) async {
    await _repository.deleteTicket(ticketId);
  }
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

class PostTicketUseCase {
  final TicketRepository _repository;
  PostTicketUseCase(this._repository);

  Future<Ticket> execute(Ticket ticket, bool isPrivate) async {
    Ticket result = await _repository.postTicket(ticket, isPrivate);

    return result;
  }
}

class SearchTicketUseCase {
  final TicketRepository _repository;
  SearchTicketUseCase(this._repository);

  Future<List<Ticket>> execute({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    String categorysString = categorys!.join(',');

    List<Ticket> result = await _repository.searchTicket(
      categorys: categorysString,
      period: period,
      start: start,
      end: end,
      search: search,
    );

    return result;
  }
}
