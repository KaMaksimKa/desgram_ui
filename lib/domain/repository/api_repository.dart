import '../models/token_model.dart';

abstract class ApiRepository {
  Future<TokenModel?> getToken(
      {required String login, required String password});
}
