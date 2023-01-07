import 'dart:io';

import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../domain/repository/api_repository.dart';
import '../../inrernal/dependencies/repository_module.dart';

class BlockedService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final UserService _userService = UserService();

  Future blockUser({required String userId}) async {
    try {
      await _repository.blockUser(blockedUserId: userId);
      await _userService.updateUserInDb(userId: userId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        await _userService.updateUserInDb(userId: userId);
      } else {
        rethrow;
      }
    }
  }

  Future unblockUser({required String userId}) async {
    try {
      await _repository.unblockUser(unblockedUserId: userId);
      await _userService.updateUserInDb(userId: userId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        await _userService.updateUserInDb(userId: userId);
      } else {
        rethrow;
      }
    }
  }

  Future<List<PartialUserModel>?> getBlokedUsers(
      {required int skip, required int take}) async {
    try {
      return await _repository.getBlockedUsers(skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }
}
