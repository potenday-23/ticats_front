import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:ticats/data/models/category_model.dart';
import 'package:ticats/data/models/ticats_member_model.dart';
import 'package:ticats/data/models/ticket_model.dart';
import 'package:ticats/domain/entities/category.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/ticket.dart';

import 'ticket_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<TicketModel, Ticket>(),
  MapType<CategoryModel, Category>(),
  MapType<MemberModel, Member>(),
])
class TicketMappr extends $TicketMappr {}
