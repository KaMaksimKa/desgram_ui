import 'dart:io';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/inrernal/config/token_storage.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/exceptions/exceptions.dart';

class AuthService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final DbService _dbService = DbService();
  final UserService _userService = UserService();

  Future auth(String login, String password) async {
    try {
      var tokenModel =
          await _repository.getToken(login: login, password: password);
      await TokenStorage.setTokenModel(tokenModel);
      var token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _repository.subscribePush(token: token);
      }
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
    String? currentUserId;
    try {
      currentUserId = await _repository.getCurrentUserId();
      if (currentUserId != null) {
        await _userService.updateUserInDb(userId: currentUserId);
      }
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if (await SharedPrefs.getCurrentUserId() == null) {
          return false;
        }
        return true;
      }
      TokenStorage.setTokenModel(null);
      return false;
    }
    await SharedPrefs.setCurrentUserId(currentUserId);
    return currentUserId != null;
  }

  Future cleanUserLocalData() async {
    await TokenStorage.setTokenModel(null);
    await SharedPrefs.setCurrentUserId(null);
    await _dbService.cleanDatabase();
  }

  Future logout() async {
    try {
      await _repository.unsubscribePush();
      cleanUserLocalData();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future logoutFromAllDevice() async {
    try {
      await _repository.unsubscribePush();
      await _repository.logoutAllDevice();
      cleanUserLocalData();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }
}
