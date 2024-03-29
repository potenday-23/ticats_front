import '../entities/ticket.dart';

abstract class TicketRepository {
  Future<void> changeTicketVisible(int ticketId, bool isPrivate);

  Future<void> deleteTicket(int ticketId);

  Future<List<Ticket>> getTotalTicket({
    String? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  });

  Future<List<Ticket>> getMyTicket({
    String? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  });

  Future<Ticket> postTicket(Ticket ticket);

  Future<List<Ticket>> searchTicket({
    String? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  });
}
