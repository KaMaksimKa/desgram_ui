import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/post/post_model.dart';
import '../../../../../inrernal/config/shared_prefs.dart';

class FeedInterestingViewModelState {
  final bool isPostsLoading;
  final List<PostModel> posts;
  FeedInterestingViewModelState({
    this.isPostsLoading = false,
    this.posts = const [],
  });

  FeedInterestingViewModelState copyWith({
    bool? isPostsLoading,
    List<PostModel>? posts,
  }) {
    return FeedInterestingViewModelState(
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      posts: posts ?? this.posts,
    );
  }
}

class FeedInterestingViewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final PostService _postService = PostService();
  late final String currentUserId;

  FeedInterestingViewModelState _state = FeedInterestingViewModelState();

  FeedInterestingViewModelState get state => _state;

  set state(FeedInterestingViewModelState val) {
    _state = val;
    notifyListeners();
  }

  FeedInterestingViewModel(
      {required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    SharedPrefs.getCurrentUserId().then((value) {
      currentUserId = value!;
      asyncInit();
    });
  }

  Future asyncInit() async {
    state = state.copyWith(
        isPostsLoading: false,
        posts: await _postService.getInterestingPostsFromDb());
  }

  Future refresh() async {
    state = state.copyWith(posts: []);
    await loadPosts(isDeleteOld: true);
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await loadPosts();
    }
  }

  Future loadPosts({bool isDeleteOld = false}) async {
    if (state.isPostsLoading) {
      return;
    }
    state = state.copyWith(isPostsLoading: true);
    try {
      await _postService.updateInterestingPostsInDb(
          skip: state.posts.length, take: 12, isDeleteOld: isDeleteOld);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(
          posts: await _postService.getInterestingPostsFromDb(),
          isPostsLoading: false);
    }
  }
}
