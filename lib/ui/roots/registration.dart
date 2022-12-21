import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/bad_request_exception.dart';
import 'package:desgram_ui/domain/models/try_create_user_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';

class _ViewModelState {
  final String? userName;
  final String? email;
  final String? password;
  final String? retryPassword;
  final bool isLoading;
  final String? userNameError;
  final String? emailError;
  final String? passwordError;
  final String? retryPasswordError;

  const _ViewModelState(
      {this.userName,
      this.email,
      this.password,
      this.retryPassword,
      this.isLoading = false,
      this.userNameError,
      this.emailError,
      this.passwordError,
      this.retryPasswordError});

  _ViewModelState copyWith({
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
    return _ViewModelState(
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

class _ViewModel extends ChangeNotifier {
  TextEditingController userNameConroller = TextEditingController();
  TextEditingController emailConroller = TextEditingController();
  TextEditingController passwordConroller = TextEditingController();
  TextEditingController retryPasswordConroller = TextEditingController();

  final BuildContext context;
  final UserService _userService = UserService();
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
      }
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
                      readOnly: viewModel.state.isLoading,
                      controller: viewModel.userNameConroller,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          errorText: viewModel.state.userNameError,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Имя пользователя",
                          hintStyle: const TextStyle(
                              fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      readOnly: viewModel.state.isLoading,
                      controller: viewModel.emailConroller,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: InputDecoration(
                          errorText: viewModel.state.emailError,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Эл. адрес",
                          hintStyle: const TextStyle(
                              fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      readOnly: viewModel.state.isLoading,
                      controller: viewModel.passwordConroller,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: InputDecoration(
                          errorText: viewModel.state.passwordError,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Пароль",
                          hintStyle: const TextStyle(
                              fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      readOnly: viewModel.state.isLoading,
                      controller: viewModel.retryPasswordConroller,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(fontSize: 19),
                      decoration: InputDecoration(
                          errorText: viewModel.state.retryPasswordError,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          hintText: "Пароль ещё раз",
                          hintStyle: const TextStyle(
                              fontSize: 19, color: Colors.grey)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: viewModel.state.isLoading
                          ? null
                          : viewModel.checkFields()
                              ? viewModel.tryCreateUser
                              : null,
                      child: viewModel.state.isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
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
