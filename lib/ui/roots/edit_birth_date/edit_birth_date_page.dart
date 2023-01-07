import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_navigator.dart';

import 'edit_birth_date_view_model.dart';

class EditBirthDatePage extends StatelessWidget {
  const EditBirthDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditBirthDateViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("День рождения"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        actions: [
          viewModel.state.isUpdatingBirthday
              ? Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 35,
                  child: const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  color: Colors.blue,
                  iconSize: 35,
                  onPressed: viewModel.updateBirthDate,
                  icon: const Icon(Icons.check))
        ],
        leading: IconButton(
            iconSize: 35,
            onPressed: viewModel.state.isUpdatingBirthday
                ? null
                : AppNavigator.popPage,
            icon: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            TextField(
              onTap: viewModel.chooseBirthDate,
              readOnly: true,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              controller: viewModel.birthDateContorller,
              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  hintText: "День рождения"),
            )
          ]),
        ),
      ),
    );
  }

  static Widget create(DateTime? oldBirthDate) {
    return ChangeNotifierProvider(
      create: (context) =>
          EditBirthDateViewModel(context: context, oldBirthDate: oldBirthDate),
      child: const EditBirthDatePage(),
    );
  }
}
