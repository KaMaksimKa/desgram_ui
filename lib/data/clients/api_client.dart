import 'dart:io';

import 'package:desgram_ui/domain/models/like/amount_likes_model.dart';
import 'package:desgram_ui/domain/models/comment/change_is_comments_enabled_model.dart';
import 'package:desgram_ui/domain/models/notification/notification_model.dart';
import 'package:desgram_ui/domain/models/post/hashtag_model.dart';
import 'package:desgram_ui/domain/models/attach/metadata_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/domain/models/user/personal_information_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/domain/models/user/profile_model.dart';
import 'package:desgram_ui/domain/models/push_token_model.dart';
import 'package:desgram_ui/domain/models/comment/update_comment_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/models/user/change_email_model.dart';
import '../../domain/models/post/change_likes_visibility_model.dart';
import '../../domain/models/user/change_password_model.dart';
import '../../domain/models/user/change_user_name_model.dart';
import '../../domain/models/comment/comment_model.dart';
import '../../domain/models/comment/create_comment_model.dart';
import '../../domain/models/post/create_post_model.dart';
import '../../domain/models/guid_id_model.dart';
import '../../domain/models/user/update_birthday_model.dart';
import '../../domain/models/post/update_post_model.dart';
import '../../domain/models/user/user_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST("/api/Attach/UploadFiles")
  Future<List<MetadataModel>?> uploadFiles(
      @Part(name: "files") List<File> files);

  @POST("/api/Attach/UploadFile")
  Future<MetadataModel?> uploadFile(@Part(name: "file") File file);

  @POST("/api/Auth/LogoutAllDevice")
  Future logoutAllDevice();

  @POST("/api/Blocking/BlockUser")
  Future blockUser(@Query("blockedUserId") String blockedUserId);

  @POST("/api/Blocking/UnblockUser")
  Future unblockUser(@Query("unblockedUserId") String unblockedUserId);

  @GET("/api/Blocking/GetBlockedUsers")
  Future<List<PartialUserModel>?> getBlockedUsers(
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Post/GetPosts")
  Future<List<PostModel>?> getPosts(
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Post/GetPostsByHashTag")
  Future<List<PostModel>?> getPostsByHashTag(
    @Query("Hashtag") String hashtag,
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Post/GetPostById")
  Future<PostModel?> getPostById(
    @Query("postId") String postId,
  );

  @GET("/api/Post/SearchHashtags")
  Future<List<HashtagModel>?> searchHashtags(
      @Query("SearchString") String searchString,
      @Query("Skip") int skip,
      @Query("Take") int take);

  @GET("/api/Post/GetSubscriptionsFeed")
  Future<List<PostModel>?> getSubscriptionsFeed(
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Post/GetPostsByUserId")
  Future<List<PostModel>?> getPostsByUserId(
    @Query("UserId") String userId,
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @POST("/api/Post/CreatePost")
  Future createPost(@Body() CreatePostModel body);

  @POST("/api/Post/DeletePost/{postId}")
  Future deletePost(@Path("postId") String postId);

  @POST("/api/Post/UpdatePost")
  Future updatePost(@Body() UpdatePostModel body);

  @POST("/api/Post/ChangeLikesVisibility")
  Future changeLikesVisibility(@Body() ChangeLikesVisibilityModel body);

  @POST("/api/Post/ChangeIsCommentsEnabled")
  Future changeIsCommentsEnabled(@Body() ChangeIsCommentsEnabledModel body);

  @POST("/api/Post/AddComment")
  Future<CommentModel?> addComment(@Body() CreateCommentModel body);

  @POST("/api/Post/DeleteComment/{commentId}")
  Future deleteComment(@Path("commentId") String commentId);

  @POST("/api/Post/UpdateComment")
  Future updateComment(@Body() UpdateCommentModel body);

  @GET("/api/Post/GetCommentsByPost")
  Future<List<CommentModel>?> getCommentsByPost(
    @Query("PostId") String postId,
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @POST("/api/Post/AddLikePost/{postId}")
  Future<AmountLikesModel> addLikePost(@Path("postId") String postId);

  @POST("/api/Post/DeleteLikePost/{postId}")
  Future<AmountLikesModel> deleteLikePost(@Path("postId") String postId);

  @POST("/api/Post/AddLikeComment/{commentId}")
  Future<int> addLikeComment(@Path("commentId") String commentId);

  @POST("/api/Post/DeleteLikeComment/{commentId}")
  Future<int> deleteLikeComment(@Path("commentId") String commentId);

  @POST("/api/Subscription/Subscribe/{contentMakerId}")
  Future subscribe(@Path("contentMakerId") String contentMakerId);

  @POST("/api/Subscription/Unsubscribe/{contentMakerId}")
  Future unsubscribe(@Path("contentMakerId") String contentMakerId);

  @POST("/api/Subscription/DeleteFollower/{followerId}")
  Future deleteFollower(@Path("followerId") String followerId);

  @POST("/api/Subscription/AcceptSubscription/{followerId}")
  Future acceptSubscription(@Path("followerId") String followerId);

  @GET("/api/Subscription/GetUserFollowing")
  Future<List<PartialUserModel>?> getUserFollowing(
    @Query("UserId") String userId,
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Subscription/GetUserFollowers")
  Future<List<PartialUserModel>?> getUserFollowers(
    @Query("UserId") String userId,
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/Subscription/GetSubRequests")
  Future<List<PartialUserModel>?> getSubRequests(
    @Query("Skip") int skip,
    @Query("Take") int take,
  );

  @GET("/api/User/GetCurrentUser")
  Future<UserModel?> getCurrentUser();

  @GET("/api/User/GetCurrentUserId")
  Future<GuidIdModel?> getCurrentUserId();

  @GET("/api/User/GetUserById")
  Future<UserModel?> getUserById(@Query("userId") String userId);

  @GET("/api/User/GetPersonalInformation")
  Future<PersonalInformationModel?> getPersonalInformation();

  @GET("/api/User/SearchUsersByName")
  Future<List<PartialUserModel>?> searchUsersByName(
      @Query("SearchUserName") String searchUserName,
      @Query("Skip") int skip,
      @Query("Take") int take);

  @POST("/api/User/AddAvatar")
  Future addAvatar(@Body() MetadataModel body);

  @POST("/api/User/DeleteAvatar")
  Future deleteAvatar();

  @POST("/api/User/UpdateProfile")
  Future updateProfile(@Body() ProfileModel body);

  @POST("/api/User/UpdateBirthday")
  Future updateBirthday(@Body() UpdateBirthdayModel body);

  @POST("/api/User/ChangeUserName")
  Future changeUserName(@Body() ChangeUserNameModel body);

  @POST("/api/User/ChangePassword")
  Future changePassword(@Body() ChangePasswordModel body);

  @POST("/api/User/ChangeAccountAvailability")
  Future changeAccountAvailability(@Query("isPrivate") bool isPrivate);

  @POST("/api/User/TryChangeEmail")
  Future tryChangeEmail(@Query("newEmail") String newEmail);

  @POST("/api/User/SendChangeEmailCode")
  Future<GuidIdModel> sendChangeEmailCode(@Query("newEmail") String newEmail);

  @POST("/api/User/ChangeEmail")
  Future changeEmail(@Body() ChangeEmailModel body);

  @POST("/api/Push/SubscribePush")
  Future subscribePush(@Body() PushTokenModel body);

  @POST("/api/Push/UnsubscribePush")
  Future unsubscribePush();

  @GET("/api/Notification/GetNotifications")
  Future<List<NotificationModel>?> getNotifications(
      @Query("SkipDate") String? skipDate, @Query("Take") int take);
}
