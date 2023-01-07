import 'dart:io';

import 'package:desgram_ui/domain/models/user/email_code_model.dart';
import 'package:desgram_ui/domain/models/guid_id_model.dart';
import 'package:desgram_ui/domain/models/attach/metadata_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';

import '../models/notification/notification_model.dart';
import '../models/user/change_email_model.dart';
import '../models/comment/change_is_comments_enabled_model.dart';
import '../models/post/change_likes_visibility_model.dart';
import '../models/user/change_password_model.dart';
import '../models/user/change_user_name_model.dart';
import '../models/comment/comment_model.dart';
import '../models/comment/create_comment_model.dart';
import '../models/post/create_post_model.dart';
import '../models/post/hashtag_model.dart';
import '../models/user/partial_user_model.dart';
import '../models/user/personal_information_model.dart';
import '../models/post/post_model.dart';
import '../models/token_model.dart';
import '../models/user/try_create_user_model.dart';
import '../models/comment/update_comment_model.dart';
import '../models/post/update_post_model.dart';

abstract class ApiRepository {
  Future logoutAllDevice();

  Future blockUser({required String blockedUserId});

  Future unblockUser({required String unblockedUserId});

  Future<List<PartialUserModel>?> getBlockedUsers({
    required int skip,
    required int take,
  });

  Future<List<PostModel>?> getPosts({
    required int skip,
    required int take,
  });

  Future<List<PostModel>?> getPostsByHashTag({
    required String hashtag,
    required int skip,
    required int take,
  });

  Future<List<HashtagModel>?> searchHashtags(
      {required String searchString, required int skip, required int take});

  Future<List<PostModel>?> getSubscriptionsFeed({
    required int skip,
    required int take,
  });

  Future<List<PostModel>?> getPostsByUserId({
    required String userId,
    required int skip,
    required int take,
  });

  Future<List<MetadataModel>?> uploadFiles({required List<File> files});

  Future<MetadataModel?> uploadFile({required File file});

  Future createPost({required CreatePostModel createPostModel});

  Future deletePost({required String postId});

  Future updatePost({required UpdatePostModel updatePostModel});

  Future changeLikesVisibility(
      {required ChangeLikesVisibilityModel changeLikesVisibilityModel});

  Future changeIsCommentsEnabled(
      {required ChangeIsCommentsEnabledModel changeIsCommentsEnabledModel});

  Future<CommentModel?> addComment(
      {required CreateCommentModel createCommentModel});

  Future deleteComment({required String commentId});

  Future updateComment({required UpdateCommentModel updateCommentModel});

  Future<List<CommentModel>?> getCommentsByPost({
    required String postId,
    required int skip,
    required int take,
  });

  Future<int?> addLikePost({required String postId});

  Future<int?> deleteLikePost({required String postId});

  Future<int> addLikeComment({required String commentId});

  Future<int> deleteLikeComment({required String commentId});

  Future subscribe({required String contentMakerId});

  Future unsubscribe({required String contentMakerId});

  Future deleteFollower({required String followerId});

  Future acceptSubscription({required String followerId});

  Future<List<PartialUserModel>?> getUserFollowing({
    required String userId,
    required int skip,
    required int take,
  });

  Future<List<PartialUserModel>?> getUserFollowers({
    required String userId,
    required int skip,
    required int take,
  });

  Future<List<PartialUserModel>?> getSubRequests({
    required int skip,
    required int take,
  });

  Future<UserModel?> getCurrentUser();
  Future<String?> getCurrentUserId();

  Future<UserModel?> getUserById({required String userId});

  Future<PersonalInformationModel?> getPersonalInformation();

  Future<List<PartialUserModel>?> searchUsersByName({
    required String searchUserName,
    required int skip,
    required int take,
  });

  Future updateProfile({String? fullName, String? biography});

  Future updateBirthday({required DateTime? birthday});

  Future changeUserName({required ChangeUserNameModel changeUserNameModel});

  Future changePassword({required ChangePasswordModel changePasswordModel});

  Future changeAccountAvailability({required bool isPrivate});

  Future tryChangeEmail({required String newEmail});

  Future<GuidIdModel> sendChangeEmailCode({required String newEmail});

  Future changeEmail({required ChangeEmailModel changeEmailModel});

  Future<TokenModel?> getToken(
      {required String login, required String password});

  Future<TokenModel?> refreshToken({required String refreshToken});

  Future tryCreateUser(TryCreateUserModel tryCreateUserModel);

  Future<GuidIdModel> sendSingUpCode(String email);

  Future createUser(
      {required TryCreateUserModel tryCreateUserModel,
      required EmailCodeModel emailCodeModel});

  Future addAvatar({required MetadataModel metadataModel});

  Future subscribePush({required String token});

  Future unsubscribePush();

  Future<List<NotificationModel>?> getNotifications(
      {DateTime? skipDate, required int take});

  Future<PostModel?> getPostById({required String postId});

  Future deleteAvatar();
}
