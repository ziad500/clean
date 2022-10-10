// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/data/mapper/mapper.dart';
import 'package:clean/data/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import 'package:clean/data/data_source/remote_data_source.dart';
import 'package:clean/data/network/failure.dart';
import 'package:clean/data/network/network_info.dart';
import 'package:clean/data/network/requests.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/repository/repository.dart';
import 'package:dio/dio.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, Authantication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected
      try {
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          //success
          return right(response.toDomain());
        } else {
          //failure
          return left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        //use error handler
        return left(ErrorHandler.handle(error).failure);
      }
    } else {
      //its not conntected
      return left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
