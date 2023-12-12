import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticats/data/models/ticats_member_model.dart';

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
    required String? seat,
    required String? location,
    required int? price,
    required String? friend,
    required String color,
    required String? ticketType,
    required String? layoutType,
    bool? isLike,
    String? isPrivate,
    CategoryModel? category,
    MemberModel? member,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, Object?> json) => _$TicketModelFromJson(json);
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, Object?> json) => _$CategoryModelFromJson(json);
}
