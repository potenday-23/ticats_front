import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/entities/member_oauth.dart';

const String memberKey = 'member';
const String memberOAuthKey = 'oauth';

class AuthLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<void> deleteMember() async {
    await storage.delete(key: memberKey);
  }

  Future<void> deleteMemberOAuth() async {
    await storage.delete(key: memberOAuthKey);
  }

  Future<TicatsMember?> getMember() async {
    final member = await storage.read(key: memberKey);

    if (member != null) {
      return TicatsMember.fromJson(jsonDecode(member));
    } else {
      return null;
    }
  }

  Future<MemberOAuth?> getMemberOAuth() async {
    final member = await storage.read(key: memberOAuthKey);

    if (member != null) {
      return MemberOAuth.fromJson(jsonDecode(member));
    } else {
      return null;
    }
  }

  Future<void> saveMember(TicatsMember member) async {
    await storage.write(key: memberKey, value: jsonEncode(member.toJson()));
  }

  Future<void> saveMemberOAuth(MemberOAuth memberOAuth) async {
    await storage.write(key: memberOAuthKey, value: jsonEncode(memberOAuth.toJson()));
  }
}
