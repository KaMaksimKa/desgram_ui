import 'dart:io';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/domain/exceptions/bad_request_exception.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/exceptions/forbidden_exception.dart';
import 'package:desgram_ui/domain/exceptions/not_found_exception.dart';
import 'package:desgram_ui/domain/models/comment/change_is_comments_enabled_model.dart';
import 'package:desgram_ui/domain/models/comment/comment_model.dart';
import 'package:desgram_ui/domain/models/comment/create_comment_model.dart';
import 'package:desgram_ui/domain/models/comment/update_comment_model.dart';
import 'package:desgram_ui/domain/models/post/change_likes_visibility_model.dart';
import 'package:desgram_ui/domain/models/post/create_post_model.dart';
import 'package:desgram_ui/domain/models/post/update_post_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:dio/dio.dart';

import '../../domain/models/post/hashtag_model.dart';
import '../../domain/models/post/post_model.dart';

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
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
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

  Future updatePostsByUserIdInDb(
      {required String userId,
      required int skip,
      required int take,
      bool isDeleteOld = false}) async {
    try {
      var postModels =
          await getPostsByUserIdFromApi(userId: userId, skip: skip, take: take);
      if (postModels != null) {
        await _dbService.createUpdateUserPosts(
            postModels: postModels, userId: userId, isDeleteOld: isDeleteOld);
      }
    } on ForbiddenException {
      await _dbService.createUpdateUserPosts(
          postModels: [], userId: userId, isDeleteOld: true);
    }
  }

  Future<List<PostModel>?> getInterestingPostsFromApi({
    required int skip,
    required int take,
  }) async {
    try {
      return await _repository.getPosts(skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PostModel>> getInterestingPostsFromDb() async {
    return _dbService.getInterestingPostModels();
  }

  Future updateInterestingPostsInDb(
      {required int skip, required int take, bool isDeleteOld = false}) async {
    var postModels = await getInterestingPostsFromApi(skip: skip, take: take);
    if (postModels != null) {
      await _dbService.createUpdateInterestingPosts(
          postModels: postModels, isDeleteOld: isDeleteOld);
    }
  }

  Future<List<PostModel>?> getSubscriptionPostsFromApi({
    required int skip,
    required int take,
  }) async {
    try {
      return await _repository.getSubscriptionsFeed(skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PostModel>> getSubscriptionPostsFromDb() async {
    return _dbService.getSubscriptionPostModels();
  }

  Future updateSubscriptionPostsInDb(
      {required int skip, required int take, bool isDeleteOld = false}) async {
    var postModels = await getSubscriptionPostsFromApi(skip: skip, take: take);
    if (postModels != null) {
      await _dbService.createUpdateSubscriptionPosts(
          postModels: postModels, isDeleteOld: isDeleteOld);
    }
  }

  Future<List<PostModel>?> getHashtagPostsFromApi({
    required String hashtag,
    required int skip,
    required int take,
  }) async {
    try {
      return await _repository.getPostsByHashTag(
          hashtag: hashtag, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future<List<PostModel>> getHashtagPostsFromDb(
      {required String hashtag}) async {
    return _dbService.getPostModelsByHashtag(hashtag: hashtag);
  }

  Future updateHashtagPostsInDb(
      {required String hashtag,
      required int skip,
      required int take,
      bool isDeleteOld = false}) async {
    var postModels =
        await getHashtagPostsFromApi(hashtag: hashtag, skip: skip, take: take);
    if (postModels != null) {
      await _dbService.createUpdateHashtagPosts(
          hashtag: hashtag, postModels: postModels, isDeleteOld: isDeleteOld);
    }
  }

  Future updatePostInDbById({required String postId}) async {
    try {
      var postModel = await _repository.getPostById(postId: postId);
      if (postModel != null) {
        await _dbService.createUpdatePosts(postModels: [postModel]);
      } else {
        _dbService.deletePost(postId: postId);
      }
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
      } else {
        rethrow;
      }
    }
  }

  Future createPost({required CreatePostModel model}) async {
    try {
      await _repository.createPost(createPostModel: model);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        throw BadRequestException.fromJson(
            e.response!.data as Map<String, dynamic>);
      } else {
        rethrow;
      }
    }
  }

  Future<List<HashtagModel>?> searchHashtags({
    required String searchString,
    required int skip,
    required int take,
  }) async {
    try {
      return await _repository.searchHashtags(
          searchString: searchString, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else {
        rethrow;
      }
    }
  }

  Future likePost({required String postId}) async {
    try {
      var amountLikes = await _repository.addLikePost(postId: postId);
      await _dbService.updatePost(postId,
          amountLikes: amountLikes, hasLiked: true);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        await updatePostInDbById(postId: postId);
      } else if (e.response?.statusCode == 400) {
        await updatePostInDbById(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future unlikePost({required String postId}) async {
    try {
      var amountLikes = await _repository.deleteLikePost(postId: postId);
      await _dbService.updatePost(postId,
          amountLikes: amountLikes, hasLiked: false);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        await updatePostInDbById(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future<CommentModel?> addComment(
      {required String postId, required String content}) async {
    try {
      var commetModel = await _repository.addComment(
          createCommentModel:
              CreateCommentModel(postId: postId, content: content));

      return commetModel;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        await _dbService.deletePost(postId: postId);
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future<List<CommentModel>?> getPostComments(
      {required String postId, required int skip, required int take}) async {
    try {
      return await _repository.getCommentsByPost(
          postId: postId, skip: skip, take: take);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        await _dbService.deletePost(postId: postId);
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future<int?> likeComment({required String commentId}) async {
    try {
      return await _repository.addLikeComment(commentId: commentId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 400) {
        return null;
      } else if (e.response?.statusCode == 404) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future<int?> unlikeComment({required String commentId}) async {
    try {
      return await _repository.deleteLikeComment(commentId: commentId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 404) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future changeIsCommentsEnabledPost(
      {required String postId, required bool isCommentsEnabled}) async {
    try {
      await _repository.changeIsCommentsEnabled(
          changeIsCommentsEnabledModel: ChangeIsCommentsEnabledModel(
              postId: postId, isCommentsEnabled: isCommentsEnabled));

      await updatePostInDbById(postId: postId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        await updatePostInDbById(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future changeLikesVisibilityPost(
      {required String postId, required bool isLikesVisible}) async {
    try {
      await _repository.changeLikesVisibility(
          changeLikesVisibilityModel: ChangeLikesVisibilityModel(
              postId: postId, isLikesVisible: isLikesVisible));

      await updatePostInDbById(postId: postId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        await _dbService.deletePost(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future deletePost({required String postId}) async {
    try {
      await _repository.deletePost(postId: postId);
      await _dbService.deletePost(postId: postId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        await _dbService.deletePost(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future deleteComment({required String commentId}) async {
    try {
      await _repository.deleteComment(commentId: commentId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException();
      } else {
        rethrow;
      }
    }
  }

  Future editPost({required String postId, required String description}) async {
    try {
      await _repository.updatePost(
          updatePostModel:
              UpdatePostModel(postId: postId, description: description));
      await updatePostInDbById(postId: postId);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
        await _dbService.deletePost(postId: postId);
      } else {
        rethrow;
      }
    }
  }

  Future editComment(
      {required String commentId, required String content}) async {
    try {
      await _repository.updateComment(
          updateCommentModel:
              UpdateCommentModel(commentId: commentId, content: content));
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw NoNetworkException();
      } else if (e.response?.statusCode == 403) {
        throw ForbiddenException();
      } else if (e.response?.statusCode == 404) {
      } else {
        rethrow;
      }
    }
  }
}
