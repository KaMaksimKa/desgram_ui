import 'dart:io';

import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/not_found_exception.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../domain/exceptions/forbidden_exception.dart';

class SubscriptionService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final UserService _userService = UserService();
  Future subscribe({required String userId}) async {
    try {
      await _repository.subscribe(contentMakerId: userId);
      await _userService.updateUserInDb(userId: userId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        await _userService.updateUserInDb(userId: userId);
      } else if (e.response?.statusCode == 403) {
        await _userService.updateUserInDb(userId: userId);
      } else {
        rethrow;
      }
    }
  }

  Future unsubscribe({required String userId}) async {
    try {
      await _repository.unsubscribe(contentMakerId: userId);
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

  Future<List<PartialUserModel>?> getUserFollowers(
      {required String userId, required int skip, required int take}) async {
    try {
      return await _repository.getUserFollowers(
          userId: userId, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PartialUserModel>?> getUserFollowing(
      {required String userId, required int skip, required int take}) async {
    try {
      return await _repository.getUserFollowing(
          userId: userId, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else {
        rethrow;
      }
    }
  }

  Future deleteFollower({required String followerId}) async {
    try {
      await _repository.deleteFollower(followerId: followerId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException();
      } else {
        rethrow;
      }
    }
  }

  Future deleteSubRequest({required String followerId}) async {
    await deleteFollower(followerId: followerId);
  }

  Future acceptSubscription({required String followerId}) async {
    try {
      await _repository.acceptSubscription(followerId: followerId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PartialUserModel>?> getSubRequests(
      {required int skip, required int take}) async {
    try {
      return await _repository.getSubRequests(skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }
}
