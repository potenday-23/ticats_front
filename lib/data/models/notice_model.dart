import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel {
  const factory NoticeModel({
    required String title,
    required String content,
    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, Object?> json) => _$NoticeModelFromJson(json);
}
