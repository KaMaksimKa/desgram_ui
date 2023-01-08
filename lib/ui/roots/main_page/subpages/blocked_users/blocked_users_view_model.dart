import 'package:desgram_ui/data/services/blocked_service.dart';
import 'package:desgram_ui/domain/exceptions/not_found_exception.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/models/user/partial_user_model.dart';
import '../../../../common/something_went_wrong_dialog.dart';

class BlockedUsersViewModelState {
  final bool isBlockedUsersLoading;
  final List<PartialUserModel> blockedUsers;
  BlockedUsersViewModelState({
    required this.isBlockedUsersLoading,
    required this.blockedUsers,
  });

  BlockedUsersViewModelState copyWith({
    bool? isBlockedUsersLoading,
    List<PartialUserModel>? blockedUsers,
  }) {
    return BlockedUsersViewModelState(
      isBlockedUsersLoading:
          isBlockedUsersLoading ?? this.isBlockedUsersLoading,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}

class BlockedUsersViewModel extends SubpageViewModel {
  final BlockedService _blockedService = BlockedService();
  final ScrollController scrollController = ScrollController();

  BlockedUsersViewModelState _state = BlockedUsersViewModelState(
      blockedUsers: [], isBlockedUsersLoading: false);

  BlockedUsersViewModelState get state => _state;

  set state(BlockedUsersViewModelState val) {
    _state = val;
    notifyListeners();
  }

  BlockedUsersViewModel(
      {required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    asyncInit();
  }

  Future asyncInit() async {
    await _loadBlockedUsers(isDeleteOld: true);
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadBlockedUsers();
    }
  }

  Future _loadBlockedUsers({bool isDeleteOld = false}) async {
    if (state.isBlockedUsersLoading) {
      return;
    }
    state = state.copyWith(isBlockedUsersLoading: true);
    try {
      List<PartialUserModel> blockedUsers =
          isDeleteOld ? [] : List.from(state.blockedUsers);

      blockedUsers.addAll(await _blockedService.getBlokedUsers(
              skip: blockedUsers.length, take: 20) ??
          []);
      state = state.copyWith(blockedUsers: blockedUsers);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isBlockedUsersLoading: false);
    }
  }

  Future unblockUser({required String userId}) async {
    try {
      await _blockedService.unblockUser(userId: userId);
      var blockedUsers = state.blockedUsers;
      blockedUsers.removeWhere((element) => element.id == userId);
      state = state.copyWith(blockedUsers: blockedUsers);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on NotFoundException {
      var blockedUsers = state.blockedUsers;
      blockedUsers.removeWhere((element) => element.id == userId);
      state = state.copyWith(blockedUsers: blockedUsers);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}
