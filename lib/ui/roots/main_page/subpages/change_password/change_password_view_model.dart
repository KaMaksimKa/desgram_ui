import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../../data/services/user_service.dart';
import '../../../../../domain/exceptions/bad_request_exception.dart';
import '../../../../common/something_went_wrong_dialog.dart';

class ChangePasswordViewModelState {
  final String? oldPassword;
  final String? newPassword;
  final String? retryNewPassword;
  final bool isLoading;
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? retryNewPasswordError;

  const ChangePasswordViewModelState({
    this.newPassword,
    this.newPasswordError,
    this.oldPassword,
    this.oldPasswordError,
    this.isLoading = false,
    this.retryNewPassword,
    this.retryNewPasswordError,
  });

  ChangePasswordViewModelState copyWith({
    String? oldPassword,
    String? newPassword,
    String? retryNewPassword,
    bool? isLoading,
    String? oldPasswordError,
    String? newPasswordError,
    String? retryNewPasswordError,
  }) {
    return ChangePasswordViewModelState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      retryNewPassword: retryNewPassword ?? this.retryNewPassword,
      isLoading: isLoading ?? this.isLoading,
      oldPasswordError: oldPasswordError,
      newPasswordError: newPasswordError,
      retryNewPasswordError: retryNewPasswordError,
    );
  }
}

class ChangePasswordViewModel extends SubpageViewModel {
  TextEditingController oldPasswordConroller = TextEditingController();
  TextEditingController newPasswordConroller = TextEditingController();
  TextEditingController retryNewPasswordConroller = TextEditingController();

  final UserService _userService = UserService();
  ChangePasswordViewModelState _state = const ChangePasswordViewModelState();

  ChangePasswordViewModelState get state => _state;
  set state(ChangePasswordViewModelState value) {
    _state = value;
    notifyListeners();
  }

  ChangePasswordViewModel(
      {required super.context, required super.mainPageNavigator}) {
    oldPasswordConroller.addListener(() {
      state = state.copyWith(oldPassword: oldPasswordConroller.text);
    });

    newPasswordConroller.addListener(() {
      state = state.copyWith(newPassword: newPasswordConroller.text);
    });

    retryNewPasswordConroller.addListener(() {
      state = state.copyWith(retryNewPassword: retryNewPasswordConroller.text);
    });
  }

  bool checkFields() {
    return state.oldPassword?.isEmpty == false &&
        state.newPassword?.isEmpty == false &&
        state.retryNewPassword?.isEmpty == false;
  }

  void chagnePassword() async {
    var oldPassword = state.oldPassword;
    var newPassword = state.newPassword;
    var retryNewPassword = state.retryNewPassword;
    if (oldPassword != null &&
        newPassword != null &&
        retryNewPassword != null) {
      state = state.copyWith(isLoading: true);
      try {
        await _userService
            .chagePassword(
                newPassword: newPassword,
                oldPassword: oldPassword,
                retryNewPassword: retryNewPassword)
            .then((value) => state = state.copyWith(isLoading: false));

        AppNavigator.popPage();
      } on BadRequestException catch (e) {
        String? oldPasswordError;
        String? newPasswordError;
        String? retryNewPasswordError;
        if (e.errors.containsKey("OldPassword")) {
          oldPasswordError = e.errors["OldPassword"]![0];
        }
        if (e.errors.containsKey("NewPassword")) {
          newPasswordError = e.errors["NewPassword"]![0];
        }
        if (e.errors.containsKey("RetryNewPassword")) {
          retryNewPasswordError = e.errors["RetryNewPassword"]![0];
        }

        state = state.copyWith(
            oldPasswordError: oldPasswordError,
            newPasswordError: newPasswordError,
            retryNewPasswordError: retryNewPasswordError,
            isLoading: false);
      } on NoNetworkException {
        state = state.copyWith(isLoading: false);
        showNoNetworkDialog(context: context);
      } catch (e) {
        state = state.copyWith(isLoading: false);
        showSomethingWentWrong(context: context);
      }
    }
  }
}
