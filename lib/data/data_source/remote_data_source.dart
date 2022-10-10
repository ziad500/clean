// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:clean/data/network/app_api.dart';
import 'package:clean/data/network/requests.dart';
import 'package:clean/data/response/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(
    this._appServiceClient,
  );

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.email, loginRequest.password);
  }
}
