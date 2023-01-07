import 'dart:io';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/domain/models/user/change_password_model.dart';
import 'package:desgram_ui/domain/models/user/change_user_name_model.dart';
import 'package:desgram_ui/domain/models/user/email_code_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/bad_request_exception.dart';
import '../../domain/exceptions/exceptions.dart';
import '../../domain/models/attach/metadata_model.dart';
import '../../domain/models/user/change_email_model.dart';
import '../../domain/models/user/partial_user_model.dart';
import '../../domain/models/user/personal_information_model.dart';
import '../../domain/models/user/try_create_user_model.dart';

class UserService {
  static final List<Function({required UserModel userModel})>
      updateUserListeners = [];
  static _invokeUpdateUserListeners({required UserModel userModel}) {
    for (var listener in updateUserListeners) {
      listener(userModel: userModel);
    }
  }

  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final DbService _dbService = DbService();

  Future<UserModel?> getUserByIdFromApi({required String userId}) async {
    try {
      return await _repository.getUserById(userId: userId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        return null;
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
      _invokeUpdateUserListeners(userModel: userModel);
      await _dbService.createUpdateUser(userModel: userModel);
    }
  }

  Future updateProfile({
    String? fullName,
    String? biography,
  }) async {
    try {
      await _repository.updateProfile(fullName: fullName, biography: biography);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<PersonalInformationModel?> getPersonalInformation() async {
    try {
      return await _repository.getPersonalInformation();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
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

  Future getCurrentUserId() async {
    return await SharedPrefs.getCurrentUserId();
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
    try {
      return (await _repository.sendSingUpCode(email)).id;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future updateBirthday({required DateTime? birthday}) async {
    try {
      await _repository.updateBirthday(birthday: birthday?.toUtc());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future addAvatar({required MetadataModel metadataModel}) async {
    try {
      await _repository.addAvatar(metadataModel: metadataModel);
      await updateUserInDb(userId: await getCurrentUserId());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future deleteAvatar() async {
    try {
      await _repository.deleteAvatar();
      await updateUserInDb(userId: await getCurrentUserId());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        await updateUserInDb(userId: await getCurrentUserId());
      } else {
        rethrow;
      }
    }
  }

  Future<List<PartialUserModel>?> searchUsersByName(
      {required String searchUserName,
      required int skip,
      required int take}) async {
    try {
      return await _repository.searchUsersByName(
          searchUserName: searchUserName, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<UserModel?> getCurrentUserFromDb() async {
    var currentUserId = await getCurrentUserId();
    if (currentUserId == null) {
      return null;
    }
    return await _dbService.getUserModelById(userId: currentUserId);
  }

  Future changeAccountAvailability({required bool isPrivate}) async {
    try {
      await _repository.changeAccountAvailability(isPrivate: isPrivate);
      await updateUserInDb(userId: await getCurrentUserId());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future tryChangeEmail({required String email}) async {
    try {
      await _repository.tryChangeEmail(newEmail: email);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }

  Future changeEmail(
      {required String newEmail,
      required EmailCodeModel emailCodeModel}) async {
    try {
      await _repository.changeEmail(
          changeEmailModel: ChangeEmailModel(
              newEmail: newEmail, emailCodeModel: emailCodeModel));
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }

  Future<String> sendChangeEmailCode({required String newEmail}) async {
    try {
      return (await _repository.sendChangeEmailCode(newEmail: newEmail)).id;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future chagePassword(
      {required String oldPassword,
      required String newPassword,
      required String retryNewPassword}) async {
    try {
      await _repository.changePassword(
          changePasswordModel: ChangePasswordModel(
              oldPassword: oldPassword,
              newPassword: newPassword,
              retryNewPassword: retryNewPassword));
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }

  Future changeUserName({required String newName}) async {
    try {
      await _repository.changeUserName(
          changeUserNameModel: ChangeUserNameModel(newName: newName));
      await updateUserInDb(userId: await getCurrentUserId());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      }
    }
  }
}
