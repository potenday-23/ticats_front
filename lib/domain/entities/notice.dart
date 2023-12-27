import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';
part 'notice.g.dart';

@freezed
class Notice with _$Notice {
  const factory Notice({
    required String title,
    required String content,
    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _Notice;

  factory Notice.fromJson(Map<String, Object?> json) => _$NoticeFromJson(json);
}
