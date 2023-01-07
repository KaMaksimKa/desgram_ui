import 'dart:io';

import 'package:desgram_ui/domain/models/notification/notification_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../inrernal/dependencies/repository_module.dart';

class NotificationService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  Future<List<NotificationModel>?> getNotifications(
      {DateTime? skipDate, required int take}) async {
    try {
      return await _repository.getNotifications(skipDate: skipDate, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }
}
