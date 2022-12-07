import 'dart:io';

import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/inrernal/config/token_storage.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();

  Future auth(String login, String password) async {
    try {
      var tokenModel =
          await _repository.getToken(login: login, password: password);
      await TokenStorage.setTokenModel(tokenModel);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw WrongCredentionalException();
      } else if (e.response?.statusCode == 404) {
        throw WrongLoginException();
      }
    }
  }

  Future<bool> checkAuth() async {
    if (await TokenStorage.getAccessToken() == null) {
      return false;
    }
    UserModel? userModel;
    try {
      userModel = await _repository.getCurrentUser();
    } on DioError catch (e) {
      TokenStorage.setTokenModel(null);
      return false;
    }

    await SharedPrefs.setCurrentUser(userModel);
    if (userModel == null) {
      TokenStorage.setTokenModel(null);
      return false;
    }
    return true;
  }

  Future logout() async {
    await TokenStorage.setTokenModel(null);
    await SharedPrefs.setCurrentUser(null);
  }
}

class WrongLoginException implements Exception {}

class WrongCredentionalException implements Exception {}

class NoNetworkException implements Exception {}
