import 'package:clean/app/app_preferences.dart';
import 'package:clean/data/data_source/remote_data_source.dart';
import 'package:clean/data/network/app_api.dart';
import 'package:clean/data/network/dio_factory.dart';
import 'package:clean/data/network/network_info.dart';
import 'package:clean/data/repository/repository_impl.dart';
import 'package:clean/domain/repository/repository.dart';
import 'package:clean/domain/usecase/forgot_password_usecase.dart';
import 'package:clean/domain/usecase/home_usecase.dart';
import 'package:clean/domain/usecase/login_usecase.dart';
import 'package:clean/domain/usecase/register_usecase.dart';
import 'package:clean/domain/usecase/store_details_usecase.dart';
import 'package:clean/presentation/forgot_password/viewmodel/forget_password_viewmodel.dart';
import 'package:clean/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:clean/presentation/main_screen/pages/home/viewmodel/home_viewmodel.dart';
import 'package:clean/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:clean/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local_data_source.dart';

final instance = GetIt.instance;
Future<void> initAppModule() async {
/*    app module, it's a module where we put all generic dependancies */
  //shared preference instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  //network info instance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
  //dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  //app service client instance
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  //remote data source instance
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));

  //Local data source instance
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //repository instance
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));

    instance.registerFactory<ForgetPasswordViewModel>(
        () => ForgetPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));

    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));

    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance()));

    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance()));
  }
}
