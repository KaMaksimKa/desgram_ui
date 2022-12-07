import 'package:desgram_ui/ui/roots/edit_personal_information_page.dart';
import 'package:desgram_ui/ui/roots/edit_profile_page.dart';
import 'package:desgram_ui/ui/roots/main_page.dart';
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
  static const mainPage = "/main_page";
  static const editProfile = "/edit_profile";
  static const editPersonalInformation = "/edit_personal_information";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static void toAuth({bool isRemoveUntil = false}) {
    if (isRemoveUntil) {
      key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.auth,
        (route) => false,
      );
    } else {
      key.currentState?.pushNamed(NavigationRoutes.auth);
    }
  }

  static void popPage() {
    key.currentState?.pop();
  }

  static void toLoader() {
    key.currentState?.pushNamed(NavigationRoutes.loader);
  }

  static void toRegistr() {
    key.currentState?.pushNamed(NavigationRoutes.registr);
  }

  static void toConfirmUser(String email) {
    key.currentState?.pushNamed(NavigationRoutes.confirmUser, arguments: email);
  }

  static void toMainPage({bool isRemoveUntil = false}) {
    if (isRemoveUntil) {
      key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.mainPage,
        (route) => false,
      );
    } else {
      key.currentState?.pushNamed(NavigationRoutes.mainPage);
    }
  }

  static void toEditProfilePage() {
    key.currentState?.pushNamed(NavigationRoutes.editProfile);
  }

  static void toEditPersonalInformationPage() {
    key.currentState?.pushNamed(NavigationRoutes.editPersonalInformation);
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
      case NavigationRoutes.loader:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Loader.create()));
      case NavigationRoutes.mainPage:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => MainPage.create()));
      case NavigationRoutes.editProfile:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => EditProfilePage.create()));
      case NavigationRoutes.editPersonalInformation:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                EditPersonalInformationPage.create()));
    }
    return null;
  }
}
