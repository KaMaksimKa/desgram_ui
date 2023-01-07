import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/change_password/change_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_navigator.dart';

class ChangePasswordWidget extends StatelessWidget {
  const ChangePasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChangePasswordViewModel>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("Изменить пароль"),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    children: [
                      TextField(
                        readOnly: viewModel.state.isLoading,
                        controller: viewModel.oldPasswordConroller,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            errorMaxLines: 3,
                            errorText: viewModel.state.oldPasswordError,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: "Текучий пароль",
                            hintStyle: const TextStyle(
                                fontSize: 19, color: Colors.grey)),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: viewModel.state.isLoading,
                        controller: viewModel.newPasswordConroller,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            errorText: viewModel.state.newPasswordError,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: "Новый пароль",
                            hintStyle: const TextStyle(
                                fontSize: 19, color: Colors.grey)),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: viewModel.state.isLoading,
                        controller: viewModel.retryNewPasswordConroller,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            errorText: viewModel.state.retryNewPasswordError,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: "Новый пароль еще раз",
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
                                ? viewModel.chagnePassword
                                : null,
                        child: viewModel.state.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Изменить',
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  static Widget create({required MainPageNavigator mainPageNavigator}) {
    return ChangeNotifierProvider<ChangePasswordViewModel>(
      create: (context) => ChangePasswordViewModel(
          mainPageNavigator: mainPageNavigator, context: context),
      child: const ChangePasswordWidget(),
    );
  }
}
