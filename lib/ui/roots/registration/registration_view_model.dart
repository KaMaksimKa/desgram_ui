import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/exceptions/bad_request_exception.dart';
import '../../../domain/models/user/try_create_user_model.dart';
import '../../app_navigator.dart';

class RegistrationViewModelState {
  final String? userName;
  final String? email;
  final String? password;
  final String? retryPassword;
  final bool isLoading;
  final String? userNameError;
  final String? emailError;
  final String? passwordError;
  final String? retryPasswordError;

  const RegistrationViewModelState(
      {this.userName,
      this.email,
      this.password,
      this.retryPassword,
      this.isLoading = false,
      this.userNameError,
      this.emailError,
      this.passwordError,
      this.retryPasswordError});

  RegistrationViewModelState copyWith({
    String? userName,
    String? email,
    String? password,
    String? retryPassword,
    bool? isLoading,
    String? userNameError,
    String? emailError,
    String? passwordError,
    String? retryPasswordError,
  }) {
    return RegistrationViewModelState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
      isLoading: isLoading ?? this.isLoading,
      userNameError: userNameError,
      emailError: emailError,
      passwordError: passwordError,
      retryPasswordError: retryPasswordError,
    );
  }
}

class RegistrationViewModel extends ChangeNotifier {
  TextEditingController userNameConroller = TextEditingController();
  TextEditingController emailConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();
  TextEditingController retryPasswordConroller = TextEditingController();

  final BuildContext context;
  final UserService _userService = UserService();
  RegistrationViewModelState _state = const RegistrationViewModelState();
  RegistrationViewModelState get state => _state;
  set state(RegistrationViewModelState value) {
    _state = value;
    notifyListeners();
  }

  RegistrationViewModel({required this.context}) {
    userNameConroller.addListener(() {
      state = state.copyWith(userName: userNameConroller.text);
    });

    emailConroller.addListener(() {
      state = state.copyWith(email: emailConroller.text);
    });

    passwordConroller.addListener(() {
      state = state.copyWith(password: passwordConroller.text);
    });

    retryPasswordConroller.addListener(() {
      state = state.copyWith(retryPassword: retryPasswordConroller.text);
    });
  }

  bool checkFields() {
    return state.userName?.isEmpty == false &&
        state.email?.isEmpty == false &&
        state.password?.isEmpty == false &&
        state.retryPassword?.isEmpty == false;
  }

  void tryCreateUser() async {
    var email = state.email;
    var userName = state.userName;
    var password = state.password;
    var retryPassword = state.retryPassword;
    if (email != null &&
        userName != null &&
        password != null &&
        retryPassword != null) {
      state = state.copyWith(isLoading: true);
      try {
        var tryCreateUserModel = TryCreateUserModel(
            userName: userName,
            email: email,
            password: password,
            retryPassword: retryPassword);
        await _userService
            .tryCreateUser(tryCreateUserModel)
            .then((value) => state = state.copyWith(isLoading: false));

        AppNavigator.toConfirmUser(tryCreateUserModel);
      } on BadRequestException catch (e) {
        String? userNameError;
        String? emailError;
        String? passwordError;
        String? retryPasswordError;
        if (e.errors.containsKey("UserName")) {
          userNameError = e.errors["UserName"]![0];
        }
        if (e.errors.containsKey("Email")) {
          emailError = e.errors["Email"]![0];
        }
        if (e.errors.containsKey("Password")) {
          passwordError = e.errors["Password"]![0];
        }
        if (e.errors.containsKey("RetryPassword")) {
          retryPasswordError = e.errors["RetryPassword"]![0];
        }
        state = state.copyWith(
            userNameError: userNameError,
            emailError: emailError,
            passwordError: passwordError,
            retryPasswordError: retryPasswordError,
            isLoading: false);
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      }
    }
  }
}
