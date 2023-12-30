import 'package:image_picker/image_picker.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

import '../entities/member_oauth.dart';

abstract class MemberRepository {
  Future<bool> checkNickname(String nickname);
  Future<bool> checkMember(MemberOAuth memberOAuth);
  Future<void> resignMember(List<int> resignReason);
  Future<Member> patchMember(String nickname, XFile? image);
}
