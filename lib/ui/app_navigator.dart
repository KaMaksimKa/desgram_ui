import 'dart:io';

import 'package:desgram_ui/domain/models/try_create_user_model.dart';
import 'package:desgram_ui/ui/roots/choose_image_post/choose_image_post_widget.dart';
import 'package:desgram_ui/ui/roots/choose_new_avatar/choose_new_avatar_widget.dart';
import 'package:desgram_ui/ui/roots/create_post/create_post_widget.dart';
import 'package:desgram_ui/ui/roots/edit_birth_date_page.dart';
import 'package:desgram_ui/ui/roots/edit_image/edit_image_widget.dart';
import 'package:desgram_ui/ui/roots/edit_personal_information_page.dart';
import 'package:desgram_ui/ui/roots/edit_profile_page.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_widget.dart';
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
  static const editBirthDate = "/edit_birth_date";
  static const chooseNewAvatar = "/choose_new_avatar";
  static const editImage = "/edit_image";
  static const createPost = "/create_post";
  static const chooseImagePost = "/choose_image_post";
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

  static void popPage<T>([T? result]) {
    key.currentState?.pop(result);
  }

  static void toLoader() {
    key.currentState?.pushNamed(NavigationRoutes.loader);
  }

  static void toRegistr() {
    key.currentState?.pushNamed(NavigationRoutes.registr);
  }

  static void toConfirmUser(TryCreateUserModel tryCreateUserModel) {
    key.currentState?.pushNamed(NavigationRoutes.confirmUser,
        arguments: tryCreateUserModel);
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

  static Future toEditProfilePage() async {
    await key.currentState?.pushNamed(NavigationRoutes.editProfile);
  }

  static Future toEditPersonalInformationPage() async {
    await key.currentState?.pushNamed(NavigationRoutes.editPersonalInformation);
  }

  static Future toChooseNewAvatarPage() async {
    await key.currentState?.pushNamed(NavigationRoutes.chooseNewAvatar);
  }

  static Future<File?> toEditImagePage({required File file}) async {
    return await key.currentState
        ?.pushNamed<File>(NavigationRoutes.editImage, arguments: file);
  }

  static Future<File?> toChooseImagePostPage() async {
    return await key.currentState
        ?.pushNamed<File>(NavigationRoutes.chooseImagePost);
  }

  static Future toEditBirthDatePage(DateTime? oldBirthDate) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.editBirthDate, arguments: oldBirthDate);
  }

  static Future toCreatePostPage() async {
    await key.currentState?.pushNamed(NavigationRoutes.createPost);
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
                ConfirmUser.create(settings.arguments as TryCreateUserModel)));
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
      case NavigationRoutes.editBirthDate:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) =>
                EditBirthDatePage.create(settings.arguments as DateTime?)));
      case NavigationRoutes.chooseNewAvatar:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => ChooseNewAvatarWidget.create()));
      case NavigationRoutes.editImage:
        return PageRouteBuilder<File>(
            pageBuilder: ((_, __, ___) =>
                EditImageWidget.create(file: settings.arguments as File)));
      case NavigationRoutes.createPost:
        return PageRouteBuilder<File>(
            pageBuilder: ((_, __, ___) => CreatePostWidget.create()));
      case NavigationRoutes.chooseImagePost:
        return PageRouteBuilder<File>(
            pageBuilder: ((_, __, ___) => ChooseImagePostWidget.create()));
    }
    return null;
  }
}
