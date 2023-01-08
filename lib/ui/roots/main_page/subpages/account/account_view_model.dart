import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../data/services/auth_service.dart';
import '../../../../../data/services/post_service.dart';
import '../../../../../data/services/user_service.dart';
import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/post/post_model.dart';
import '../../../../../domain/models/user/user_model.dart';
import '../../../../../inrernal/config/shared_prefs.dart';
import '../../../../app_navigator.dart';
import '../../../../common/something_went_wrong_dialog.dart';
import '../../main_page_navigator.dart';
import '../subscriptions/subscriptions_view_model.dart';

class AccountViewModelState {
  final UserModel? currentUserModel;
  final List<PostModel> posts;
  final bool isPostsLoading;

  const AccountViewModelState({
    required this.currentUserModel,
    required this.posts,
    required this.isPostsLoading,
  });

  AccountViewModelState copyWith({
    UserModel? currentUserModel,
    List<PostModel>? posts,
    bool? isPostsLoading,
  }) {
    return AccountViewModelState(
      currentUserModel: currentUserModel ?? this.currentUserModel,
      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
    );
  }
}

class AccountViewModel extends SubpageViewModel {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  ScrollController scrollController = ScrollController();
  late final String currentUserId;

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

  AccountViewModel({
    required super.context,
    required super.mainPageNavigator,
  }) {
    scrollController.addListener(_scrollListener);
    UserService.updateUserListeners.add(onUserUpdate);
    SharedPrefs.getCurrentUserId().then((value) {
      currentUserId = value!;
      asyncInit();
    });
  }

  Future onUserUpdate({required UserModel userModel}) async {
    if (userModel.id == currentUserId) {
      state = state.copyWith(currentUserModel: userModel);
    }
  }

  @override
  void dispose() {
    UserService.updateUserListeners.remove(onUserUpdate);
    super.dispose();
  }

  Future asyncInit() async {
    _updateCurrentUser();
    _loadPosts(isDeleteOld: true);
  }

  Future _updateCurrentUser() async {
    state = state.copyWith(
        currentUserModel:
            await _userService.getUserByIdFromDb(userId: currentUserId));
    try {
      await _userService.updateUserInDb(userId: currentUserId);
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
          userId: currentUserId,
          skip: state.posts.length,
          take: 12,
          isDeleteOld: isDeleteOld);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(
          isPostsLoading: false,
          posts:
              await _postService.getPostsByUserIdFromDb(userId: currentUserId));
    }
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadPosts();
    }
  }

  void _logout() {
    try {
      _authService.logout();
      AppNavigator.toAuth(isRemoveUntil: true);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  void showAccountMenu() {
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
              TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    mainPageNavigator.toSettings();
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                  label: const Text(
                    "Настройки",
                  )),
              TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                  ),
                  label: const Text(
                    "Выйти из аккаунта",
                  )),
              const SizedBox(
                height: 20,
              ),
            ]),
          );
        });
    notifyListeners();
  }

  void toEditProfilePage() {
    AppNavigator.toEditProfilePage();
  }

  Future toFollowers() async {
    mainPageNavigator.toSubscriptions(
        userId: currentUserId, subscriptionType: SubscriptionType.followers);
  }

  Future toFollowing() async {
    mainPageNavigator.toSubscriptions(
        userId: currentUserId, subscriptionType: SubscriptionType.followings);
  }
}
