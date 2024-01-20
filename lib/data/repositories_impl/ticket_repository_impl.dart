import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:ticats/domain/entities/ticket.dart';
import 'package:ticats/domain/repositories/ticket_repository.dart';

import '../datasources/remote/ticket_api.dart';
import '../models/ticket_model.dart';
import 'mapper/ticket_mapper.dart';

final TicketMappr _ticketMappr = TicketMappr();

class TicketRepositoryImpl extends TicketRepository {
  final TicketAPI _api = Get.find();

  @override
  Future<void> changeTicketVisible(int ticketId, bool isPrivate) {
    return _api.changeTicketVisible(ticketId, {
      'isPrivate': isPrivate ? "PRIVATE" : "PUBLIC",
    });
  }

  @override
  Future<void> deleteTicket(int ticketId) async {
    await _api.deleteTicket(ticketId);
  }

  @override
  Future<List<Ticket>> getTotalTicket({
    String? categorys,
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
    String? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<TicketModel> myTicketList = await _api.getMyTicket(categorys: categorys, period: period, start: start, end: end, search: search);

    return _ticketMappr.convertList<TicketModel, Ticket>(myTicketList);
  }

  @override
  Future<Ticket> postTicket(Ticket ticket) async {
    var data = {
      'request': MultipartFile.fromString(
        jsonEncode({
          'title': ticket.title,
          'ticketDate': DateFormat('yyyy-MM-ddTHH:mm:ss').format(ticket.ticketDate),
          'rating': ticket.rating,
          'memo': ticket.memo,
          'ticketType': ticket.ticketType.index,
          'layoutType': ticket.layoutType.index,
          'color': ticket.color,
          'categoryName': ticket.category!.name,
          'isPrivate': ticket.isPrivate,
        }),
        contentType: MediaType('application', 'json'),
      ),
      'image': await MultipartFile.fromFile(ticket.imagePath!, filename: DateTime.now().millisecondsSinceEpoch.toString()),
    };

    TicketModel ticketModel = await _api.postTicket(data);

    return _ticketMappr.convert<TicketModel, Ticket>(ticketModel);
  }

  @override
  Future<List<Ticket>> searchTicket({
    String? categorys,
    String? period,
    String? start,
    String? end,
    String? search,
  }) async {
    List<TicketModel> searchTicketList =
        await _api.searchTicket(categorys: categorys, period: period, start: start, end: end, search: search);

    return _ticketMappr.convertList<TicketModel, Ticket>(searchTicketList);
  }
}
