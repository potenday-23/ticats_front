import 'package:ticats/domain/entities/ticats_member.dart';

abstract class MemberRepository {
  Future<bool> checkNickname(String nickname);
  Future<bool> checkUser(UserOAuth userOAuth);
}
