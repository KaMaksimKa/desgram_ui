import 'package:desgram_ui/domain/models/create_user_model.dart';
import 'package:desgram_ui/domain/models/guid_id_model.dart';
import 'package:desgram_ui/domain/models/refresh_token_request_model.dart';
import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:desgram_ui/domain/models/try_create_user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST("/api/Auth/Token")
  Future<TokenModel?> getToken(@Body() TokenRequestModel body);

  @POST("/api/Auth/RefreshToken")
  Future<TokenModel?> refreshToken(@Body() RefreshTokenRequestModel body);

  @POST("/api/User/TryCreateUser")
  Future tryCreateUser(@Body() TryCreateUserModel body);

  @POST("/api/User/SendSingUpCode")
  Future<GuidIdModel> sendSingUpCode(@Query("email") String email);

  @POST("/api/User/CreateUser")
  Future createUser(@Body() CreateUserModel body);
}
