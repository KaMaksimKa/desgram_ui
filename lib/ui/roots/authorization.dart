import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;

  const _ViewModelState({this.login, this.password});

  _ViewModelState copyWith({
    String? login,
    String? password,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  TextEditingController loginConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();

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

  void login() {}
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
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    onPressed: viewModel.checkFields() ? viewModel.login : null,
                    child: const Text(
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
