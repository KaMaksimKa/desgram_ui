import 'dart:io';

import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/exceptions/exceptions.dart';
import '../../domain/models/attach/metadata_model.dart';

class AttachService {
  final _repository = RepositoryModule.getApiRepository();

  Future<MetadataModel?> uploadFile({required File file}) async {
    try {
      return await _repository.uploadFile(file: file);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<MetadataModel>?> uploadFiles({required List<File> files}) async {
    try {
      return await _repository.uploadFiles(files: files);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }
}
