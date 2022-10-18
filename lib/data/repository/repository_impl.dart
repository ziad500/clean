// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean/data/data_source/local_data_source.dart';
import 'package:clean/data/mapper/mapper.dart';
import 'package:clean/data/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import 'package:clean/data/data_source/remote_data_source.dart';
import 'package:clean/data/network/failure.dart';
import 'package:clean/data/network/network_info.dart';
import 'package:clean/data/network/requests.dart';
import 'package:clean/domain/model/models.dart';
import 'package:clean/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  final NetworkInfo _networkInfo;
  RepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
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

  @override
  Future<Either<Failure, ForgotPassword>> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected
      try {
        final response =
            await _remoteDataSource.forgotPassword(forgotPasswordRequest);
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

  @override
  Future<Either<Failure, Authantication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected
      try {
        final response = await _remoteDataSource.register(registerRequest);
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

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      //get response from cache
      final response = await _localDataSource.getHomeData();
      return right(response.toDomain());
    } catch (cacheError) {
      //cache is not exist or cache is not valid

      //its the time to get from api side
      if (await _networkInfo.isConnected) {
        // its connected
        try {
          final response = await _remoteDataSource.getHomeData();
          if (response.status == ApiInternalStatus.SUCCESS) {
            //success
            // save home response to cache (local data source)
            _localDataSource.saveHomeToCache(response);

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
}
