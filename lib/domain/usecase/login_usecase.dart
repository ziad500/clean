// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/data/network/requests.dart';
import 'package:dartz/dartz.dart';

import 'package:clean/data/network/failure.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/repository/repository.dart';
import 'package:clean/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authantication> {
  final Repository _repository;
  LoginUseCase(
    this._repository,
  );
  @override
  Future<Either<Failure, Authantication>> execude(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(
    this.email,
    this.password,
  );
}
