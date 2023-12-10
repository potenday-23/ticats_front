import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/user_oauth.dart';

const String userKey = 'user';
const String userOAuthKey = 'oauth';

class AuthLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<void> deleteUser() async {
    await storage.delete(key: userKey);
  }

  Future<void> deleteUserOAuth() async {
    await storage.delete(key: userOAuthKey);
  }

  Future<TicatsMember?> getUser() async {
    final user = await storage.read(key: userKey);

    if (user != null) {
      return TicatsMember.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  Future<UserOAuth?> getUserOAuth() async {
    final user = await storage.read(key: userOAuthKey);

    if (user != null) {
      return UserOAuth.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  Future<void> saveUser(TicatsMember user) async {
    await storage.write(key: userKey, value: jsonEncode(user.toJson()));
  }

  Future<void> saveUserOAuth(UserOAuth userOAuth) async {
    await storage.write(key: userOAuthKey, value: jsonEncode(userOAuth.toJson()));
  }
}
