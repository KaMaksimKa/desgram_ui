import 'package:desgram_ui/data/services/subscription_service.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../domain/exceptions/exceptions.dart';
import '../../../../../domain/exceptions/not_found_exception.dart';
import '../../../../../domain/models/user/partial_user_model.dart';
import '../../../../common/something_went_wrong_dialog.dart';

class SubRequestsViewModelState {
  final bool isSubRequestsLoading;
  final List<PartialUserModel> subRequests;
  SubRequestsViewModelState({
    required this.isSubRequestsLoading,
    required this.subRequests,
  });

  SubRequestsViewModelState copyWith({
    bool? isSubRequestsLoading,
    List<PartialUserModel>? subRequests,
  }) {
    return SubRequestsViewModelState(
      isSubRequestsLoading: isSubRequestsLoading ?? this.isSubRequestsLoading,
      subRequests: subRequests ?? this.subRequests,
    );
  }
}

class SubRequestsViewModel extends SubpageViewModel {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final ScrollController scrollController = ScrollController();

  SubRequestsViewModelState _state =
      SubRequestsViewModelState(subRequests: [], isSubRequestsLoading: false);

  SubRequestsViewModelState get state => _state;

  set state(SubRequestsViewModelState val) {
    _state = val;
    notifyListeners();
  }

  SubRequestsViewModel(
      {required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    asyncInit();
  }

  Future asyncInit() async {
    await _loadSubRequests(isDeleteOld: true);
  }

  Future _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadSubRequests();
    }
  }

  Future _loadSubRequests({bool isDeleteOld = false}) async {
    if (state.isSubRequestsLoading) {
      return;
    }
    state = state.copyWith(isSubRequestsLoading: true);
    try {
      List<PartialUserModel> subRequests =
          isDeleteOld ? [] : List.from(state.subRequests);

      subRequests.addAll(await _subscriptionService.getSubRequests(
              skip: subRequests.length, take: 20) ??
          []);
      state = state.copyWith(subRequests: subRequests);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    } finally {
      state = state.copyWith(isSubRequestsLoading: false);
    }
  }

  Future deleteSubRequest({required PartialUserModel user}) async {
    try {
      await _subscriptionService.deleteSubRequest(followerId: user.id);
      var users = state.subRequests;
      users.remove(user);
      state = state.copyWith(subRequests: users);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on NotFoundException {
      var users = state.subRequests;
      users.remove(user);
      state = state.copyWith(subRequests: users);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future acceptSubRequest({required PartialUserModel user}) async {
    try {
      await _subscriptionService.acceptSubscription(followerId: user.id);
      var users = state.subRequests;
      users.remove(user);
      state = state.copyWith(subRequests: users);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on NotFoundException {
      var users = state.subRequests;
      users.remove(user);
      state = state.copyWith(subRequests: users);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}
