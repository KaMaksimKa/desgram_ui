import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/domain/models/user/try_create_user_model.dart';

import '../../app_navigator.dart';
import 'confirm_user_view_model.dart';

class ConfirmUserPage extends StatelessWidget {
  final String email;

  const ConfirmUserPage({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ConfirmUserViewModel>();

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
                      const Text(
                        "Введите код подтверждения",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Введите код подтверждения, который мы отправили на электронный адрес $email.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: viewModel.codeController,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            errorText: viewModel.state.codeError,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: "######",
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
                        onPressed: viewModel.checkFields()
                            ? viewModel.createUser
                            : null,
                        child: const Text(
                          'Подтвердить',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Назад"),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: viewModel.sendSingUpCode,
                              child: const Text("Запросить новый код"),
                            ),
                          ])
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 112, 109, 109)),
                    ),
                    TextButton(
                        onPressed: AppNavigator.toAuth, child: Text("Вход."))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create(TryCreateUserModel tryCreateUserModel) {
    return ChangeNotifierProvider<ConfirmUserViewModel>(
      create: (context) => ConfirmUserViewModel(
          context: context, tryCreateUserModel: tryCreateUserModel),
      child: ConfirmUserPage(
        email: tryCreateUserModel.email,
      ),
    );
  }
}
