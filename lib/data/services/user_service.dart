import 'dart:io';

import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';

import '../../domain/models/personal_information_model.dart';

class UserService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();

  Future<UserModel?> getCurrentUser() {
    return _repository.getCurrentUser();
  }

  Future updateProfile({
    String? fullName,
    String? biography,
  }) async {
    await _repository.updateProfile(fullName: fullName, biography: biography);
  }

  Future<PersonalInformationModel?> getPersonalInformation() async {
    return await _repository.getPersonalInformation();
  }
}
