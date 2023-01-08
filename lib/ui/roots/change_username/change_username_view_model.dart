import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/exceptions/bad_request_exception.dart';
import '../../common/something_went_wrong_dialog.dart';

class ChangeUserNameViewModel extends ChangeNotifier {
  final String userName;
  final BuildContext context;
  final TextEditingController userNameController = TextEditingController();
  String? userNameError;
  final UserService _userService = UserService();

  ChangeUserNameViewModel({
    required this.userName,
    required this.context,
  }) {
    userNameController.addListener(() {
      notifyListeners();
    });
    userNameController.text = userName;
  }

  Future tryChange() async {
    if (canTryChange()) {
      try {
        userNameError = null;
        var newName = userNameController.text;
        await _userService.changeUserName(newName: newName);
        await _userService.updateUserInDb(
            userId: await _userService.getCurrentUserId());
        AppNavigator.popPage();
      } on BadRequestException catch (e) {
        if (e.errors.containsKey("NewName")) {
          userNameError = e.errors["NewName"]![0];
        }
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      } catch (e) {
        showSomethingWentWrong(context: context);
      } finally {
        notifyListeners();
      }
    }
  }

  bool canTryChange() {
    return userNameController.text.isNotEmpty;
  }
}
