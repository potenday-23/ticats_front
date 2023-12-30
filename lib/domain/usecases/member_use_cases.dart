import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticats/domain/entities/ticats_member.dart';

import '../entities/member_oauth.dart';
import '../repositories/member_repository.dart';

class MemberUseCases {
  final MemberRepository _repository = Get.find<MemberRepository>();

  CheckNicknameUseCase get checkNicknameUseCase => Get.put(CheckNicknameUseCase(_repository));
  CheckMemberUseCase get checkMemberUseCase => Get.put(CheckMemberUseCase(_repository));
  PatchMemberUseCase get patchMemberUseCase => Get.put(PatchMemberUseCase(_repository));
  ResignMemberUseCase get resignMemberUseCase => Get.put(ResignMemberUseCase(_repository));
}

class CheckNicknameUseCase {
  final MemberRepository _repository;
  CheckNicknameUseCase(this._repository);

  Future<bool> execute(String nickname) async {
    bool result = await _repository.checkNickname(nickname);

    return result;
  }
}

class CheckMemberUseCase {
  final MemberRepository _repository;
  CheckMemberUseCase(this._repository);

  Future<bool> execute(MemberOAuth memberOAuth) async {
    bool result = await _repository.checkMember(memberOAuth);

    return result;
  }
}

class PatchMemberUseCase {
  final MemberRepository _repository;
  PatchMemberUseCase(this._repository);

  Future<Member> execute(String nickname, XFile? image) async {
    Member result = await _repository.patchMember(nickname, image);
    return result;
  }
}

class ResignMemberUseCase {
  final MemberRepository _repository;
  ResignMemberUseCase(this._repository);

  Future<void> execute(List<int> resignReason) async {
    await _repository.resignMember(resignReason);
  }
}
