import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/presentation/common/enum/ticket_enum.dart';

import 'category.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    int? id,
    required String title,
    String? imageUrl,
    String? imagePath,
    required DateTime ticketDate,
    required double rating,
    required String? memo,
    String? seat,
    String? location,
    int? price,
    String? friend,
    String? color,
    required TicketType ticketType,
    required TicketLayoutType layoutType,
    bool? isLike,
    String? isPrivate,
    Category? category,
    Member? member,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, Object?> json) => _$TicketFromJson(json);
}
