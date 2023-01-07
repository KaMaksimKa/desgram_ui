import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/models/user/user_model.dart';
import '../../app_navigator.dart';

class EditProfileViewModelState {
  final UserModel? currentUserModel;
  final String? fullName;
  final String? biography;
  final bool isLoadingPage;
  final bool isUpdatingProfile;

  const EditProfileViewModelState(
      {this.currentUserModel,
      this.fullName,
      this.biography,
      this.isLoadingPage = true,
      this.isUpdatingProfile = false});

  EditProfileViewModelState copyWith({
    UserModel? currentUserModel,
    String? fullName,
    String? biography,
    bool? isLoadingPage,
    bool? isUpdatingProfile,
  }) {
    return EditProfileViewModelState(
      currentUserModel: currentUserModel ?? this.currentUserModel,
      fullName: fullName ?? this.fullName,
      biography: biography ?? this.biography,
      isLoadingPage: isLoadingPage ?? this.isLoadingPage,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
    );
  }
}

class EditProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController biographyController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final BuildContext context;
  UserModel? user;

  EditProfileViewModel({required this.context}) {
    fullNameController.addListener(() {
      state = state.copyWith(fullName: fullNameController.text);
    });

    biographyController.addListener(() {
      state = state.copyWith(biography: biographyController.text);
    });

    asyncInit();
  }

  EditProfileViewModelState _state = const EditProfileViewModelState();
  EditProfileViewModelState get state => _state;
  set state(EditProfileViewModelState val) {
    _state = val;
    notifyListeners();
  }

  Future asyncInit() async {
    var currentUserId = await _userService.getCurrentUserId();
    try {
      var userModel =
          await _userService.getUserByIdFromApi(userId: currentUserId!);
      user = userModel;
      if (userModel != null) {
        fullNameController.text = userModel.fullName;
        biographyController.text = userModel.biography;
        userNameController.text = userModel.name;
      }

      state = state.copyWith(
          currentUserModel: userModel,
          biography: userModel?.biography,
          fullName: userModel?.fullName,
          isLoadingPage: false);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    }
  }

  void updateProfile() async {
    state = state.copyWith(isUpdatingProfile: true);
    try {
      await _userService.updateProfile(
          biography: state.biography, fullName: state.fullName);
      AppNavigator.popPage();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state = state.copyWith(isUpdatingProfile: false);
    }
  }
}
