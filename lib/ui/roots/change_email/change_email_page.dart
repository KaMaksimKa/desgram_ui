import 'package:desgram_ui/domain/models/user/personal_information_model.dart';
import 'package:desgram_ui/ui/roots/change_email/change_email_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChangeEmailViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Изменить электронный адрес"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                children: [
                  TextField(
                    enableSuggestions: false,
                    controller: viewModel.emailController,
                    autocorrect: false,
                    onSubmitted: (value) {
                      viewModel.tryChange();
                    },
                    style: const TextStyle(fontSize: 19),
                    decoration: InputDecoration(
                        errorText: viewModel.emailError,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: "Эл. адрес",
                        hintStyle:
                            const TextStyle(fontSize: 19, color: Colors.grey)),
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
                        viewModel.canTryChange() ? viewModel.tryChange : null,
                    child: const Text(
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
    );
  }

  static Widget create(PersonalInformationModel model) {
    return ChangeNotifierProvider(
      create: (context) => ChangeEmailViewModel(model, context: context),
      child: const ChangeEmailPage(),
    );
  }
}
