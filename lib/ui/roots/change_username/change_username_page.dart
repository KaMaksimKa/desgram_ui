import 'package:desgram_ui/ui/roots/change_username/change_username_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeUserNamePage extends StatelessWidget {
  const ChangeUserNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChangeUserNameViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Изменить имя пользователя"),
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
                    controller: viewModel.userNameController,
                    autocorrect: false,
                    onSubmitted: (value) {
                      viewModel.tryChange();
                    },
                    style: const TextStyle(fontSize: 19),
                    decoration: InputDecoration(
                        errorText: viewModel.userNameError,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: "Имя пользователя",
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

  static Widget create({required String oldUserName}) {
    return ChangeNotifierProvider(
      create: (context) =>
          ChangeUserNameViewModel(context: context, userName: oldUserName),
      child: const ChangeUserNamePage(),
    );
  }
}
