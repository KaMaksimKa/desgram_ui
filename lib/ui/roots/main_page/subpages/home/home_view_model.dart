import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/post/post_model.dart';

class HomeViewModelState {
  final bool isPostsLoading;
  final List<PostModel> posts;
  HomeViewModelState({
    this.isPostsLoading = false,
    this.posts = const [],
  });

  HomeViewModelState copyWith({
    bool? isPostsLoading,
    List<PostModel>? posts,
  }) {
    return HomeViewModelState(
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      posts: posts ?? this.posts,
    );
  }
}

class HomeViewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final PostService _postService = PostService();
  late final String currentUserId;

  HomeViewModelState _state = HomeViewModelState();

  HomeViewModelState get state => _state;

  set state(HomeViewModelState val) {
    _state = val;
    notifyListeners();
  }

  HomeViewModel({required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    SharedPrefs.getCurrentUserId().then((value) {
      currentUserId = value!;
      asyncInit();
    });
  }

  Future asyncInit() async {
    state = state.copyWith(posts: [], isPostsLoading: false);
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
      await _postService.updateSubscriptionPostsInDb(
          skip: state.posts.length, take: 12, isDeleteOld: isDeleteOld);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(
          posts: await _postService.getSubscriptionPostsFromDb(),
          isPostsLoading: false);
    }
  }
}
