import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/exceptions/bad_request_exception.dart';
import '../../../domain/models/user/email_code_model.dart';
import '../../../domain/models/user/try_create_user_model.dart';
import '../../app_navigator.dart';

class ConfirmUserViewModelState {
  final String? codeId;
  final String? code;
  final String? codeError;
  final bool isLoading;

  const ConfirmUserViewModelState(
      {this.code, this.codeId, this.isLoading = false, this.codeError});

  ConfirmUserViewModelState copyWith({
    String? codeId,
    String? code,
    String? codeError,
    bool? isLoading,
  }) {
    return ConfirmUserViewModelState(
      codeId: codeId ?? this.codeId,
      code: code ?? this.code,
      codeError: codeError ?? this.codeError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConfirmUserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final BuildContext context;
  final TryCreateUserModel tryCreateUserModel;

  TextEditingController codeController = TextEditingController();

  ConfirmUserViewModelState _state = const ConfirmUserViewModelState();

  ConfirmUserViewModelState get state => _state;

  set state(ConfirmUserViewModelState value) {
    _state = value;
    notifyListeners();
  }

  ConfirmUserViewModel(
      {required this.context, required this.tryCreateUserModel}) {
    sendSingUpCode();

    codeController.addListener(() {
      state = state.copyWith(code: codeController.text);
    });
  }

  bool checkFields() {
    return state.code?.isEmpty == false;
  }

  void sendSingUpCode() async {
    try {
      state = state.copyWith(
          codeId: await _userService.sendSingUpCode(tryCreateUserModel.email));
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    }
  }

  void createUser() async {
    var emailCodeId = state.codeId;
    var confirmCode = state.code;
    if (emailCodeId != null && confirmCode != null) {
      state = state.copyWith(isLoading: true);
      try {
        await _userService
            .createUser(
                tryCreateUserModel: tryCreateUserModel,
                emailCodeModel:
                    EmailCodeModel(id: emailCodeId, code: confirmCode))
            .then((value) => state = state.copyWith(isLoading: false));
        AppNavigator.toAuth(isRemoveUntil: true);
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
