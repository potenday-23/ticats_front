import '../entities/register_entity.dart';
import '../entities/ticats_member.dart';
import '../entities/user_oauth.dart';

abstract class AuthRepository {
  Future<TicatsMember> login(UserOAuth userOAuth);
  Future<TicatsMember> register(RegisterEntity registerEntity);
}
