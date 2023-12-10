import 'package:get/get.dart';

import '../entities/user_oauth.dart';
import '../repositories/member_repository.dart';

class MemberUseCases {
  final MemberRepository _repository = Get.find<MemberRepository>();

  CheckNicknameUseCase get checkNicknameUseCase => Get.put(CheckNicknameUseCase(_repository));
  CheckUserUseCase get checkUserUseCase => Get.put(CheckUserUseCase(_repository));
}

class CheckNicknameUseCase {
  final MemberRepository _repository;
  CheckNicknameUseCase(this._repository);

  Future<bool> execute(String nickname) async {
    bool result = await _repository.checkNickname(nickname);

    return result;
  }
}

class CheckUserUseCase {
  final MemberRepository _repository;
  CheckUserUseCase(this._repository);

  Future<bool> execute(UserOAuth userOMember) async {
    bool result = await _repository.checkUser(userOMember);

    return result;
  }
}
