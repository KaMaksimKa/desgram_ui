import 'dart:io';

import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';

import '../../domain/models/post_model.dart';

class PostService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();

  Future<List<PostModel>?> getPostsByUserId({
    required String userId,
    required int skip,
    required int take,
  }) async {
    return await _repository.getPostsByUserId(
        userId: userId, skip: skip, take: take);
  }
}
