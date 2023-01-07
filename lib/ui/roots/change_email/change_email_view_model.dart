import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/domain/models/user/personal_information_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/exceptions/bad_request_exception.dart';

class ChangeEmailViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  final PersonalInformationModel _personalInformationModel;
  final UserService _userService = UserService();
  final BuildContext context;

  ChangeEmailViewModel(this._personalInformationModel,
      {required this.context}) {
    emailController.addListener(() {
      notifyListeners();
    });
    emailController.text = _personalInformationModel.email;
  }

  Future tryChange() async {
    if (canTryChange()) {
      try {
        emailError = null;
        var newEmail = emailController.text;
        await _userService.tryChangeEmail(email: newEmail);
        AppNavigator.toConfirmEmail(newEmail: newEmail);
      } on BadRequestException catch (e) {
        if (e.errors.containsKey("newEmail")) {
          emailError = e.errors["newEmail"]![0];
        }
      } on NoNetworkException {
        showNoNetworkDialog(context: context);
      } finally {
        notifyListeners();
      }
    }
  }

  bool canTryChange() {
    return emailController.text.isNotEmpty;
  }
}
