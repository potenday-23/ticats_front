import '../entities/member_oauth.dart';

abstract class MemberRepository {
  Future<bool> checkNickname(String nickname);
  Future<bool> checkMember(MemberOAuth memberOAuth);
  Future<void> resignMember();
}
