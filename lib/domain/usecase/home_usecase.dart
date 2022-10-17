import 'package:clean/data/network/failure.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/repository/repository.dart';
import 'package:clean/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUseCase extends BaseUseCase<void, HomeObject> {
  final Repository _repository;
  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execude(input) async {
    return await _repository.getHomeData();
  }
}
