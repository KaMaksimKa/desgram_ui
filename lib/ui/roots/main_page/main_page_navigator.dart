import 'package:desgram_ui/ui/roots/main_page/subpages/feed_user/feed_user_widget.dart';
import 'package:flutter/material.dart';

import 'subpages/account/account_widget.dart';
import 'subpages/add_content.dart';
import 'subpages/another_account_content.dart';
import 'subpages/home_content.dart';
import 'subpages/notifications_content .dart';
import 'subpages/search_content.dart';

class MainPageRoutes {
  static const homeContent = "home_content";
  static const searchContent = "search_content";
  static const addContent = "add_content";
  static const notificationsContent = "notifications_content";
  static const accountContent = "account_content";
  static const anotherAccountContent = "another_account_content";
  static const feedUser = "feed_user";
}

class MainPageNavigator {
  final key = GlobalKey<NavigatorState>();

  Future toAnotherAccountContent() async {
    await key.currentState?.pushNamed(MainPageRoutes.anotherAccountContent);
  }

  Future toFeedUser(String userId) async {
    await key.currentState
        ?.pushNamed(MainPageRoutes.feedUser, arguments: userId);
  }

  Route<dynamic>? onGeneratedRoutes(
      RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case MainPageRoutes.homeContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => HomeContent.create(this)));
      case MainPageRoutes.searchContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => SearchContent.create(this)));
      case MainPageRoutes.addContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AddContent.create(this)));
      case MainPageRoutes.notificationsContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => NotificationsContent.create(this)));
      case MainPageRoutes.accountContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AccountWidget.create(this)));
      case MainPageRoutes.anotherAccountContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AnotherAccountContent.create(this)));
      case MainPageRoutes.feedUser:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                FeedUserWidget.create(this, settings.arguments as String)));
    }
    return null;
  }
}
