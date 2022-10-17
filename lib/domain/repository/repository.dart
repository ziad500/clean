import 'package:clean/data/network/failure.dart';
import 'package:clean/data/network/requests.dart';
import 'package:clean/domain/model/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, Authantication>> login(LoginRequest loginRequest);

  Future<Either<Failure, ForgotPassword>> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest);

  Future<Either<Failure, Authantication>> register(
      RegisterRequest registerRequest);
}
