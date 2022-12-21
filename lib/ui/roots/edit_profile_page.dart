import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';

import '../../data/services/user_service.dart';
import '../../domain/models/user_model.dart';

class _ViewModelState {
  final UserModel? currentUserModel;
  final String? fullName;
  final String? biography;
  final bool isLoadingPage;
  final bool isUpdatingProfile;

  const _ViewModelState(
      {this.currentUserModel,
      this.fullName,
      this.biography,
      this.isLoadingPage = true,
      this.isUpdatingProfile = false});

  _ViewModelState copyWith({
    UserModel? currentUserModel,
    String? fullName,
    String? biography,
    bool? isLoadingPage,
    bool? isUpdatingProfile,
  }) {
    return _ViewModelState(
      currentUserModel: currentUserModel ?? this.currentUserModel,
      fullName: fullName ?? this.fullName,
      biography: biography ?? this.biography,
      isLoadingPage: isLoadingPage ?? this.isLoadingPage,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final TextEditingController fullNameConroller = TextEditingController();
  final TextEditingController biographyConroller = TextEditingController();

  _ViewModel() {
    fullNameConroller.addListener(() {
      state = state.copyWith(fullName: fullNameConroller.text);
    });

    biographyConroller.addListener(() {
      state = state.copyWith(biography: biographyConroller.text);
    });

    asyncInit();
  }

  _ViewModelState _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  Future asyncInit() async {
    var currentUserId = await SharedPrefs.getCurrentUserId();
    var userModel =
        await _userService.getUserByIdFromApi(userId: currentUserId!);
    if (userModel != null) {
      fullNameConroller.text = userModel.fullName;
      biographyConroller.text = userModel.biography;
    }

    state = state.copyWith(
        currentUserModel: userModel,
        biography: userModel?.biography,
        fullName: userModel?.fullName,
        isLoadingPage: false);
  }

  void updateProfile() async {
    state = state.copyWith(isUpdatingProfile: true);
    await _userService.updateProfile(
        biography: state.biography, fullName: state.fullName);
    AppNavigator.popPage();
    state = state.copyWith(isUpdatingProfile: false);
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
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
                          onPressed: () {},
                          child: const Text(
                            "Изменить фото",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                    TextField(
                      controller: viewModel.fullNameConroller,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(labelText: 'Имя'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: viewModel.biographyConroller,
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
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(),
      child: const EditProfilePage(),
    );
  }
}
