import 'package:freezed_annotation/freezed_annotation.dart';

part 'version.freezed.dart';
part 'version.g.dart';

@freezed
class Version with _$Version {
  const factory Version({
    required int id,
    required String version,
    required DateTime createdDate,
    required DateTime updatedDate,
  }) = _Version;

  factory Version.fromJson(Map<String, Object?> json) => _$VersionFromJson(json);
}
