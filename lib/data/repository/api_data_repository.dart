import 'package:desgram_ui/data/clients/api_client.dart';
import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:desgram_ui/domain/models/personal_information_model.dart';
import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/domain/models/profile_model.dart';
import 'package:desgram_ui/domain/models/refresh_token_request_model.dart';
import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _authClient;
  final ApiClient _apiClient;

  ApiDataRepository(this._authClient, this._apiClient);

  @override
  Future<TokenModel?> getToken({
    required String login,
    required String password,
  }) async {
    return _authClient
        .getToken(TokenRequestModel(login: login, password: password));
  }

  @override
  Future<UserModel?> getCurrentUser() {
    return _apiClient.getCurrentUser();
  }

  @override
  Future updateProfile({String? fullName, String? biography}) async {
    await _apiClient
        .updateProfile(ProfileModel(biography: biography, fullName: fullName));
  }

  @override
  Future<List<PostModel>?> getPostsByUserId({
    required String userId,
    required int skip,
    required int take,
  }) async {
    return await _apiClient.getPostsByUserId(userId, skip, take);
  }

  @override
  Future<TokenModel?> refreshToken({required String refreshToken}) async {
    return await _authClient
        .refreshToken(RefreshTokenRequestModel(refreshToken: refreshToken));
  }

  @override
  Future<PersonalInformationModel?> getPersonalInformation() async {
    return await _apiClient.getPersonalInformation();
  }
}
