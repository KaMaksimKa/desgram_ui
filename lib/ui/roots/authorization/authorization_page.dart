import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authorization_view_model.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AuthorizationViewModel>();

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
    return ChangeNotifierProvider<AuthorizationViewModel>(
      create: (context) => AuthorizationViewModel(context: context),
      child: const AuthorizationPage(),
    );
  }
}
