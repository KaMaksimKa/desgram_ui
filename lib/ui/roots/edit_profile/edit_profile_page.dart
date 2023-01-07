import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/modal_bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';

import 'edit_profile_view_model.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Редактировать пр..."),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        actions: [
          viewModel.state.isUpdatingProfile
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
                  onPressed: viewModel.updateProfile,
                  icon: const Icon(Icons.check))
        ],
        leading: IconButton(
            iconSize: 35,
            onPressed:
                viewModel.state.isUpdatingProfile ? null : AppNavigator.popPage,
            icon: const Icon(Icons.close)),
      ),
      body: viewModel.state.isLoadingPage
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: [
                    Center(
                        child: ImageUserAvatar(
                      imageContentModel:
                          viewModel.state.currentUserModel?.avatar,
                      size: 100,
                    )),
                    Center(
                      child: TextButton(
                          onPressed: () => ModalBottomSheets.showEditAvatar(
                              context: context),
                          child: const Text(
                            "Изменить фото",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    TextField(
                      controller: viewModel.userNameController,
                      style: const TextStyle(fontSize: 20),
                      onTap: () async {
                        var user = viewModel.user;
                        if (user != null) {
                          await AppNavigator.toChangeUserName(
                              oldUserName: user.name);
                          viewModel.asyncInit();
                        }
                      },
                      readOnly: true,
                      decoration:
                          const InputDecoration(labelText: 'Имя пользователя'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: viewModel.fullNameController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(labelText: 'Имя'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: viewModel.biographyController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(labelText: 'Биография'),
                    ),
                  ]),
                ),
                const Divider(
                  height: 7,
                  thickness: 1,
                  color: Colors.grey,
                ),
                const TextButton(
                    onPressed: AppNavigator.toEditPersonalInformationPage,
                    child: Text(
                      "Настройки личной информации",
                      style: TextStyle(fontSize: 18),
                    )),
                const Divider(
                  height: 7,
                  thickness: 1,
                  color: Colors.grey,
                )
              ]),
            ),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider<EditProfileViewModel>(
      create: (context) => EditProfileViewModel(context: context),
      child: const EditProfilePage(),
    );
  }
}
