import 'package:get/get.dart';

import '../entities/register_entity.dart';
import '../entities/ticats_member.dart';
import '../entities/user_oauth.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository = Get.find<AuthRepository>();

  LoginUseCase get loginUseCase => Get.put(LoginUseCase(_repository));
  RegisterUseCase get registerUseCase => Get.put(RegisterUseCase(_repository));
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<TicatsMember> execute(UserOAuth userOAuth) async {
    TicatsMember user = await _repository.login(userOAuth);

    return user;
  }
}

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<TicatsMember> execute(RegisterEntity registerEntity) async {
    TicatsMember user = await _repository.register(registerEntity);

    return user;
  }
}
