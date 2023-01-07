import 'dart:io';

import 'package:desgram_ui/data/clients/api_client.dart';
import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:desgram_ui/domain/models/notification/notification_model.dart';
import 'package:desgram_ui/domain/models/post/create_post_model.dart';
import 'package:desgram_ui/domain/models/comment/create_comment_model.dart';
import 'package:desgram_ui/domain/models/comment/comment_model.dart';
import 'package:desgram_ui/domain/models/user/change_user_name_model.dart';
import 'package:desgram_ui/domain/models/user/change_password_model.dart';
import 'package:desgram_ui/domain/models/post/change_likes_visibility_model.dart';
import 'package:desgram_ui/domain/models/comment/change_is_comments_enabled_model.dart';
import 'package:desgram_ui/domain/models/user/change_email_model.dart';
import 'package:desgram_ui/domain/models/user/create_user_model.dart';
import 'package:desgram_ui/domain/models/user/email_code_model.dart';
import 'package:desgram_ui/domain/models/guid_id_model.dart';
import 'package:desgram_ui/domain/models/post/hashtag_model.dart';
import 'package:desgram_ui/domain/models/attach/metadata_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/domain/models/user/personal_information_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/domain/models/user/profile_model.dart';
import 'package:desgram_ui/domain/models/push_token_model.dart';
import 'package:desgram_ui/domain/models/refresh_token_request_model.dart';
import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:desgram_ui/domain/models/user/try_create_user_model.dart';
import 'package:desgram_ui/domain/models/post/update_post_model.dart';
import 'package:desgram_ui/domain/models/comment/update_comment_model.dart';
import 'package:desgram_ui/domain/models/user/update_birthday_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/domain/repository/api_repository.dart';

class ApiDataRepository extends ApiRepository {
  final AuthClient _authClient;
  final ApiClient _apiClient;

  ApiDataRepository(this._authClient, this._apiClient);

  @override
  Future<TokenModel?> getToken({
    required String login,
    required String password,
  }) async {
    return _authClient
        .getToken(TokenRequestModel(login: login, password: password));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _apiClient.getCurrentUser();
  }

  @override
  Future updateProfile({String? fullName, String? biography}) async {
    await _apiClient
        .updateProfile(ProfileModel(biography: biography, fullName: fullName));
  }

  @override
  Future<List<PostModel>?> getPostsByUserId({
    required String userId,
    required int skip,
    required int take,
  }) async {
    return await _apiClient.getPostsByUserId(userId, skip, take);
  }

  @override
  Future<TokenModel?> refreshToken({required String refreshToken}) async {
    return await _authClient
        .refreshToken(RefreshTokenRequestModel(refreshToken: refreshToken));
  }

  @override
  Future<PersonalInformationModel?> getPersonalInformation() async {
    return await _apiClient.getPersonalInformation();
  }

  @override
  Future tryCreateUser(TryCreateUserModel tryCreateUserModel) async {
    await _authClient.tryCreateUser(tryCreateUserModel);
  }

  @override
  Future<GuidIdModel> sendSingUpCode(String email) async {
    return await _authClient.sendSingUpCode(email);
  }

  @override
  Future createUser(
      {required TryCreateUserModel tryCreateUserModel,
      required EmailCodeModel emailCodeModel}) async {
    await _authClient.createUser(CreateUserModel(
        tryCreateUserModel: tryCreateUserModel,
        emailCodeModel: emailCodeModel));
  }

  @override
  Future acceptSubscription({required String followerId}) async =>
      await _apiClient.acceptSubscription(followerId);

  @override
  Future<CommentModel?> addComment(
          {required CreateCommentModel createCommentModel}) async =>
      await _apiClient.addComment(createCommentModel);

  @override
  Future<int> addLikeComment({required String commentId}) async =>
      await _apiClient.addLikeComment(commentId);

  @override
  Future<int?> addLikePost({required String postId}) async =>
      (await _apiClient.addLikePost(postId)).amountLikes;

  @override
  Future blockUser({required String blockedUserId}) async =>
      await _apiClient.blockUser(blockedUserId);

  @override
  Future changeAccountAvailability({required bool isPrivate}) async =>
      await _apiClient.changeAccountAvailability(isPrivate);

  @override
  Future changeEmail({required ChangeEmailModel changeEmailModel}) async =>
      await _apiClient.changeEmail(changeEmailModel);

  @override
  Future changeIsCommentsEnabled(
          {required ChangeIsCommentsEnabledModel
              changeIsCommentsEnabledModel}) async =>
      await _apiClient.changeIsCommentsEnabled(changeIsCommentsEnabledModel);

  @override
  Future changeLikesVisibility(
          {required ChangeLikesVisibilityModel
              changeLikesVisibilityModel}) async =>
      await _apiClient.changeLikesVisibility(changeLikesVisibilityModel);

  @override
  Future createPost({required CreatePostModel createPostModel}) async {
    await _apiClient.createPost(createPostModel);
  }

  @override
  Future deleteComment({required String commentId}) async =>
      await _apiClient.deleteComment(commentId);

  @override
  Future deleteFollower({required String followerId}) async =>
      await _apiClient.deleteFollower(followerId);

  @override
  Future<int> deleteLikeComment({required String commentId}) async =>
      await _apiClient.deleteLikeComment(commentId);

  @override
  Future<int?> deleteLikePost({required String postId}) async =>
      (await _apiClient.deleteLikePost(postId)).amountLikes;

  @override
  Future deletePost({required String postId}) async =>
      await _apiClient.deletePost(postId);

  @override
  Future<List<PartialUserModel>?> getBlockedUsers(
          {required int skip, required int take}) async =>
      await _apiClient.getBlockedUsers(skip, take);

  @override
  Future<List<CommentModel>?> getCommentsByPost(
          {required String postId,
          required int skip,
          required int take}) async =>
      await _apiClient.getCommentsByPost(postId, skip, take);
  @override
  Future<List<PostModel>?> getPosts(
      {required int skip, required int take}) async {
    return await _apiClient.getPosts(skip, take);
  }

  @override
  Future<List<PostModel>?> getPostsByHashTag(
          {required String hashtag,
          required int skip,
          required int take}) async =>
      await _apiClient.getPostsByHashTag(hashtag, skip, take);

  @override
  Future<List<PartialUserModel>?> getSubRequests(
          {required int skip, required int take}) async =>
      await _apiClient.getSubRequests(skip, take);

  @override
  Future<List<PostModel>?> getSubscriptionsFeed(
      {required int skip, required int take}) async {
    return await _apiClient.getSubscriptionsFeed(skip, take);
  }

  @override
  Future<UserModel?> getUserById({required String userId}) {
    return _apiClient.getUserById(userId);
  }

  @override
  Future<List<PartialUserModel>?> getUserFollowers(
          {required String userId,
          required int skip,
          required int take}) async =>
      await _apiClient.getUserFollowers(userId, skip, take);

  @override
  Future<List<PartialUserModel>?> getUserFollowing(
          {required String userId,
          required int skip,
          required int take}) async =>
      await _apiClient.getUserFollowing(userId, skip, take);

  @override
  Future logoutAllDevice() async => await _apiClient.logoutAllDevice();

  @override
  Future<List<PartialUserModel>?> searchUsersByName(
      {required String searchUserName,
      required int skip,
      required int take}) async {
    return await _apiClient.searchUsersByName(searchUserName, skip, take);
  }

  @override
  Future<GuidIdModel> sendChangeEmailCode({required String newEmail}) async =>
      await _apiClient.sendChangeEmailCode(newEmail);

  @override
  Future subscribe({required String contentMakerId}) async {
    await _apiClient.subscribe(contentMakerId);
  }

  @override
  Future tryChangeEmail({required String newEmail}) async =>
      await _apiClient.tryChangeEmail(newEmail);

  @override
  Future unblockUser({required String unblockedUserId}) async =>
      await _apiClient.unblockUser(unblockedUserId);

  @override
  Future unsubscribe({required String contentMakerId}) async {
    await _apiClient.unsubscribe(contentMakerId);
  }

  @override
  Future updateComment(
          {required UpdateCommentModel updateCommentModel}) async =>
      await _apiClient.updateComment(updateCommentModel);

  @override
  Future updatePost({required UpdatePostModel updatePostModel}) async =>
      await _apiClient.updatePost(updatePostModel);

  @override
  Future changePassword(
          {required ChangePasswordModel changePasswordModel}) async =>
      await _apiClient.changePassword(changePasswordModel);

  @override
  Future changeUserName(
          {required ChangeUserNameModel changeUserNameModel}) async =>
      await _apiClient.changeUserName(changeUserNameModel);

  @override
  Future updateBirthday({required DateTime? birthday}) async {
    await _apiClient.updateBirthday(UpdateBirthdayModel(birthday: birthday));
  }

  @override
  Future<String?> getCurrentUserId() async {
    return (await _apiClient.getCurrentUserId())?.id;
  }

  @override
  Future<MetadataModel?> uploadFile({required File file}) async {
    return await _apiClient.uploadFile(file);
  }

  @override
  Future<List<MetadataModel>?> uploadFiles({required List<File> files}) async {
    return await _apiClient.uploadFiles(files);
  }

  @override
  Future addAvatar({required MetadataModel metadataModel}) async {
    await _apiClient.addAvatar(metadataModel);
  }

  @override
  Future<List<HashtagModel>?> searchHashtags({
    required String searchString,
    required int skip,
    required int take,
  }) async {
    return await _apiClient.searchHashtags(searchString, skip, take);
  }

  @override
  Future subscribePush({required String token}) async =>
      await _apiClient.subscribePush(PushTokenModel(token: token));

  @override
  Future unsubscribePush() async => await _apiClient.unsubscribePush();

  @override
  Future<List<NotificationModel>?> getNotifications(
      {DateTime? skipDate, required int take}) async {
    return await _apiClient.getNotifications(
        skipDate?.toUtc().toIso8601String(), take);
  }

  @override
  Future<PostModel?> getPostById({required String postId}) async =>
      await _apiClient.getPostById(postId);

  @override
  Future deleteAvatar() async => await _apiClient.deleteAvatar();
}
