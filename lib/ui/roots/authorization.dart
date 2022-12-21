import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../../domain/exceptions/exceptions.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;

  const _ViewModelState({this.isLoading = false, this.login, this.password});

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  TextEditingController loginConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();
  final _authService = AuthService();

  final BuildContext context;

  _ViewModelState _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState value) {
    _state = value;
    notifyListeners();
  }

  _ViewModel({required this.context}) {
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

class Authorization extends StatelessWidget {
  const Authorization({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Desgram",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Rock Salt"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    enabled: !viewModel.state.isLoading,
                    controller: viewModel.loginConroller,
                    autocorrect: false,
                    style: const TextStyle(fontSize: 19),
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: "Имя или эл. адрес",
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey)),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enabled: !viewModel.state.isLoading,
                    controller: viewModel.passwordConroller,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: const TextStyle(fontSize: 19),
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: "Пароль",
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed:
                        viewModel.checkFields() && !viewModel.state.isLoading
                            ? viewModel.login
                            : null,
                    child: viewModel.state.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Вход',
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "У вас ещё нет аккаунта?",
                  style: TextStyle(color: Color.fromARGB(255, 112, 109, 109)),
                ),
                TextButton(
                    onPressed: AppNavigator.toRegistr,
                    child: Text("Зарегистрируйтесь."))
              ],
            )
          ],
        )),
      ),
    ));
  }

  static Widget create() {
    return ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const Authorization(),
    );
  }
}
