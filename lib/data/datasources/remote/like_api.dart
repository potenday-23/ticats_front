import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:ticats/data/models/ticket_model.dart';

part 'like_api.g.dart';

@RestApi()
abstract class LikeAPI {
  factory LikeAPI(Dio dioBuilder) = _LikeAPI;

  @GET('/likes')
  Future<List<TicketModel>> getLikes();

  @POST('/likes')
  Future<void> postLike(@Path('ticketId') int ticketId);
}
