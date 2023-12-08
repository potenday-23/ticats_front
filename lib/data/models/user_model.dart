import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required TokenModel? token,
    required MemberModel? member,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
}

@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    required String? accessToken,
    required String? refreshToken,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, Object?> json) => _$TokenModelFromJson(json);
}

@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    required int? id,
    required String? nickname,
    required String? profileUrl,
    required String? marketingAgree,
    required String? pushAgree,
    required DateTime? createdDate,
    required DateTime? updatedDate,
    required List<String>? categorys,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, Object?> json) => _$MemberModelFromJson(json);
}
