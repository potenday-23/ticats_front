import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/ticket_model.dart';

part 'ticket_api.g.dart';

@RestApi()
abstract class TicketAPI {
  factory TicketAPI(Dio dioBuilder) = _TicketAPI;

  @DELETE('/tickets/{ticketId}')
  Future<void> deleteTicket(@Path('ticketId') int ticketId);

  @GET('/tickets/my')
  Future<List<TicketModel>> getMyTicket({
    @Query('categorys') List<String>? categorys,
    @Query('period') String? period,
    @Query('start') String? start,
    @Query('end') String? end,
    @Query('search') String? search,
  });

  @GET('/tickets/total')
  Future<List<TicketModel>> getTotalTicket({
    @Query('categorys') List<String>? categorys,
    @Query('period') String? period,
    @Query('start') String? start,
    @Query('end') String? end,
    @Query('search') String? search,
  });

  @POST('/tickets')
  @MultiPart()
  Future<TicketModel> postTicket(@Part(contentType: "application/json") Map<String, MultipartFile> request);

  @GET('/tickets/my-total')
  Future<List<TicketModel>> searchTicket({
    @Query('categorys') String? categorys,
    @Query('period') String? period,
    @Query('start') String? start,
    @Query('end') String? end,
    @Query('search') String? search,
  });
}
