import 'dart:io';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/models/create_post_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/models/post_model.dart';

class PostService {
  final ApiRepository _repository = RepositoryModule.getApiRepository();
  final DbService _dbService = DbService();

  Future<List<PostModel>?> getPostsByUserIdFromApi({
    required String userId,
    required int skip,
    required int take,
  }) async {
    try {
      return await _repository.getPostsByUserId(
          userId: userId, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PostModel>> getPostsByUserIdFromDb({
    required String userId,
  }) async {
    return _dbService.getPostModelsByUserId(userId: userId);
  }

  Future<void> updatePostsByUserIdInDb(
      {required String userId,
      required int skip,
      required int take,
      bool isDeleteOld = false}) async {
    var postModels =
        await getPostsByUserIdFromApi(userId: userId, skip: skip, take: take);
    if (postModels != null) {
      await _dbService.createOrUpdatePostsByUser(
          postModels: postModels, isDeleteOld: isDeleteOld);
    }
  }

  Future createPost({required CreatePostModel model}) async {
    await _repository.createPost(createPostModel: model);
  }
}
