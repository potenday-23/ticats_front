import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<void> deleteTicket(int ticketId);

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

  Future<Ticket> postTicket(Ticket ticket, bool isPrivate);
}
