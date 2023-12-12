import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTotalTicket({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  });

  Future<List<Ticket>> getMyTicket({
    List<String>? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  });
}