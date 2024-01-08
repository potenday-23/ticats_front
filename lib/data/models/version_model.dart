import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
class VersionModel with _$VersionModel {
  const factory VersionModel({
    required int id,
    required String version,
    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _VersionModel;

  factory VersionModel.fromJson(Map<String, Object?> json) => _$VersionModelFromJson(json);
}
