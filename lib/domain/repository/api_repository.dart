import 'package:desgram_ui/domain/models/user_model.dart';

import '../models/personal_information_model.dart';
import '../models/post_model.dart';
import '../models/token_model.dart';

abstract class ApiRepository {
  Future<TokenModel?> getToken(
      {required String login, required String password});

  Future<TokenModel?> refreshToken({required String refreshToken});

  Future<UserModel?> getCurrentUser();

  Future updateProfile({String? fullName, String? biography});

  Future<List<PostModel>?> getPostsByUserId(
      {required String userId, required int skip, required int take});

  Future<PersonalInformationModel?> getPersonalInformation();
}
