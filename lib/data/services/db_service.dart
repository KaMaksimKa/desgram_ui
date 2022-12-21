import 'package:desgram_ui/data/services/database.dart';
import 'package:desgram_ui/domain/entities/db_entity.dart';
import 'package:desgram_ui/domain/entities/partial_user.dart';
import 'package:desgram_ui/domain/entities/partial_user_avatar.dart';
import 'package:desgram_ui/domain/entities/post_content.dart';
import 'package:desgram_ui/domain/entities/post_content_candidate.dart';
import 'package:desgram_ui/domain/entities/user_avatar.dart';
import 'package:desgram_ui/domain/entities/user_avatar_candidate.dart';
import 'package:desgram_ui/domain/models/image_content_model.dart';
import 'package:desgram_ui/domain/models/image_with_url_model.dart';
import 'package:desgram_ui/domain/models/partial_user_model.dart';
import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';

class DbService {
  Future<List<PostModel>> getPostModelsByUserId(
      {required String userId}) async {
    var posts = await DB.instanse.getRange<Post>(whereMap: {"userId": userId});
    var postModels = <PostModel>[];
    for (var post in posts) {
      postModels.add(await _postToPostModel(post: post));
    }
    return postModels;
  }

  Future createOrUpdatePostsByUser(
      {required Iterable<PostModel> postModels,
      bool isDeleteOld = false}) async {
    if (isDeleteOld && postModels.isNotEmpty) {
      var oldPosts = await DB.instanse
          .getRange<Post>(whereMap: {"userId": postModels.first.user.id});
      for (var oldPost in oldPosts) {
        await DB.instanse.delete(oldPost);
      }
    }

    var posts = postModels.map((p) => Post(
        id: p.id,
        userId: p.user.id,
        description: p.description,
        isCommentsEnabled: p.isCommentsEnabled ? 1 : 0,
        hasLiked: p.hasLiked ? 1 : 0,
        createdDate: p.createdDate,
        amountComments: p.amountComments,
        amountLikes: p.amountLikes));
    var partialUsers = postModels
        .map((e) => PartialUser(id: e.user.id, name: e.user.name))
        .distinct();

    var partialUsersAvatar = postModels
        .where((element) => element.user.avatar != null)
        .map((e) => PartialUserAvatar(
            id: e.user.avatar!.id,
            width: e.user.avatar!.width,
            height: e.user.avatar!.height,
            url: e.user.avatar!.url,
            mimeType: e.user.avatar!.mimeType,
            partialUserId: e.user.id))
        .distinct();

    var postContents = <PostContent>[];
    var postContentCandidates = <PostContentCandidate>[];
    for (var postModel in postModels) {
      for (var imageContentModel in postModel.imageContents) {
        var postContent =
            PostContent(id: const Uuid().v4(), postId: postModel.id);
        postContents.add(postContent);
        postContentCandidates.addAll(imageContentModel.imageCandidates.map(
            (e) => PostContentCandidate(
                id: e.id,
                width: e.width,
                height: e.height,
                url: e.url,
                mimeType: e.mimeType,
                postContentId: postContent.id)));
      }
    }

    await DB.instanse.createUpdateRange(partialUsers);
    await DB.instanse.createUpdateRange(partialUsersAvatar);
    await DB.instanse.createUpdateRange(posts);
    await DB.instanse.createUpdateRange(postContents);
    await DB.instanse.createUpdateRange(postContentCandidates);
  }

  Future<PostModel> _postToPostModel({required Post post}) async {
    var partialUser = (await DB.instanse
        .getFirstOrDefault<PartialUser>(whereMap: {"id": post.userId}))!;
    var partialUserAvatars = await DB.instanse
        .getRange<PartialUserAvatar>(whereMap: {"partialUserId": post.userId});

    var partialUserAvatar =
        partialUserAvatars.isEmpty ? null : partialUserAvatars.first;

    var postContents =
        (await DB.instanse.getRange<PostContent>(whereMap: {"postId": post.id}))
            .toList();
    var postContentCandidates = (await DB.instanse
            .getRange<PostContentCandidate>(
                whereMap: {"postContentId": postContents.map((e) => e.id)}))
        .toList();

    return PostModel(
        id: post.id,
        user: PartialUserModel(
            id: partialUser.id,
            name: partialUser.name,
            avatar: partialUserAvatar == null
                ? null
                : ImageWithUrlModel(
                    id: partialUserAvatar.id,
                    url: partialUserAvatar.url,
                    mimeType: partialUserAvatar.mimeType,
                    width: partialUserAvatar.width,
                    height: partialUserAvatar.height)),
        description: post.description,
        amountLikes: post.amountLikes,
        amountComments: post.amountComments,
        isCommentsEnabled: post.isCommentsEnabled == 1,
        createdDate: post.createdDate,
        imageContents: postContents
            .map((e) => ImageContentModel(
                imageCandidates: postContentCandidates
                    .where((element) => element.postContentId == e.id)
                    .map((e) => ImageWithUrlModel(
                        id: e.id,
                        url: e.url,
                        mimeType: e.mimeType,
                        width: e.width,
                        height: e.height))
                    .toList()))
            .toList(),
        hasLiked: post.hasLiked == 1);
  }

  Future createUpdateUser({required UserModel userModel}) async {
    var oldUser = await DB.instanse
        .getFirstOrDefault<User>(whereMap: {"id": userModel.id});
    if (oldUser != null) {
      await DB.instanse.delete(oldUser);
    }

    var user = User(
        id: userModel.id,
        name: userModel.name,
        fullName: userModel.fullName,
        biography: userModel.biography,
        amountFollowing: userModel.amountFollowing,
        amountFollowers: userModel.amountFollowers,
        amountPosts: userModel.amountPosts,
        isPrivate: userModel.isPrivate ? 1 : 0,
        followedByViewer: userModel.followedByViewer ? 1 : 0,
        hasRequestedViewer: userModel.hasRequestedViewer ? 1 : 0,
        followsViewer: userModel.followsViewer ? 1 : 0,
        hasBlockedViewer: userModel.hasBlockedViewer ? 1 : 0);

    await DB.instanse.createUpdate(user);

    if (userModel.avatar != null) {
      var userAvatar = UserAvatar(id: const Uuid().v4(), userId: userModel.id);
      var userAvatarCandidates = userModel.avatar!.imageCandidates.map((e) =>
          UserAvatarCandidate(
              id: e.id,
              width: e.width,
              height: e.height,
              url: e.url,
              mimeType: e.mimeType,
              userAvatarId: userAvatar.id));

      await DB.instanse.createUpdate(userAvatar);
      await DB.instanse.createUpdateRange(userAvatarCandidates);
    }
  }

  Future<UserModel?> getUserModelById({required String userId}) async {
    var user =
        await DB.instanse.getFirstOrDefault<User>(whereMap: {"id": userId});
    var userAvatar = await DB.instanse
        .getFirstOrDefault<UserAvatar>(whereMap: {"userId": userId});
    var userAvatarCandidates = userAvatar == null
        ? null
        : await DB.instanse.getRange<UserAvatarCandidate>(
            whereMap: {"userAvatarId": userAvatar.id});

    return user == null
        ? null
        : UserModel(
            id: user.id,
            name: user.name,
            fullName: user.fullName,
            biography: user.biography,
            amountFollowing: user.amountFollowing,
            amountFollowers: user.amountFollowers,
            amountPosts: user.amountPosts,
            isPrivate: user.isPrivate == 1,
            followedByViewer: user.followedByViewer == 1,
            hasRequestedViewer: user.hasRequestedViewer == 1,
            followsViewer: user.followsViewer == 1,
            hasBlockedViewer: user.hasBlockedViewer == 1,
            avatar: userAvatar == null
                ? null
                : ImageContentModel(
                    imageCandidates: userAvatarCandidates!
                        .map((e) => ImageWithUrlModel(
                            id: e.id,
                            url: e.url,
                            mimeType: e.mimeType,
                            width: e.width,
                            height: e.height))
                        .toList()));
  }
}
