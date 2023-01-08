import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../common/something_went_wrong_dialog.dart';

class FeedUserViewModelState {
  final bool isPostsLoading;
  final List<PostModel> posts;
  FeedUserViewModelState({
    this.isPostsLoading = false,
    this.posts = const [],
  });

  FeedUserViewModelState copyWith({
    bool? isPostsLoading,
    List<PostModel>? posts,
  }) {
    return FeedUserViewModelState(
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      posts: posts ?? this.posts,
    );
  }
}

class FeedUserWiewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final PostService _postService = PostService();
  final String userId;
  late final String currentUserId;

  FeedUserViewModelState _state = FeedUserViewModelState();

  FeedUserViewModelState get state => _state;

  set state(FeedUserViewModelState val) {
    _state = val;
    notifyListeners();
  }

  FeedUserWiewModel({
    required super.context,
    required super.mainPageNavigator,
    required this.userId,
  }) {
    scrollController.addListener(_scrollListener);
    SharedPrefs.getCurrentUserId().then((value) {
      currentUserId = value!;
      asyncInit();
    });
    asyncInit();
  }

  Future asyncInit() async {
    state = state.copyWith(
        posts: await _postService.getPostsByUserIdFromDb(userId: userId));
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await loadPosts();
    }
  }

  Future loadPosts() async {
    if (state.isPostsLoading) {
      return;
    }
    state = state.copyWith(isPostsLoading: true);
    try {
      await _postService.updatePostsByUserIdInDb(
          userId: userId, skip: state.posts.length, take: 12);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(
          posts: await _postService.getPostsByUserIdFromDb(userId: userId),
          isPostsLoading: false);
    }
  }
}
