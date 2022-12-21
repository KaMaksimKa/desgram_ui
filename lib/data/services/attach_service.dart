import 'dart:io';

import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';

import '../../domain/models/metadata_model.dart';

class AttachService {
  final _repository = RepositoryModule.getApiRepository();
  @override
  Future<MetadataModel?> uploadFile({required File file}) async {
    return await _repository.uploadFile(file: file);
  }

  @override
  Future<List<MetadataModel>?> uploadFiles({required List<File> files}) async {
    return await _repository.uploadFiles(files: files);
  }
}
