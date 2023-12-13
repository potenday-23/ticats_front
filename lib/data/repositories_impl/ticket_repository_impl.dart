import 'package:get/get.dart';
import '../models/ticket_model.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/repositories/ticket_repository.dart';

import '../datasources/remote/ticket_api.dart';
import 'mapper/ticket_mapper.dart';

final TicketMappr _ticketMappr = TicketMappr();

class TicketRepositoryImpl extends TicketRepository {
  final TicketAPI _api = Get.find();

  @override
  Future<List<Ticket>> getTotalTicket({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<TicketModel> totalTicketList =
        await _api.getTotalTicket(categorys: categorys, period: period, start: start, end: end, search: search);

    return _ticketMappr.convertList<TicketModel, Ticket>(totalTicketList);
  }

  @override
  Future<List<Ticket>> getMyTicket({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<TicketModel> myTicketList =
        await _api.getMyTicket(categorys: categorys, period: period, start: start, end: end, search: search);

    return _ticketMappr.convertList<TicketModel, Ticket>(myTicketList);
  }
}
