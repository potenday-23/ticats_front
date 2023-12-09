import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

const String userKey = 'user';

class AuthLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<void> deleteUser() async {
    await storage.delete(key: userKey);
  }

  Future<TicatsMember?> getUser() async {
    final user = await storage.read(key: userKey);

    if (user != null) {
      return TicatsMember.fromJson(jsonDecode(user));
    } else {
      return null;
    }
  }

  Future<void> saveUser(TicatsMember user) async {
    await storage.write(key: userKey, value: jsonEncode(user.toJson()));
  }
}
