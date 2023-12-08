import 'package:get/get.dart';
import 'package:ticats/data/repositories_impl/auth_repository_impl.dart';
import 'package:ticats/domain/entities/user.dart';
import 'package:ticats/domain/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository = Get.find<AuthRepositoryImpl>();

  LoginUseCase get loginUseCase => Get.put(LoginUseCase(_repository));
  CheckUserUseCase get checkUserUseCase => Get.put(CheckUserUseCase(_repository));
}

class CheckUserUseCase {
  final AuthRepository _repository;
  CheckUserUseCase(this._repository);

  Future<bool> execute(UserOAuth userOAuth) async {
    bool result = await _repository.checkUser(userOAuth);

    return result;
  }
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<User> execute(UserOAuth userOAuth) async {
    User user = await _repository.login(userOAuth);

    return user;
  }
}
