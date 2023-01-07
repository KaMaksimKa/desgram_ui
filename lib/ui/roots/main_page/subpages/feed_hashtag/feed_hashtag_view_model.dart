import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/post/post_model.dart';
import '../../../../../inrernal/config/shared_prefs.dart';

class FeedHashtagViewModelState {
  final bool isPostsLoading;
  final List<PostModel> posts;
  FeedHashtagViewModelState({
    this.isPostsLoading = false,
    this.posts = const [],
  });

  FeedHashtagViewModelState copyWith({
    bool? isPostsLoading,
    List<PostModel>? posts,
  }) {
    return FeedHashtagViewModelState(
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      posts: posts ?? this.posts,
    );
  }
}

class FeedHashtagViewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final PostService _postService = PostService();
  final String hashtag;
  late final String currentUserId;

  FeedHashtagViewModelState _state = FeedHashtagViewModelState();

  FeedHashtagViewModelState get state => _state;

  set state(FeedHashtagViewModelState val) {
    _state = val;
    notifyListeners();
  }

  FeedHashtagViewModel({
    required super.context,
    required super.mainPageNavigator,
    required this.hashtag,
  }) {
    scrollController.addListener(_scrollListener);
    SharedPrefs.getCurrentUserId().then((value) {
      currentUserId = value!;
      asyncInit();
    });
  }

  Future asyncInit() async {
    await loadPosts(isDeleteOld: true);
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      loadPosts();
    }
  }

  Future loadPosts({bool isDeleteOld = false}) async {
    if (state.isPostsLoading) {
      return;
    }
    state = state.copyWith(isPostsLoading: true);
    try {
      await _postService.updateHashtagPostsInDb(
          hashtag: hashtag,
          skip: isDeleteOld ? 0 : state.posts.length,
          take: 12,
          isDeleteOld: isDeleteOld);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(
          posts: await _postService.getHashtagPostsFromDb(hashtag: hashtag),
          isPostsLoading: false);
    }
  }
}
