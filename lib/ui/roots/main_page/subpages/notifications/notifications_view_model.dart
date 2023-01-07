import 'package:desgram_ui/domain/exceptions/not_found_exception.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/data/services/notification_service.dart';
import 'package:desgram_ui/data/services/subscription_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/models/notification/notification_model.dart';
import 'package:desgram_ui/domain/models/notification/subscription_notification_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

class NotificationsViewModelState {
  final List<NotificationModel> notifications;
  final bool isNotificationsLoading;
  final bool areSubRequestsExist;
  NotificationsViewModelState({
    required this.notifications,
    required this.isNotificationsLoading,
    required this.areSubRequestsExist,
  });

  NotificationsViewModelState copyWith({
    List<NotificationModel>? notifications,
    bool? isNotificationsLoading,
    bool? areSubRequestsExist,
  }) {
    return NotificationsViewModelState(
      notifications: notifications ?? this.notifications,
      isNotificationsLoading:
          isNotificationsLoading ?? this.isNotificationsLoading,
      areSubRequestsExist: areSubRequestsExist ?? this.areSubRequestsExist,
    );
  }
}

class NotificationsViewModel extends SubpageViewModel {
  final ScrollController scrollController = ScrollController();
  final NotificationService _notificationService = NotificationService();
  final SubscriptionService _subscriptionService = SubscriptionService();

  NotificationsViewModelState _state = NotificationsViewModelState(
      notifications: [],
      isNotificationsLoading: false,
      areSubRequestsExist: false);

  NotificationsViewModelState get state => _state;

  set state(NotificationsViewModelState val) {
    _state = val;
    notifyListeners();
  }

  NotificationsViewModel(
      {required super.context, required super.mainPageNavigator}) {
    scrollController.addListener(_scrollListener);
    _asyncInit();
  }
  void _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await _loadNotifications();
    }
  }

  Future _asyncInit() async {
    await _loadNotifications(isDeleteOld: true);
    state = state.copyWith(areSubRequestsExist: await checkSubRequests());
  }

  Future refresh() async {
    await _asyncInit();
  }

  Future _loadNotifications({bool isDeleteOld = false}) async {
    if (state.isNotificationsLoading) {
      return;
    }

    state = state.copyWith(isNotificationsLoading: true);
    try {
      List<NotificationModel> notifications =
          isDeleteOld ? [] : List.from(state.notifications);
      notifications.addAll(await _notificationService.getNotifications(
              skipDate:
                  notifications.isEmpty ? null : notifications.last.createdDate,
              take: 20) ??
          []);
      state = state.copyWith(notifications: notifications);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(isNotificationsLoading: false);
    }
  }

  Future deleteSubRequest({required NotificationModel notification}) async {
    try {
      var subscription = notification.subscription;
      if (subscription == null || subscription.isApproved) {
        return;
      }
      await _subscriptionService.deleteSubRequest(
          followerId: subscription.user.id);
      var notifications = state.notifications;
      notifications.remove(notification);
      state = state.copyWith(notifications: notifications);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    }
  }

  Future acceptSubRequest({required NotificationModel notification}) async {
    try {
      var subscription = notification.subscription;
      if (subscription == null || subscription.isApproved) {
        return;
      }
      await _subscriptionService.acceptSubscription(
          followerId: subscription.user.id);

      var notifications = state.notifications;
      notifications.remove(notification);

      notifications.add(
        NotificationModel(
            createdDate: notification.createdDate,
            hasViewed: notification.hasViewed,
            subscription: SubscriptionNotificationModel(
                isApproved: true, user: subscription.user)),
      );
      state = state.copyWith(notifications: notifications);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } on NotFoundException {
      var notifications = state.notifications;
      notifications.remove(notification);
      state = state.copyWith(notifications: notifications);
    }
  }

  Future<bool> checkSubRequests() async {
    try {
      var subRequests =
          await _subscriptionService.getSubRequests(skip: 0, take: 1);
      if (subRequests == null) {
        return false;
      }
      return subRequests.isNotEmpty;
    } on NoNetworkException {
      return false;
    }
  }
}
