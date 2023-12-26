import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticats/data/models/ticats_member_model.dart';
import 'package:ticats/presentation/common/enum/ticket_enum.dart';

import 'category_model.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
class TicketModel with _$TicketModel {
  const factory TicketModel({
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
    CategoryModel? category,
    MemberModel? member,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, Object?> json) => _$TicketModelFromJson(json);
}
