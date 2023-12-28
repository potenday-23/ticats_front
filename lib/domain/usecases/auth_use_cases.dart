import 'package:get/get.dart';

import '../entities/register_entity.dart';
import '../entities/ticats_member.dart';
import '../entities/member_oauth.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository = Get.find<AuthRepository>();

  LoginUseCase get loginUseCase => Get.put(LoginUseCase(_repository));
  RegisterUseCase get registerUseCase => Get.put(RegisterUseCase(_repository));
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<TicatsMember> execute(MemberOAuth memberOAuth) async {
    TicatsMember member = await _repository.login(memberOAuth);

    return member;
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<TicatsMember> execute(RegisterEntity registerEntity) async {
    TicatsMember member = await _repository.register(registerEntity);

    return member;
  }
}

class SaveCategorysUseCase {
  final AuthRepository _repository;
  SaveCategorysUseCase(this._repository);

  Future<TicatsMember> execute(List<String> categorys) async {
    TicatsMember member = await _repository.saveCategorys(categorys);

    return member;
  }
}
