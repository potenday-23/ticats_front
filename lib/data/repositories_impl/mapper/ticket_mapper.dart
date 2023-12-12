import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:ticats/data/models/ticket_model.dart';
import 'package:ticats/domain/entities/ticket.dart';

import 'ticket_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<TicketModel, Ticket>(),
  MapType<CategoryModel, Category>(),
])
class TicketMappr extends $TicketMappr {}
