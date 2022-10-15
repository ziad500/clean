import 'package:clean/data/network/failure.dart';
import 'package:clean/data/network/requests.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../repository/repository.dart';

class ForgotPasswordUseCase
    extends BaseUseCase<ForgotPasswordUseCaseInput, ForgotPassword> {
  final Repository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ForgotPassword>> execude(
      ForgotPasswordUseCaseInput input) async {
    return await _repository.forgotPassword(ForgotPasswordRequest(input.email));
  }
}

class ForgotPasswordUseCaseInput {
  String email;
  ForgotPasswordUseCaseInput(this.email);
}
