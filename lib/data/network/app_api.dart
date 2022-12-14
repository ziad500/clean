import 'package:clean/app/constants.dart';
import 'package:clean/data/response/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/customers/login")
  Future<AuthenticationResponse> login(
      @Field("email") String email, @Field("password") String password);

  @POST("/customers/forgotPassword")
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);

  @POST("/customers/register")
  Future<AuthenticationResponse> register(
      @Field("userName") String userName,
      @Field("countryMobileCode") String countryMobileCode,
      @Field("mobileNumber") String mobileNumber,
      @Field("email") String email,
      @Field("password") String password,
      @Field("profilePicture") String profilePicture);

  @GET("/home")
  Future<HomeResponse> getHome();

  @GET("/storeDetails/1")
  Future<StoreDetailsResponse> getStoreDetails();
}
