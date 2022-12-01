import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST("/api/Auth/Token")
  Future<TokenModel?> getToken(@Body() TokenRequestModel body);
}
