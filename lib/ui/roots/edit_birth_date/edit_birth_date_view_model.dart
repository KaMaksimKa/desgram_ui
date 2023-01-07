import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

import '../../../data/services/user_service.dart';
import '../../../utils/helpers/date_time_helper.dart';
import '../../app_navigator.dart';

class EditBirthDateViewModelState {
  final DateTime? newBirthDate;
  final bool isUpdatingBirthday;

  const EditBirthDateViewModelState({
    this.newBirthDate,
    this.isUpdatingBirthday = false,
  });

  EditBirthDateViewModelState copyWith({
    DateTime? newBirthDate,
    bool? isUpdatingBirthday,
  }) {
    return EditBirthDateViewModelState(
      newBirthDate: newBirthDate ?? this.newBirthDate,
      isUpdatingBirthday: isUpdatingBirthday ?? this.isUpdatingBirthday,
    );
  }
}

class EditBirthDateViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final TextEditingController birthDateContorller = TextEditingController();

  final DateTime? oldBirthDate;
  final BuildContext context;

  EditBirthDateViewModel({
    required this.context,
    required this.oldBirthDate,
  }) {
    state = state.copyWith(newBirthDate: oldBirthDate);
  }

  EditBirthDateViewModelState _state = const EditBirthDateViewModelState();

  EditBirthDateViewModelState get state => _state;

  set state(EditBirthDateViewModelState val) {
    _state = val;
    if (val.newBirthDate != null) {
      birthDateContorller.text =
          DateTimeHelper.convertDateToRusFormat(val.newBirthDate!);
    }
    notifyListeners();
  }

  void chooseBirthDate() {
    showDatePicker(
            context: context,
            initialDate: state.newBirthDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      state = state.copyWith(newBirthDate: pickedDate);
    });
  }

  void updateBirthDate() async {
    state = state.copyWith(isUpdatingBirthday: true);
    try {
      await _userService.updateBirthday(birthday: state.newBirthDate?.toUtc());
      AppNavigator.popPage();
    } on NoNetworkException {
      showNoNetworkDialog(context: context);
    } finally {
      state.copyWith(isUpdatingBirthday: false);
    }
  }
}
