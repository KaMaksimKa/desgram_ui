import 'package:desgram_ui/data/services/auth_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/models/user/user_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/subpage_view_model.dart';

import '../../../../common/something_went_wrong_dialog.dart';

class SettingsViewModel extends SubpageViewModel {
  UserModel? currentUser;
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  SettingsViewModel(
      {required super.context, required super.mainPageNavigator}) {
    UserService.updateUserListeners.add(onUpdateUser);
    asyncInit();
  }

  Future asyncInit() async {
    currentUser = await _userService.getCurrentUserFromDb();
    notifyListeners();
  }

  @override
  void dispose() {
    UserService.updateUserListeners.remove(onUpdateUser);
    super.dispose();
  }

  Future onUpdateUser({required UserModel userModel}) async {
    if (userModel.id == currentUser?.id) {
      currentUser = userModel;
      notifyListeners();
    }
  }

  Future makeAccountPrivate() async {
    try {
      await _userService.changeAccountAvailability(isPrivate: true);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future makeAccountOpen() async {
    try {
      await _userService.changeAccountAvailability(isPrivate: false);
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }

  Future logoutFromAllDevice() async {
    try {
      await _authService.logoutFromAllDevice();
      AppNavigator.toLoader();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } catch (e) {
      showSomethingWentWrong(context: context);
    }
  }
}
