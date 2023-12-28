import '../entities/register_entity.dart';
import '../entities/ticats_member.dart';
import '../entities/member_oauth.dart';

abstract class AuthRepository {
  Future<TicatsMember> login(MemberOAuth memberOAuth);
  Future<TicatsMember> register(RegisterEntity registerEntity);
  Future<TicatsMember> saveCategorys(List<String> categorys);
}
