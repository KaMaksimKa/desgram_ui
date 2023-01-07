import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/data/services/db_service.dart';
import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/models/post/hashtag_model.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

class SearchSuggestionsViewModelState {
  final List<String> suggestionsSearchString;
  final List<PartialUserModel> suggestionsUsers;
  final List<HashtagModel> suggestionsHashtags;
  final bool isLoading;
  final String searchString;
  SearchSuggestionsViewModelState(
      {required this.searchString,
      required this.suggestionsSearchString,
      required this.suggestionsUsers,
      required this.suggestionsHashtags,
      this.isLoading = false});

  SearchSuggestionsViewModelState copyWith(
      {List<String>? suggestionsSearchString,
      List<PartialUserModel>? suggestionsUsers,
      List<HashtagModel>? suggestionsHashtags,
      bool? isLoading,
      String? searchString}) {
    return SearchSuggestionsViewModelState(
      searchString: searchString ?? this.searchString,
      suggestionsSearchString:
          suggestionsSearchString ?? this.suggestionsSearchString,
      suggestionsUsers: suggestionsUsers ?? this.suggestionsUsers,
      suggestionsHashtags: suggestionsHashtags ?? this.suggestionsHashtags,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SearchSuggestionsViewModel extends SubpageViewModel {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final DbService _dbService = DbService();
  final TextEditingController searchController = TextEditingController();

  SearchSuggestionsViewModelState _state = SearchSuggestionsViewModelState(
      suggestionsHashtags: [],
      suggestionsSearchString: [],
      suggestionsUsers: [],
      searchString: "");

  SearchSuggestionsViewModelState get state => _state;

  set state(SearchSuggestionsViewModelState val) {
    _state = val;
    notifyListeners();
  }

  SearchSuggestionsViewModel(
      {required super.context, required super.mainPageNavigator}) {
    searchController.addListener(() {
      state = state.copyWith(searchString: searchController.text);
    });
    asyncInit();
  }

  Future asyncInit() async {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(
        isLoading: false,
        suggestionsSearchString: await _dbService.getSearchString(count: 10));
  }

  Future onChangedSearchString(String searchString) async {
    state = state.copyWith(isLoading: true);
    if (searchString.isEmpty) {
      state = state.copyWith(
          isLoading: false,
          suggestionsHashtags: [],
          suggestionsUsers: [],
          suggestionsSearchString: await _dbService.getSearchString(count: 10));
      return;
    }
    try {
      state = state.copyWith(
          isLoading: false,
          suggestionsSearchString: await _dbService.getSearchString(
              count: 7, searchString: searchString),
          suggestionsHashtags: await _postService.searchHashtags(
              searchString: searchString, skip: 0, take: 7),
          suggestionsUsers: await _userService.searchUsersByName(
              searchUserName: searchString, skip: 0, take: 7));
    } on NoNetworkException {
      state = state.copyWith(
        isLoading: false,
        suggestionsSearchString: await _dbService.getSearchString(
            count: 7, searchString: searchString),
      );
    }
  }

  Future toSearchResult(String searchString) async {
    if (searchString.isEmpty) {
      return;
    }
    await _dbService.addSearchString(searchString: searchString);
    mainPageNavigator.pop();
    mainPageNavigator.toSearchResult(searchString: searchString);
  }
}
