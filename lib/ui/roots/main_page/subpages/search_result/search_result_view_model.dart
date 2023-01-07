import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/models/post/hashtag_model.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../data/services/user_service.dart';
import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/user/partial_user_model.dart';

class SearchResultViewModelState {
  final bool isHashtagLoading;
  final List<HashtagModel> hashtags;
  final bool isUsersLoading;
  final List<PartialUserModel> users;
  final int indexPageView;
  SearchResultViewModelState({
    required this.isHashtagLoading,
    required this.hashtags,
    required this.isUsersLoading,
    required this.users,
    required this.indexPageView,
  });

  SearchResultViewModelState copyWith({
    bool? isHashtagLoading,
    List<HashtagModel>? hashtags,
    bool? isUsersLoading,
    List<PartialUserModel>? users,
    int? indexPageView,
  }) {
    return SearchResultViewModelState(
      isHashtagLoading: isHashtagLoading ?? this.isHashtagLoading,
      hashtags: hashtags ?? this.hashtags,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      users: users ?? this.users,
      indexPageView: indexPageView ?? this.indexPageView,
    );
  }
}

class SearchResultViewModel extends SubpageViewModel {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  late final PageController pageController;
  final ScrollController hashtagsScrollController = ScrollController();
  final ScrollController usersScrollController = ScrollController();
  final String searchString;

  late SearchResultViewModelState _state;

  SearchResultViewModelState get state => _state;

  set state(SearchResultViewModelState val) {
    _state = val;
    if (pageController.hasClients) {
      pageController.animateToPage(val.indexPageView,
          curve: Curves.decelerate, duration: const Duration(milliseconds: 50));
    }
    notifyListeners();
  }

  SearchResultViewModel({
    required super.context,
    required super.mainPageNavigator,
    required this.searchString,
  }) {
    pageController = PageController(initialPage: getInitialPage(searchString));
    hashtagsScrollController.addListener(_hashtagsScrollListener);
    usersScrollController.addListener(_usersScrollListener);

    _state = SearchResultViewModelState(
        hashtags: [],
        indexPageView: getInitialPage(searchString),
        isHashtagLoading: false,
        isUsersLoading: false,
        users: []);
    asyncInit();
  }

  int getInitialPage(String searchString) {
    if (searchString.startsWith("#")) {
      return 1;
    } else {
      return 0;
    }
  }

  Future asyncInit() async {
    await loadHashtags(isDeleteOld: true);
    await loadUsers(isDeleteOld: true);
  }

  Future refreshHashtags() async {
    await loadHashtags(isDeleteOld: true);
  }

  Future refreshUsers() async {
    await loadUsers(isDeleteOld: true);
  }

  Future _hashtagsScrollListener() async {
    if (hashtagsScrollController.offset >=
            hashtagsScrollController.position.maxScrollExtent &&
        !hashtagsScrollController.position.outOfRange) {
      await loadHashtags();
    }
  }

  Future _usersScrollListener() async {
    if (usersScrollController.offset >=
            usersScrollController.position.maxScrollExtent &&
        !usersScrollController.position.outOfRange) {
      await loadUsers();
    }
  }

  Future loadHashtags({bool isDeleteOld = false}) async {
    if (state.isHashtagLoading) {
      return;
    }
    state = state.copyWith(isHashtagLoading: true);

    var searchStr = searchString;
    if (!searchStr.startsWith("#")) {
      searchStr = "#$searchStr";
    }

    try {
      List<HashtagModel> hashtags =
          isDeleteOld ? [] : List.from(state.hashtags);

      hashtags.addAll(await _postService.searchHashtags(
              searchString: searchStr, skip: hashtags.length, take: 20) ??
          []);
      state = state.copyWith(hashtags: hashtags);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(isHashtagLoading: false);
    }
  }

  Future loadUsers({bool isDeleteOld = false}) async {
    if (state.isUsersLoading) {
      return;
    }
    state = state.copyWith(isUsersLoading: true);

    var searchStr = searchString;
    if (searchStr.startsWith("#")) {
      searchStr = searchStr.substring(1);
    }

    try {
      List<PartialUserModel> users = isDeleteOld ? [] : List.from(state.users);

      users.addAll(await _userService.searchUsersByName(
              searchUserName: searchStr, skip: users.length, take: 20) ??
          []);
      state = state.copyWith(users: users);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(isUsersLoading: false);
    }
  }
}
