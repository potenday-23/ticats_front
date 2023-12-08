import 'package:ticats/domain/entities/user.dart';

abstract class AuthRepository {
  Future<bool> checkUser(UserOAuth userOAuth);
  Future<User> login(UserOAuth userOAuth);
}
