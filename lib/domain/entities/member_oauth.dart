import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_oauth.freezed.dart';
part 'member_oauth.g.dart';

@freezed
class MemberOAuth with _$MemberOAuth {
  const factory MemberOAuth({
    required String socialId,
    required String socialType,
  }) = _MemberOAuth;

  factory MemberOAuth.fromJson(Map<String, Object?> json) => _$MemberOAuthFromJson(json);
}
