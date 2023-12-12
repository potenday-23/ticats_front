import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticats/data/models/ticats_member_model.dart';

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
    required String? seat,
    required String? location,
    required int? price,
    required String? friend,
    required String color,
    required String? ticketType,
    required String? layoutType,
    bool? isLike,
    String? isPrivate,
    Category? category,
    MemberModel? member,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, Object?> json) => _$TicketFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
  }) = _Category;

  factory Category.fromJson(Map<String, Object?> json) => _$CategoryFromJson(json);
}
