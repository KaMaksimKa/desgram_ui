import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SettingsViewModel>();
    var currentUser = viewModel.currentUser;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.6),
          child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        title: const Text("Настройки"),
      ),
      body: currentUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                currentUser.isPrivate
                    ? TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          viewModel.makeAccountOpen();
                        },
                        icon: const Icon(
                          Icons.lock_open_outlined,
                          size: 30,
                        ),
                        label: const Text(
                          "Сделать аккаунт открытым",
                        ))
                    : TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(50),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          viewModel.makeAccountPrivate();
                        },
                        icon: const Icon(
                          Icons.lock_outline,
                          size: 30,
                        ),
                        label: const Text(
                          "Сделать аккаунт приватным",
                        )),
                TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      viewModel.mainPageNavigator.toChangePassword();
                    },
                    icon: const Icon(
                      Icons.key_outlined,
                      size: 30,
                    ),
                    label: const Text(
                      "Изменить пароль",
                    )),
                TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      viewModel.mainPageNavigator.toBlockedUsers();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 30,
                    ),
                    label: const Text(
                      "Заблокированные аккаунты",
                    )),
                TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size.fromHeight(50),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      viewModel.logoutFromAllDevice();
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    label: const Text(
                      "Выйти со всех устройств",
                    )),
              ]),
            )),
    );
  }

  static Widget create({required MainPageNavigator mainPageNavigator}) {
    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const SettingsWidget(),
    );
  }
}
