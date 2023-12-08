import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required Token? token,
    required Member? member,
    required UserOAuth? userOAuth,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

@freezed
class Token with _$Token {
  const factory Token({
    required String? accessToken,
    required String? refreshToken,
  }) = _Token;

  factory Token.fromJson(Map<String, Object?> json) => _$TokenFromJson(json);
}

@freezed
class Member with _$Member {
  const factory Member({
    required int? id,
    required String? nickname,
    required String? profileUrl,
    required String? marketingAgree,
    required String? pushAgree,
    required DateTime? createdDate,
    required DateTime? updatedDate,
    required List<String>? categorys,
  }) = _Member;

  factory Member.fromJson(Map<String, Object?> json) => _$MemberFromJson(json);
}

@freezed
class UserOAuth with _$UserOAuth {
  const factory UserOAuth({
    required String socialId,
    required String socialType,
  }) = _UserOAuth;

  factory UserOAuth.fromJson(Map<String, Object?> json) => _$UserOAuthFromJson(json);
}
