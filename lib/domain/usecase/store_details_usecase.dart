import 'package:clean/data/network/failure.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/repository/repository.dart';
import 'package:clean/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class StoreDetailsUseCase extends BaseUseCase<void, StoreDetails> {
  final Repository _repository;
  StoreDetailsUseCase(this._repository);
  @override
  Future<Either<Failure, StoreDetails>> execude(void input) async {
    return await _repository.getStoreDetails();
  }
}
