import 'package:desgram_ui/data/services/database.dart';
import 'package:desgram_ui/domain/entities/db_entity.dart';
import 'package:desgram_ui/domain/entities/hashtag_post.dart';
import 'package:desgram_ui/domain/entities/interesting_post.dart';
import 'package:desgram_ui/domain/entities/partial_user.dart';
import 'package:desgram_ui/domain/entities/partial_user_avatar.dart';
import 'package:desgram_ui/domain/entities/post_content.dart';
import 'package:desgram_ui/domain/entities/post_content_candidate.dart';
import 'package:desgram_ui/domain/entities/search_string.dart';
import 'package:desgram_ui/domain/entities/subscription_post.dart';
import 'package:desgram_ui/domain/entities/user_avatar.dart';
import 'package:desgram_ui/domain/entities/user_avatar_candidate.dart';
import 'package:desgram_ui/domain/entities/user_post.dart';
import 'package:desgram_ui/domain/models/attach/image_content_model.dart';
import 'package:desgram_ui/domain/models/attach/image_with_url_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';

class DbService {
  static final List<
          Function({required String postId, required PostModel? value})>
      postsListeners = [];
  static void _invokePostsListeners(
      {required String postId, required PostModel? value}) {
    for (var listener in postsListeners) {
      listener(postId: postId, value: value);
    }
  }

  Future<List<PostModel>> getPostModelsByHashtag(
      {required String hashtag}) async {
    var hashtagPosts =
        await DB.instanse.getRange<HashtagPost>(whereMap: {"hashtag": hashtag});

    var postModels = <PostModel>[];
    for (var hashtagPost in hashtagPosts) {
      var post = await DB.instanse
          .getFirstOrDefault<Post>(whereMap: {"id": hashtagPost.postId});
      if (post != null) {
        postModels.add(await _postToPostModel(post: post));
      }
    }
    return postModels;
  }

  Future createUpdateHashtagPosts(
      {required Iterable<PostModel> postModels,
      required String hashtag,
      bool isDeleteOld = false}) async {
    if (isDeleteOld) {
      var oldHashtagPosts = await DB.instanse
          .getRange<HashtagPost>(whereMap: {"hashtag": hashtag});
      for (var oldHashtagPost in oldHashtagPosts) {
        DB.instanse.delete(oldHashtagPost);
      }
    }
    var hashtagPosts = postModels.map((e) =>
        HashtagPost(id: const Uuid().v4(), hashtag: hashtag, postId: e.id));

    await createUpdatePosts(postModels: postModels);
    await DB.instanse.createUpdateRange(hashtagPosts);
  }

  Future<List<PostModel>> getInterestingPostModels() async {
    var interestingPosts = await DB.instanse.getRange<InterestingPost>();
    var postModels = <PostModel>[];
    for (var userPost in interestingPosts) {
      var post = await DB.instanse
          .getFirstOrDefault<Post>(whereMap: {"id": userPost.postId});
      if (post != null) {
        postModels.add(await _postToPostModel(post: post));
      }
    }
    return postModels;
  }

  Future createUpdateInterestingPosts(
      {required Iterable<PostModel> postModels,
      bool isDeleteOld = false}) async {
    if (isDeleteOld) {
      DB.instanse.cleanTable<InterestingPost>();
    }
    var interestingPosts = postModels
        .map((e) => InterestingPost(id: const Uuid().v4(), postId: e.id));

    await createUpdatePosts(postModels: postModels);
    await DB.instanse.createUpdateRange(interestingPosts);
  }

  Future createUpdateSubscriptionPosts(
      {required Iterable<PostModel> postModels,
      bool isDeleteOld = false}) async {
    if (isDeleteOld) {
      DB.instanse.cleanTable<SubscriptionPost>();
    }
    var subscriptionPosts = postModels
        .map((e) => SubscriptionPost(id: const Uuid().v4(), postId: e.id));

    await createUpdatePosts(postModels: postModels);
    await DB.instanse.createUpdateRange(subscriptionPosts);
  }

  Future<List<PostModel>> getSubscriptionPostModels() async {
    var subscriptionPosts = await DB.instanse.getRange<SubscriptionPost>();

    var postModels = <PostModel>[];
    for (var userPost in subscriptionPosts) {
      var post = await DB.instanse
          .getFirstOrDefault<Post>(whereMap: {"id": userPost.postId});
      if (post != null) {
        postModels.add(await _postToPostModel(post: post));
      }
    }
    return postModels;
  }

  Future<List<PostModel>> getPostModelsByUserId(
      {required String userId}) async {
    var userPosts =
        await DB.instanse.getRange<UserPost>(whereMap: {"userId": userId});

    var postModels = <PostModel>[];
    for (var userPost in userPosts) {
      var post = await DB.instanse
          .getFirstOrDefault<Post>(whereMap: {"id": userPost.postId});
      if (post != null) {
        postModels.add(await _postToPostModel(post: post));
      }
    }
    return postModels;
  }

  Future createUpdateUserPosts(
      {required Iterable<PostModel> postModels,
      required String userId,
      bool isDeleteOld = false}) async {
    if (isDeleteOld) {
      var oldUserPosts =
          await DB.instanse.getRange<UserPost>(whereMap: {"userId": userId});
      for (var oldUserPost in oldUserPosts) {
        DB.instanse.delete(oldUserPost);
      }
    }
    var userPosts = postModels.map(
        (e) => UserPost(id: const Uuid().v4(), userId: userId, postId: e.id));

    await createUpdatePosts(postModels: postModels);
    await DB.instanse.createUpdateRange(userPosts);
  }

  Future createUpdatePosts({required Iterable<PostModel> postModels}) async {
    for (var postModel in postModels) {
      _invokePostsListeners(postId: postModel.id, value: postModel);
    }
    var posts = postModels.map((p) => Post(
        id: p.id,
        userId: p.user.id,
        description: p.description,
        isCommentsEnabled: p.isCommentsEnabled ? 1 : 0,
        isLikesVisible: p.isLikesVisible ? 1 : 0,
        hasLiked: p.hasLiked ? 1 : 0,
        hasEdit: p.hasEdit ? 1 : 0,
        createdDate: p.createdDate,
        amountComments: p.amountComments,
        amountLikes: p.amountLikes));
    var partialUsers = postModels
        .map((e) => PartialUser(id: e.user.id, name: e.user.name))
        .distinctById();

    var partialUsersAvatar = postModels
        .where((element) => element.user.avatar != null)
        .map((e) => PartialUserAvatar(
            id: e.user.avatar!.id,
            width: e.user.avatar!.width,
            height: e.user.avatar!.height,
            url: e.user.avatar!.url,
            mimeType: e.user.avatar!.mimeType,
            partialUserId: e.user.id))
        .distinctById();

    for (var partialUser in partialUsers) {
      var oldAvatar = await DB.instanse.getFirstOrDefault<PartialUserAvatar>(
          whereMap: {"partialUserId": partialUser.id});
      if (oldAvatar == null) {
        continue;
      }
      var newAvatar = partialUsersAvatar
          .where((element) => element.partialUserId == partialUser.id);
      if (newAvatar.isEmpty || newAvatar.first.id != oldAvatar.id) {
        DB.instanse.delete(oldAvatar);
      }
    }

    var postContents = <PostContent>[];
    var postContentCandidates = <PostContentCandidate>[];
    for (var postModel in postModels) {
      for (var imageContentModel in postModel.imageContents) {
        var oldPostContentCandidates = await DB.instanse
            .getRange<PostContentCandidate>(whereMap: {
          "id": imageContentModel.imageCandidates.map((e) => e.id)
        });

        late PostContent postContent;

        if (oldPostContentCandidates.isEmpty) {
          postContent =
              PostContent(id: const Uuid().v4(), postId: postModel.id);
        } else {
          postContent = PostContent(
              id: oldPostContentCandidates.first.postContentId,
              postId: postModel.id);
        }

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

  Future deletePost({required String postId}) async {
    var post =
        await DB.instanse.getFirstOrDefault<Post>(whereMap: {"id": postId});
    if (post != null) {
      await DB.instanse.delete(post);
    }
    _invokePostsListeners(postId: postId, value: null);
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
        isLikesVisible: post.isLikesVisible == 1,
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
        hasLiked: post.hasLiked == 1,
        hasEdit: post.hasEdit == 1);
  }

  Future createUpdateUser({required UserModel userModel}) async {
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
        hasBlockedViewer: userModel.hasBlockedViewer ? 1 : 0,
        blockedByViewer: userModel.blockedByViewer ? 1 : 0);

    await DB.instanse.createUpdate(user);

    if (userModel.avatar != null) {
      var oldUserAvatarCandidates = await DB.instanse
          .getRange<UserAvatarCandidate>(whereMap: {
        "id": userModel.avatar!.imageCandidates.map((e) => e.id)
      });
      late UserAvatar userAvatar;

      if (oldUserAvatarCandidates.isEmpty) {
        userAvatar = UserAvatar(id: const Uuid().v4(), userId: userModel.id);
      } else {
        userAvatar = UserAvatar(
            id: oldUserAvatarCandidates.first.userAvatarId,
            userId: userModel.id);
      }

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
            blockedByViewer: user.blockedByViewer == 1,
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

  Future<List<String>> getSearchString(
      {required int count, String searchString = ""}) async {
    var searchStrings = await DB.instanse.getRange<SearchString>();
    return searchStrings
        .where((element) => element.searchString.contains(searchString))
        .toList()
        .reversed
        .take(count)
        .map((e) => e.searchString)
        .toList();
  }

  Future addSearchString({required String searchString}) async {
    await DB.instanse.createUpdate(
        SearchString(id: const Uuid().v4(), searchString: searchString));
  }

  Future cleanDatabase() async {
    await DB.instanse.cleanAllTable();
  }

  Future updatePost(String postId,
      {int? amountLikes, bool? hasLiked, int? amountComments}) async {
    var oldPost =
        await DB.instanse.getFirstOrDefault<Post>(whereMap: {"id": postId});
    if (oldPost != null) {
      var intHasLiked = hasLiked == true
          ? 1
          : hasLiked == false
              ? 0
              : null;
      var newPost = Post(
          id: oldPost.id,
          userId: oldPost.userId,
          description: oldPost.description,
          amountLikes: amountLikes ?? oldPost.amountLikes,
          amountComments: amountComments ?? oldPost.amountComments,
          isCommentsEnabled: oldPost.isCommentsEnabled,
          isLikesVisible: oldPost.isLikesVisible,
          hasLiked: intHasLiked ?? oldPost.hasLiked,
          hasEdit: oldPost.hasEdit,
          createdDate: oldPost.createdDate);

      await DB.instanse.update(newPost);
      var postModel = await _postToPostModel(post: newPost);
      _invokePostsListeners(postId: postModel.id, value: postModel);
    }
  }
}
