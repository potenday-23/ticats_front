import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticats_member.freezed.dart';
part 'ticats_member.g.dart';

@freezed
class TicatsMember with _$TicatsMember {
  const factory TicatsMember({
    required Token? token,
    required Member? member,
  }) = _TicatsMember;

  factory TicatsMember.fromJson(Map<String, Object?> json) => _$TicatsMemberFromJson(json);
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
