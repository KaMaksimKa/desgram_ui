import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';
import '../../../domain/exceptions/exceptions.dart';
import '../../app_navigator.dart';

class AuthorizationViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;

  const AuthorizationViewModelState(
      {this.isLoading = false, this.login, this.password});

  AuthorizationViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading,
  }) {
    return AuthorizationViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthorizationViewModel extends ChangeNotifier {
  TextEditingController loginConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();
  final _authService = AuthService();

  final BuildContext context;

  AuthorizationViewModelState _state = const AuthorizationViewModelState();
  AuthorizationViewModelState get state => _state;
  set state(AuthorizationViewModelState value) {
    _state = value;
    notifyListeners();
  }

  AuthorizationViewModel({required this.context}) {
    loginConroller.addListener(() {
      state = state.copyWith(login: loginConroller.text);
    });

    passwordConroller.addListener(() {
      state = state.copyWith(password: passwordConroller.text);
    });
  }

  bool checkFields() {
    return state.login?.isEmpty == false && state.password?.isEmpty == false;
  }

  void login() async {
    if (state.login != null && state.password != null) {
      state = state.copyWith(isLoading: true);
      try {
        await _authService.auth(state.login!, state.password!);
        AppNavigator.toLoader();
      } on NoNetworkException {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Ошибка",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              content: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Неизвестная ошибка сети.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 111, 111, 111)),
                ),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              actions: [
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      height: 0,
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Закрыть",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            );
          },
        );
      } on WrongLoginException {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Неверное имя пользователя",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              content: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "    Похоже, вы ввели имя пользователя, которое не принадлежит аккаунту. Проверьте свое имя пользователя и попробуйте ещё раз.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 111, 111, 111)),
                ),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              actions: [
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      height: 0,
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Повторить попытку",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            );
          },
        );
      } on WrongCredentionalException {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Неверный пароль",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              content: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "    Похоже, вы ввели неверный пароль. Проверьте свой пароль и попробуйте ещё раз.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 111, 111, 111)),
                ),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              actions: [
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      height: 0,
                    ),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Повторить попытку",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            );
          },
        );
      }
      state = state.copyWith(isLoading: false);
    }
  }
}
