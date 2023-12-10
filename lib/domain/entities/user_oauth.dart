import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_oauth.freezed.dart';
part 'user_oauth.g.dart';

@freezed
class UserOAuth with _$UserOAuth {
  const factory UserOAuth({
    required String socialId,
    required String socialType,
  }) = _UserOAuth;

  factory UserOAuth.fromJson(Map<String, Object?> json) => _$UserOAuthFromJson(json);
}
