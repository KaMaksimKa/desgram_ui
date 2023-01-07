import 'package:desgram_ui/ui/roots/registration/registration_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_navigator.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<RegistrationViewModel>();

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
    return ChangeNotifierProvider<RegistrationViewModel>(
      create: (context) => RegistrationViewModel(context: context),
      child: const RegistrationPage(),
    );
  }
}
