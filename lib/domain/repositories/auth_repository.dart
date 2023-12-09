import 'package:ticats/domain/entities/ticats_member.dart';

abstract class AuthRepository {
  Future<TicatsMember> login(UserOAuth userOAuth);
}
