import 'package:desgram_ui/ui/roots/user_page.dart';
import 'package:desgram_ui/ui/roots/authorization.dart';
import 'package:desgram_ui/ui/roots/confirm_user.dart';
import 'package:desgram_ui/ui/roots/loader.dart';
import 'package:desgram_ui/ui/roots/registration.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loader = "/loader";
  static const auth = "/auth";
  static const registr = "/registr";
  static const confirmUser = "/confirm_user";
  static const userPage = "/user_page";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toAuth() {
    key.currentState?.pushNamedAndRemoveUntil(
      NavigationRoutes.auth,
      (route) => false,
    );
  }

  static void toLoader() {
    key.currentState?.pushNamed(NavigationRoutes.loader);
  }

  static void toRegistr() {
    key.currentState?.pushNamed(NavigationRoutes.registr);
  }

  static void toUserPage({bool isRemoveUntil = false}) {
    if (isRemoveUntil) {
      key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.userPage,
        (route) => false,
      );
    } else {
      key.currentState?.pushNamed(NavigationRoutes.userPage);
    }
  }

  static void toConfirmUser(String email) {
    key.currentState?.pushNamed(NavigationRoutes.confirmUser, arguments: email);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => Authorization.create()));
      case NavigationRoutes.registr:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => Registration.create()));
      case NavigationRoutes.confirmUser:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                ConfirmUser.create(settings.arguments as String)));
      case NavigationRoutes.userPage:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => UserPage.create()));
      case NavigationRoutes.loader:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Loader.create()));
    }
    return null;
  }
}
