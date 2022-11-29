import 'package:desgram_ui/ui/roots/authorization.dart';
import 'package:desgram_ui/ui/roots/confirm_user.dart';
import 'package:desgram_ui/ui/roots/registration.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loader = "/";
  static const auth = "/auth";
  static const registr = "/registr";
  static const confirmUser = "/confirm_user";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toAuth() {
    key.currentState?.pushNamed(NavigationRoutes.auth);
  }

  static void toRegistr() {
    key.currentState?.pushNamed(NavigationRoutes.registr);
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
    }
    return null;
  }
}
