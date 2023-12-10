import '../entities/user_oauth.dart';

abstract class MemberRepository {
  Future<bool> checkNickname(String nickname);
  Future<bool> checkUser(UserOAuth userOAuth);
}
