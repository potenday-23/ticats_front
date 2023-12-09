import 'package:get/get.dart';
import 'package:ticats/domain/entities/ticats_member.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository = Get.find<AuthRepository>();

  LoginUseCase get loginUseCase => Get.put(LoginUseCase(_repository));
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<TicatsMember> execute(UserOAuth userOAuth) async {
    TicatsMember user = await _repository.login(userOAuth);

    return user;
  }
}
