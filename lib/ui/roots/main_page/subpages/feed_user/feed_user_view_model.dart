import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/domain/models/post_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

class FeedUserWiewModelState {
  final bool isPostsLoading;
  final List<PostModel> posts;
  FeedUserWiewModelState({
    this.isPostsLoading = false,
    this.posts = const [],
  });

  FeedUserWiewModelState copyWith({
    bool? isPostLoading,
    List<PostModel>? posts,
  }) {
    return FeedUserWiewModelState(
      isPostsLoading: isPostLoading ?? this.isPostsLoading,
      posts: posts ?? this.posts,
    );
  }
}

class FeedUserWiewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final PostService _postService = PostService();
  final String userId;

  FeedUserWiewModelState _state = FeedUserWiewModelState();

  FeedUserWiewModelState get state => _state;

  set state(FeedUserWiewModelState val) {
    _state = val;
    notifyListeners();
  }

  FeedUserWiewModel({
    required super.context,
    required super.mainPageNavigator,
    required this.userId,
  }) {
    scrollController.addListener(_scrollListener);
    asyncInit();
  }

  Future asyncInit() async {
    state = state.copyWith(
        posts: await _postService.getPostsByUserIdFromDb(userId: userId));
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadPosts();
    }
  }

  Future loadPosts() async {
    state = state.copyWith(isPostLoading: true);
    try {
      await _postService.updatePostsByUserIdInDb(
          userId: userId, skip: state.posts.length, take: 12);
    } on NoNetworkException {}
    state = state.copyWith(
        posts: await _postService.getPostsByUserIdFromDb(userId: userId),
        isPostLoading: false);
  }
}
