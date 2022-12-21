import 'dart:io';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/domain/models/email_code_model.dart';
import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/bad_request_exception.dart';
import '../../domain/exceptions/exceptions.dart';
import '../../domain/models/metadata_model.dart';
import '../../domain/models/personal_information_model.dart';
import '../../domain/models/try_create_user_model.dart';

class UserService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final DbService _dbService = DbService();

  Future<UserModel?> getUserByIdFromApi({required String userId}) async {
    try {
      return await _repository.getUserById(userId: userId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<UserModel?> getUserByIdFromDb({required String userId}) async {
    return await _dbService.getUserModelById(userId: userId);
  }

  Future updateUserInDb({required String userId}) async {
    var userModel = await getUserByIdFromApi(userId: userId);
    if (userModel != null) {
      await _dbService.createUpdateUser(userModel: userModel);
    }
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

  Future tryCreateUser(TryCreateUserModel tryCreateUserModel) async {
    try {
      await _repository.tryCreateUser(tryCreateUserModel);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }

  Future createUser(
      {required TryCreateUserModel tryCreateUserModel,
      required EmailCodeModel emailCodeModel}) async {
    try {
      await _repository.createUser(
          tryCreateUserModel: tryCreateUserModel,
          emailCodeModel: emailCodeModel);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }

  Future<String> sendSingUpCode(String email) async {
    return (await _repository.sendSingUpCode(email)).id;
  }

  Future updateBirthday({required DateTime? birthday}) async {
    await _repository.updateBirthday(birthday: birthday);
  }

  Future addAvatar({required MetadataModel metadataModel}) async {
    await _repository.addAvatar(metadataModel: metadataModel);
  }
}
