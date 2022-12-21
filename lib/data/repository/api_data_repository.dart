import 'dart:io';

import 'package:desgram_ui/data/clients/api_client.dart';
import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:desgram_ui/domain/models/create_post_model.dart';
import 'package:desgram_ui/domain/models/create_comment_model.dart';
import 'package:desgram_ui/domain/models/comment_model.dart';
import 'package:desgram_ui/domain/models/change_user_name_model.dart';
import 'package:desgram_ui/domain/models/change_password_model.dart';
import 'package:desgram_ui/domain/models/change_likes_visibility_model.dart';
import 'package:desgram_ui/domain/models/change_is_comments_enabled_model.dart';
import 'package:desgram_ui/domain/models/change_email_model.dart';
import 'package:desgram_ui/domain/models/create_user_model.dart';
import 'package:desgram_ui/domain/models/email_code_model.dart';
import 'package:desgram_ui/domain/models/guid_id_model.dart';
import 'package:desgram_ui/domain/models/metadata_model.dart';
import 'package:desgram_ui/domain/models/partial_user_model.dart';
import 'package:desgram_ui/domain/models/personal_information_model.dart';
import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/domain/models/profile_model.dart';
import 'package:desgram_ui/domain/models/refresh_token_request_model.dart';
import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:desgram_ui/domain/models/token_request_model.dart';
import 'package:desgram_ui/domain/models/try_create_user_model.dart';
import 'package:desgram_ui/domain/models/update_post_model.dart';
import 'package:desgram_ui/domain/models/update_comment_model.dart';
import 'package:desgram_ui/domain/models/update_birthday_model.dart';
import 'package:desgram_ui/domain/models/user_model.dart';
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
  Future acceptSubscription({required String followerId}) {
    // TODO: implement acceptSubscription
    throw UnimplementedError();
  }

  @override
  Future<CommentModel?> addComment(
      {required CreateCommentModel createCommentModel}) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<int> addLikeComment({required String commentId}) {
    // TODO: implement addLikeComment
    throw UnimplementedError();
  }

  @override
  Future<int> addLikePost({required String postId}) {
    // TODO: implement addLikePost
    throw UnimplementedError();
  }

  @override
  Future blockUser({required String blockedUserId}) {
    // TODO: implement blockUser
    throw UnimplementedError();
  }

  @override
  Future changeAccountAvailability({required bool isPrivate}) {
    // TODO: implement changeAccountAvailability
    throw UnimplementedError();
  }

  @override
  Future changeEmail({required ChangeEmailModel body}) {
    // TODO: implement changeEmail
    throw UnimplementedError();
  }

  @override
  Future changeIsCommentsEnabled(
      {required ChangeIsCommentsEnabledModel changeIsCommentsEnabledModel}) {
    // TODO: implement changeIsCommentsEnabled
    throw UnimplementedError();
  }

  @override
  Future changeLikesVisibility(
      {required ChangeLikesVisibilityModel changeLikesVisibilityModel}) {
    // TODO: implement changeLikesVisibility
    throw UnimplementedError();
  }

  @override
  Future createPost({required CreatePostModel createPostModel}) async {
    await _apiClient.createPost(createPostModel);
  }

  @override
  Future deleteComment({required String commentId}) {
    // TODO: implement deleteComment
    throw UnimplementedError();
  }

  @override
  Future deleteFollower({required String followerId}) {
    // TODO: implement deleteFollower
    throw UnimplementedError();
  }

  @override
  Future<int> deleteLikeComment({required String commentId}) {
    // TODO: implement deleteLikeComment
    throw UnimplementedError();
  }

  @override
  Future<int> deleteLikePost({required String postId}) {
    // TODO: implement deleteLikePost
    throw UnimplementedError();
  }

  @override
  Future deletePost({required String postId}) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<PartialUserModel>?> getBlockedUsers(
      {required int skip, required int take}) {
    // TODO: implement getBlockedUsers
    throw UnimplementedError();
  }

  @override
  Future<List<CommentModel>?> getCommentsByPost(
      {required String postId, required int skip, required int take}) {
    // TODO: implement getCommentsByPost
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>?> getPosts({required int skip, required int take}) {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>?> getPostsByHashTag(
      {required String hashtag, required int skip, required int take}) {
    // TODO: implement getPostsByHashTag
    throw UnimplementedError();
  }

  @override
  Future<List<PartialUserModel>?> getSubRequests(
      {required int skip, required int take}) {
    // TODO: implement getSubRequests
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>?> getSubscriptionsFeed(
      {required int skip, required int take}) {
    // TODO: implement getSubscriptionsFeed
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getUserById({required String userId}) {
    return _apiClient.getUserById(userId);
  }

  @override
  Future<List<PartialUserModel>?> getUserFollowers(
      {required String userId, required int skip, required int take}) {
    // TODO: implement getUserFollowers
    throw UnimplementedError();
  }

  @override
  Future<List<PartialUserModel>?> getUserFollowing(
      {required String userId, required int skip, required int take}) {
    // TODO: implement getUserFollowing
    throw UnimplementedError();
  }

  @override
  Future logoutAllDevice() {
    // TODO: implement logoutAllDevice
    throw UnimplementedError();
  }

  @override
  Future<List<PartialUserModel>?> searchUsersByName(
      {required String searchUserName, required int skip, required int take}) {
    // TODO: implement searchUsersByName
    throw UnimplementedError();
  }

  @override
  Future<GuidIdModel> sendChangeEmailCode({required String newEmail}) {
    // TODO: implement sendChangeEmailCode
    throw UnimplementedError();
  }

  @override
  Future subscribe({required String contentMakerId}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future tryChangeEmail({required String newEmail}) {
    // TODO: implement tryChangeEmail
    throw UnimplementedError();
  }

  @override
  Future unblockUser({required String unblockedUserId}) {
    // TODO: implement unblockUser
    throw UnimplementedError();
  }

  @override
  Future unsubscribe({required String contentMakerId}) {
    // TODO: implement unsubscribe
    throw UnimplementedError();
  }

  @override
  Future updateComment({required UpdateCommentModel updateCommentModel}) {
    // TODO: implement updateComment
    throw UnimplementedError();
  }

  @override
  Future updatePost({required UpdatePostModel updatePostModel}) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }

  @override
  Future changePassword({required ChangePasswordModel changePasswordModel}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future changeUserName({required ChangeUserNameModel changeUserNameModel}) {
    // TODO: implement changeUserName
    throw UnimplementedError();
  }

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
}
