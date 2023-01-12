import 'package:desgram_ui/data/services/blocked_service.dart';
import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/data/services/subscription_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subscriptions/subscriptions_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/exceptions/forbidden_exception.dart';
import '../../../../common/something_went_wrong_dialog.dart';
import '../account/account_view_model.dart';

class AnotherAccountViewModel extends SubpageViewModel {
  final String userId;

  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final BlockedService _blockedService = BlockedService();
  final SubscriptionService _subscribeService = SubscriptionService();
  ScrollController scrollController = ScrollController();

  AccountViewModelState _state = const AccountViewModelState(
    currentUserModel: null,
    posts: [],
    isPostsLoading: false,
  );
  AccountViewModelState get state => _state;
  set state(AccountViewModelState val) {
    _state = val;
    notifyListeners();
  }

  AnotherAccountViewModel(
      {required super.context,
      required super.mainPageNavigator,
      required this.userId}) {
    SharedPrefs.getCurrentUserId().then(
      (value) {
        if (value == userId) {
          mainPageNavigator.pop();
          mainPageNavigator.toAccountPage();
        } else {
          scrollController.addListener(_scrollListener);
          UserService.updateUserListeners.add(onUserUpdate);
          asyncInit();
        }
      },
    );
  }
  Future onUserUpdate({required UserModel userModel}) async {
    if (userModel.id == userId) {
      state = state.copyWith(currentUserModel: userModel);
    }
  }

  @override
  void dispose() {
    UserService.updateUserListeners.remove(onUserUpdate);
    super.dispose();
  }

  Future asyncInit() async {
    _updateUser();
    _loadPosts(isDeleteOld: true);
  }

  Future _updateUser() async {
    state = state.copyWith(
        currentUserModel: await _userService.getUserByIdFromDb(userId: userId));
    try {
      await _userService.updateUserInDb(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future _loadPosts({bool isDeleteOld = false}) async {
    if (state.isPostsLoading) {
      return;
    }
    state =
        state.copyWith(isPostsLoading: true, posts: isDeleteOld ? [] : null);
    try {
      await _postService.updatePostsByUserIdInDb(
          userId: userId,
          skip: state.posts.length,
          take: 12,
          isDeleteOld: isDeleteOld);
      // ignore: empty_catches
    } on ForbiddenException {
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(
          isPostsLoading: false,
          posts: await _postService.getPostsByUserIdFromDb(userId: userId));
    }
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadPosts();
    }
  }

  Future subscribe() async {
    try {
      await _subscribeService.subscribe(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future unsubscribe() async {
    try {
      await _subscribeService.unsubscribe(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future deleteRequest() async {
    try {
      await _subscribeService.unsubscribe(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future toFollowers() async {
    mainPageNavigator.toSubscriptions(
        userId: userId, subscriptionType: SubscriptionType.followers);
  }

  Future toFollowing() async {
    mainPageNavigator.toSubscriptions(
        userId: userId, subscriptionType: SubscriptionType.followings);
  }

  Future showMoreAnotherAccount() async {
    var userModel = state.currentUserModel;
    if (userModel == null) {
      return;
    }
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 67, 67),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              const SizedBox(
                height: 10,
              ),
              userModel.blockedByViewer
                  ? TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        unblockUser();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Разблокировать",
                      ))
                  : TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size.fromHeight(50),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        blockUser();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Заблокировать",
                      )),
              const SizedBox(
                height: 20,
              ),
            ]),
          );
        });
    notifyListeners();
  }

  Future blockUser() async {
    try {
      await _blockedService.blockUser(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future unblockUser() async {
    try {
      await _blockedService.unblockUser(userId: userId);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}
