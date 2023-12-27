import 'package:get/get.dart';
import 'package:ticats/data/datasources/remote/like_api.dart';
import 'package:ticats/data/models/ticket_model.dart';
import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/repositories/like_repository.dart';

import 'mapper/ticket_mapper.dart';

final TicketMappr _ticketMappr = TicketMappr();

class LikeRepositoryImpl extends LikeRepository {
  final LikeAPI _api = Get.find();

  @override
  Future<List<Ticket>> getLikes() async {
    List<TicketModel> likeList = await _api.getLikes();

    return _ticketMappr.convertList<TicketModel, Ticket>(likeList);
  }

  @override
  Future<void> postLike(int ticketId) async {
    await _api.postLike(ticketId);
  }
}
