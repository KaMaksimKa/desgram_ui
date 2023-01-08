import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../data/services/auth_service.dart';
import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/post/post_model.dart';
import '../../../../common/something_went_wrong_dialog.dart';

class SearchViewModelState {
  final List<PostModel> posts;
  final bool isPostsLoading;

  const SearchViewModelState({
    required this.posts,
    required this.isPostsLoading,
  });

  SearchViewModelState copyWith({
    List<PostModel>? posts,
    bool? isPostsLoading,
  }) {
    return SearchViewModelState(
      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
    );
  }
}

class SearchViewModel extends SubpageViewModel {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  ScrollController scrollController = ScrollController();

  SearchViewModelState _state = const SearchViewModelState(
    posts: [],
    isPostsLoading: false,
  );
  SearchViewModelState get state => _state;
  set state(SearchViewModelState val) {
    _state = val;
    notifyListeners();
  }

  SearchViewModel({required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    asyncInit();
  }

  Future asyncInit() async {
    state = state.copyWith(isPostsLoading: false, posts: []);
    await _loadPosts(isDeleteOld: true);
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadPosts();
    }
  }

  Future _loadPosts({bool isDeleteOld = false}) async {
    if (state.isPostsLoading) {
      return;
    }
    state =
        state.copyWith(isPostsLoading: true, posts: isDeleteOld ? [] : null);
    try {
      await _postService.updateInterestingPostsInDb(
          skip: state.posts.length, take: 18, isDeleteOld: isDeleteOld);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(
          isPostsLoading: false,
          posts: await _postService.getInterestingPostsFromDb());
    }
  }
}
