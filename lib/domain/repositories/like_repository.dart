import '../entities/ticket.dart';

abstract class LikeRepository {
  Future<List<Ticket>> getLikes();
  Future<void> postLike(int ticketId);
}
