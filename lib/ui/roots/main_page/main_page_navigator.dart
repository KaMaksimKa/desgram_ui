import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/blocked_users/blocked_users_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/change_password/change_password_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/comment_page/comment_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/feed_hashtag/feed_hashtag_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/feed_interesting%20copy/feed_interesting_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/feed_user/feed_user_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/home/home_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/search_result/search_result_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/search_suggestions/search_suggestions_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/settings/settings_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/sub_requests/sub_requests_widget.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subscriptions/subscriptions_view_model.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subscriptions/subscriptions_widget.dart';
import 'package:flutter/material.dart';

import 'subpages/account/account_widget.dart';
import 'subpages/add_content.dart';
import 'subpages/another_account/another_account_widget.dart';
import 'subpages/notifications/notifications_widget.dart';
import 'subpages/search/search_widget.dart';

class MainPageRoutes {
  static const homeContent = "home_content";
  static const searchContent = "search_content";
  static const addContent = "add_content";
  static const notificationsContent = "notifications_content";
  static const accountContent = "account_content";
  static const anotherAccount = "another_account";
  static const feedUser = "feed_user";
  static const searchSuggestions = "search_suggestions";
  static const searchResult = "search_result";
  static const feedInteresting = "feed_interesting";
  static const feedHashtag = "feed_hashtag";
  static const comment = "comment";
  static const subscriptions = "subscriptions";
  static const settings = "settings";
  static const blockedUsers = "blocked_users";
  static const chagePassword = "chage_password";
  static const subRequests = "sub_requests";
}

class MainPageNavigator {
  final key = GlobalKey<NavigatorState>();

  Future toAnotherAccountContent({required String userId}) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.anotherAccount, arguments: userId);
  }

  Future toAccountPage() async {
    await key.currentState?.pushNamed(MainPageRoutes.accountContent);
  }

  Future toSearchSuggestions() async {
    await key.currentState?.pushNamed(MainPageRoutes.searchSuggestions);
  }

  Future toSearchResult({required String searchString}) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.searchResult, arguments: searchString);
  }

  Future toFeedUser(String userId) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.feedUser, arguments: userId);
  }

  Future toFeedInteresting() async {
    await key.currentState?.pushNamed(MainPageRoutes.feedInteresting);
  }

  Future toSubscriptions(
      {required String userId,
      required SubscriptionType subscriptionType}) async {
    await key.currentState?.pushNamed(MainPageRoutes.subscriptions,
        arguments: {"subscriptionType": subscriptionType, "userId": userId});
  }

  Future toComment({required PostModel postModel}) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.comment, arguments: postModel);
  }

  Future toFeedHashtag({required String hashtag}) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.feedHashtag, arguments: hashtag);
  }

  Future toSettings() async {
    await key.currentState?.pushNamed(MainPageRoutes.settings);
  }

  Future toBlockedUsers() async {
    await key.currentState?.pushNamed(MainPageRoutes.blockedUsers);
  }

  Future toChangePassword() async {
    await key.currentState?.pushNamed(MainPageRoutes.chagePassword);
  }

  Future toSubRequests() async {
    await key.currentState?.pushNamed(MainPageRoutes.subRequests);
  }

  void pop<T>([T? result]) {
    key.currentState?.pop(result);
  }

  Route<dynamic>? onGeneratedRoutes(
      RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case MainPageRoutes.homeContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => HomeWidget.create(this)));
      case MainPageRoutes.searchContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => SearchWidget.create(this)));
      case MainPageRoutes.addContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AddContent.create(this)));
      case MainPageRoutes.notificationsContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => NotificationsWidget.create(this)));
      case MainPageRoutes.accountContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AccountWidget.create(this)));
      case MainPageRoutes.anotherAccount:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AnotherAccountWidget.create(
                mainPageNavigator: this,
                userId: settings.arguments as String)));
      case MainPageRoutes.feedUser:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                FeedUserWidget.create(this, settings.arguments as String)));
      case MainPageRoutes.searchSuggestions:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                SearchSuggestionsWidget.create(this)));
      case MainPageRoutes.searchResult:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => SearchResultWidget.create(
                mainPageNavigator: this,
                searchString: settings.arguments as String)));
      case MainPageRoutes.feedInteresting:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => FeedInterestingWidget.create(this)));
      case MainPageRoutes.comment:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => CommentWidget.create(
                mainPageNavigator: this,
                postModel: settings.arguments as PostModel)));
      case MainPageRoutes.subscriptions:
        var argumentsMap = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => SubscriptionsWidget.create(
                mainPageNavigator: this,
                subscriptionType:
                    argumentsMap["subscriptionType"] as SubscriptionType,
                userId: argumentsMap["userId"] as String)));
      case MainPageRoutes.feedHashtag:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => FeedHashtagWidget.create(
                mainPageNavigator: this,
                hashtag: settings.arguments as String)));
      case MainPageRoutes.settings:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                SettingsWidget.create(mainPageNavigator: this)));
      case MainPageRoutes.blockedUsers:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                BlockedUsersWidget.create(mainPageNavigator: this)));

      case MainPageRoutes.chagePassword:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                ChangePasswordWidget.create(mainPageNavigator: this)));

      case MainPageRoutes.subRequests:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                SubRequestsWidget.create(mainPageNavigator: this)));
    }
    return null;
  }
}
