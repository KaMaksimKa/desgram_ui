import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../domain/models/user/personal_information_model.dart';
import '../../../utils/helpers/date_time_helper.dart';
import '../../app_navigator.dart';

class EditPersonalInformationViewModel extends ChangeNotifier {
  PersonalInformationModel? _personalInformationModel;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final BuildContext context;

  PersonalInformationModel? get personalInformationModel =>
      _personalInformationModel;

  set personalInformationModel(PersonalInformationModel? val) {
    _personalInformationModel = val;
    emailController.text = val?.email ?? "";
    birthDateController.text = val?.birthDate == null
        ? ""
        : DateTimeHelper.convertDateToRusFormat(val!.birthDate!);
    notifyListeners();
  }

  final UserService _userService = UserService();
  EditPersonalInformationViewModel({required this.context}) {
    asyncInit();
  }

  Future asyncInit() async {
    try {
      personalInformationModel = await _userService.getPersonalInformation();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    }
  }

  void toEditBirthDate() {
    AppNavigator.toEditBirthDatePage(personalInformationModel?.birthDate)
        .then((value) => asyncInit());
  }
}
