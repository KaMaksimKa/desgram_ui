import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _authClient;
  ApiDataRepository(
    this._authClient,
  );
  @override
  Future<TokenModel?> getToken({
    required String login,
    required String password,
  }) async {
    return _authClient
        .getToken(TokenRequestModel(login: login, password: password));
  }
}
