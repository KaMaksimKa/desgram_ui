import 'dart:io';

import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/config/token_storage.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiRepository repository = RepositoryModule.getApiRepository();

  Future auth(String login, String password) async {
    try {
      var tokenModel =
          await repository.getToken(login: login, password: password);
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

  Future checkAuth() async {
    return await TokenStorage.getAccessToken() != null;
  }

  Future logout() async {
    await TokenStorage.setTokenModel(null);
    //TODO послать запрос на logout на через api_client
  }
}

class WrongLoginException implements Exception {}

class WrongCredentionalException implements Exception {}

class NoNetworkException implements Exception {}
