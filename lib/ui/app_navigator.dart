import 'dart:io';

import 'package:desgram_ui/domain/models/comment/comment_model.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/domain/models/user/personal_information_model.dart';
import 'package:desgram_ui/domain/models/user/try_create_user_model.dart';
import 'package:desgram_ui/ui/roots/change_email/change_email_page.dart';
import 'package:desgram_ui/ui/roots/change_username/change_username_page.dart';
import 'package:desgram_ui/ui/roots/choose_image/choose_image_widget.dart';
import 'package:desgram_ui/ui/roots/confirm_email/confirm_email_page.dart';
import 'package:desgram_ui/ui/roots/create_post/create_post_widget.dart';
import 'package:desgram_ui/ui/roots/edit_birth_date/edit_birth_date_page.dart';
import 'package:desgram_ui/ui/roots/edit_comment/edit_comment_page.dart';
import 'package:desgram_ui/ui/app_widgets/edit_image_widget.dart';
import 'package:desgram_ui/ui/roots/edit_personal_information/edit_personal_information_page.dart';
import 'package:desgram_ui/ui/roots/edit_post/edit_post_page.dart';
import 'package:desgram_ui/ui/roots/edit_profile/edit_profile_page.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_widget.dart';
import 'package:desgram_ui/ui/roots/authorization/authorization_page.dart';
import 'package:desgram_ui/ui/roots/confirm_user/confirm_user_page.dart';
import 'package:desgram_ui/ui/roots/loader.dart';
import 'package:desgram_ui/ui/roots/registration/registration_page.dart';
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
  static const chooseImage = "/choose_image";
  static const editImage = "/edit_image";
  static const createPost = "/create_post";
  static const changeEmail = "/change_email";
  static const confirmEmail = "/confirm_email";
  static const changeUserName = "/change_user_name";
  static const editPost = "/edit_post";
  static const editComment = "/edit_comment";
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

  static void toMainPage({int indexBottomBar = 0, bool isRemoveUntil = false}) {
    if (isRemoveUntil) {
      key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.mainPage,
        (route) => false,
      );
    } else {
      key.currentState
          ?.pushNamed(NavigationRoutes.mainPage, arguments: indexBottomBar);
    }
  }

  static Future toEditProfilePage() async {
    await key.currentState?.pushNamed(NavigationRoutes.editProfile);
  }

  static Future toEditPersonalInformationPage() async {
    await key.currentState?.pushNamed(NavigationRoutes.editPersonalInformation);
  }

  static Future<File?> toChooseImagePage() async {
    return await key.currentState
        ?.pushNamed<File>(NavigationRoutes.chooseImage);
  }

  static Future<File?> toEditImagePage({required File file}) async {
    return await key.currentState
        ?.pushNamed<File>(NavigationRoutes.editImage, arguments: file);
  }

  static Future toEditBirthDatePage(DateTime? oldBirthDate) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.editBirthDate, arguments: oldBirthDate);
  }

  static Future toCreatePostPage() async {
    await key.currentState?.pushNamed(NavigationRoutes.createPost);
  }

  static Future toChangeEmailPage(PersonalInformationModel model) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.changeEmail, arguments: model);
  }

  static Future toConfirmEmail({required String newEmail}) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.confirmEmail, arguments: newEmail);
  }

  static Future toChangeUserName({required String oldUserName}) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.changeUserName, arguments: oldUserName);
  }

  static Future toEditPostPage({required PostModel postModel}) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.editPost, arguments: postModel);
  }

  static Future toEditComment({required CommentModel commentModel}) async {
    await key.currentState
        ?.pushNamed(NavigationRoutes.editComment, arguments: commentModel);
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.auth:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AuthorizationPage.create()));
      case NavigationRoutes.registr:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => RegistrationPage.create()));
      case NavigationRoutes.confirmUser:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => ConfirmUserPage.create(
                settings.arguments as TryCreateUserModel)));
      case NavigationRoutes.loader:
        return PageRouteBuilder(pageBuilder: ((_, __, ___) => Loader.create()));
      case NavigationRoutes.mainPage:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => MainPage.create(
                indexBottomBar: (settings.arguments as int?) ?? 0)));
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
      case NavigationRoutes.chooseImage:
        return PageRouteBuilder<File>(
            pageBuilder: ((_, __, ___) => ChooseImageWidget.create()));
      case NavigationRoutes.editImage:
        return PageRouteBuilder<File>(
            pageBuilder: ((_, __, ___) =>
                EditImageWidget(fileImage: settings.arguments as File)));
      case NavigationRoutes.createPost:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => CreatePostWidget.create()));

      case NavigationRoutes.changeEmail:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => ChangeEmailPage.create(
                settings.arguments as PersonalInformationModel)));
      case NavigationRoutes.confirmEmail:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => ConfirmEmailPage.create(
                newEmail: settings.arguments as String)));
      case NavigationRoutes.changeUserName:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => ChangeUserNamePage.create(
                oldUserName: settings.arguments as String)));
      case NavigationRoutes.editPost:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => EditPostPage.create(
                postModel: settings.arguments as PostModel)));
      case NavigationRoutes.editComment:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => EditCommentPage.create(
                commentModel: settings.arguments as CommentModel)));
    }
    return null;
  }
}
