import 'package:desgram_ui/data/services/subscription_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/models/user/partial_user_model.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../domain/exceptions/forbidden_exception.dart';
import '../../../../common/no_network_dialog.dart';
import '../../../../common/something_went_wrong_dialog.dart';

class SubscriptionsViewModelState {
  final bool isFollowersLoading;
  final List<PartialUserModel> followers;
  final bool isFollowingLoading;
  final List<PartialUserModel> following;
  final SubscriptionType subscriptionType;
  SubscriptionsViewModelState({
    required this.isFollowersLoading,
    required this.followers,
    required this.isFollowingLoading,
    required this.following,
    required this.subscriptionType,
  });

  SubscriptionsViewModelState copyWith({
    bool? isFollowersLoading,
    List<PartialUserModel>? followers,
    bool? isFollowingLoading,
    List<PartialUserModel>? following,
    SubscriptionType? subscriptionType,
  }) {
    return SubscriptionsViewModelState(
      isFollowersLoading: isFollowersLoading ?? this.isFollowersLoading,
      followers: followers ?? this.followers,
      isFollowingLoading: isFollowingLoading ?? this.isFollowingLoading,
      following: following ?? this.following,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}

class SubscriptionsViewModel extends SubpageViewModel {
  UserModel? user;
  final String userId;
  late final String currentUserId;
  final UserService _userService = UserService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  final PageController pageController = PageController();
  final ScrollController followersScrollController = ScrollController();
  final ScrollController followingScrollController = ScrollController();

  late SubscriptionsViewModelState _state;

  SubscriptionsViewModelState get state => _state;

  set state(SubscriptionsViewModelState val) {
    _state = val;
    if (pageController.hasClients) {
      pageController.animateToPage(
          val.subscriptionType == SubscriptionType.followers ? 0 : 1,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 50));
    }
    notifyListeners();
  }

  SubscriptionsViewModel(
      {required super.context,
      required super.mainPageNavigator,
      required SubscriptionType subscriptionType,
      required this.userId}) {
    followersScrollController.addListener(_followersScrollListener);
    followingScrollController.addListener(_followingScrollListener);
    asyncInit();
    _state = SubscriptionsViewModelState(
        subscriptionType: subscriptionType,
        followers: [],
        following: [],
        isFollowersLoading: false,
        isFollowingLoading: false);
  }
  Future asyncInit() async {
    try {
      currentUserId = await _userService.getCurrentUserId();
      user = await _userService.getUserByIdFromDb(userId: userId);
      notifyListeners();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
    await loadFollowers(isDeleteOld: true);
    await loadFollowing(isDeleteOld: true);
  }

  Future refreshFollowers() async {
    await loadFollowers(isDeleteOld: true);
  }

  Future refreshFollowing() async {
    await loadFollowing(isDeleteOld: true);
  }

  Future _followersScrollListener() async {
    if (followersScrollController.offset >=
            followersScrollController.position.maxScrollExtent &&
        !followersScrollController.position.outOfRange) {
      await loadFollowers();
    }
  }

  Future _followingScrollListener() async {
    if (followingScrollController.offset >=
            followingScrollController.position.maxScrollExtent &&
        !followingScrollController.position.outOfRange) {
      await loadFollowing();
    }
  }

  Future loadFollowers({bool isDeleteOld = false}) async {
    if (state.isFollowersLoading) {
      return;
    }
    state = state.copyWith(isFollowersLoading: true);
    try {
      List<PartialUserModel> followers =
          isDeleteOld ? [] : List.from(state.followers);

      followers.addAll(await _subscriptionService.getUserFollowers(
              userId: userId, skip: followers.length, take: 20) ??
          []);
      state = state.copyWith(followers: followers);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on ForbiddenException {
      state = state.copyWith(followers: []);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isFollowersLoading: false);
    }
  }

  Future loadFollowing({bool isDeleteOld = false}) async {
    if (state.isFollowingLoading) {
      return;
    }
    state = state.copyWith(isFollowingLoading: true);
    try {
      List<PartialUserModel> following =
          isDeleteOld ? [] : List.from(state.following);

      following.addAll(await _subscriptionService.getUserFollowing(
              userId: userId, skip: following.length, take: 20) ??
          []);
      state = state.copyWith(following: following);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on ForbiddenException {
      state = state.copyWith(following: []);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isFollowingLoading: false);
    }
  }

  Future deleteFollower({required String followerId}) async {
    try {
      await _subscriptionService.deleteFollower(followerId: followerId);
      var followers = state.followers;
      followers.removeWhere((element) => element.id == followerId);
      state = state.copyWith(followers: followers);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}

enum SubscriptionType { followers, followings }
