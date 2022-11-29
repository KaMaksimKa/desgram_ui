import 'package:flutter/material.dart';

import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? userName;
  final String? email;
  final String? password;
  final String? retryPassword;

  const _ViewModelState({
    this.userName,
    this.email,
    this.password,
    this.retryPassword,
  });

  _ViewModelState copyWith({
    String? userName,
    String? email,
    String? password,
    String? retryPassword,
  }) {
    return _ViewModelState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  TextEditingController userNameConroller = TextEditingController();
  TextEditingController emailConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();
  TextEditingController retryPasswordConroller = TextEditingController();

  final BuildContext context;

  _ViewModelState _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState value) {
    _state = value;
    notifyListeners();
  }

  _ViewModel({required this.context}) {
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

  void confirmUser() {
    if (state.email != null) {
      AppNavigator.toConfirmUser(state.email!);
    }
  }
}

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Зарегистрируйтесь, чтобы смотреть фото и видео ваших друзей.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(255, 146, 146, 146)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: viewModel.userNameConroller,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Эл. адрес",
                          hintStyle:
                              TextStyle(fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: viewModel.emailConroller,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Имя пользователя",
                          hintStyle:
                              TextStyle(fontSize: 19, color: Colors.grey)),
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
                          hintStyle:
                              TextStyle(fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: viewModel.retryPasswordConroller,
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
                          hintText: "Пароль ещё раз",
                          hintStyle:
                              TextStyle(fontSize: 19, color: Colors.grey)),
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
                      onPressed: viewModel.checkFields()
                          ? viewModel.confirmUser
                          : null,
                      child: const Text(
                        'Далее',
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
                    "Есть аккаунт?",
                    style: TextStyle(color: Color.fromARGB(255, 112, 109, 109)),
                  ),
                  TextButton(
                      onPressed: AppNavigator.toAuth, child: Text("Вход."))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  static Widget create() {
    return ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const Registration(),
    );
  }
}
