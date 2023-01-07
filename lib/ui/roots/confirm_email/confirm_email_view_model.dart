import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/exceptions/bad_request_exception.dart';
import '../../../domain/models/user/email_code_model.dart';

class ConfirmEmailViewModelState {
  final String? codeId;
  final String? code;
  final String? codeError;
  final bool isLoading;

  const ConfirmEmailViewModelState(
      {this.code, this.codeId, this.isLoading = false, this.codeError});

  ConfirmEmailViewModelState copyWith({
    String? codeId,
    String? code,
    String? codeError,
    bool? isLoading,
  }) {
    return ConfirmEmailViewModelState(
      codeId: codeId ?? this.codeId,
      code: code ?? this.code,
      codeError: codeError ?? this.codeError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConfirmEmailViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final BuildContext context;
  final String newEmail;

  TextEditingController codeController = TextEditingController();

  ConfirmEmailViewModelState _state = const ConfirmEmailViewModelState();

  ConfirmEmailViewModelState get state => _state;

  set state(ConfirmEmailViewModelState value) {
    _state = value;
    notifyListeners();
  }

  ConfirmEmailViewModel({required this.context, required this.newEmail}) {
    sendChangeEmailCode();

    codeController.addListener(() {
      state = state.copyWith(code: codeController.text);
    });
  }

  bool checkFields() {
    return state.code?.isEmpty == false;
  }

  void sendChangeEmailCode() async {
    try {
      state = state.copyWith(
          codeId: await _userService.sendChangeEmailCode(newEmail: newEmail));
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    }
  }

  void changeEmail() async {
    var emailCodeId = state.codeId;
    var confirmCode = state.code;
    if (emailCodeId != null && confirmCode != null) {
      state = state.copyWith(isLoading: true);
      try {
        await _userService
            .changeEmail(
                newEmail: newEmail,
                emailCodeModel:
                    EmailCodeModel(id: emailCodeId, code: confirmCode))
            .then((value) => state = state.copyWith(isLoading: false));
        AppNavigator.popPage();
        AppNavigator.toEditPersonalInformationPage();
      } on BadRequestException catch (e) {
        String? confirmCodeError;
        if (e.errors.containsKey("Code")) {
          confirmCodeError = e.errors["Code"]![0];
        }

        state = state.copyWith(codeError: confirmCodeError, isLoading: false);
      } on NoNetworkException {
        state = state.copyWith(isLoading: false);
        showNoNetworkDialog(context: context);
      }
    }
  }
}
