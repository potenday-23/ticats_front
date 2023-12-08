import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticats/domain/entities/user.dart';

const String userKey = 'user';

class AuthLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<void> deleteUser() async {
    await storage.delete(key: userKey);
  }

  Future<User?> getUser() async {
    final user = await storage.read(key: userKey);

    if (user != null) {
      return User.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    await storage.write(key: userKey, value: jsonEncode(user.toJson()));
  }
}
