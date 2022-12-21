import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/ui/app_navigator.dart';

import '../../data/services/user_service.dart';
import '../../utils/helpers/date_time_helper.dart';

class _ViewModelState {
  final DateTime? newBirthDate;
  final bool isUpdatingBirthday;

  const _ViewModelState({
    this.newBirthDate,
    this.isUpdatingBirthday = false,
  });

  _ViewModelState copyWith({
    DateTime? newBirthDate,
    bool? isUpdatingBirthday,
  }) {
    return _ViewModelState(
      newBirthDate: newBirthDate ?? this.newBirthDate,
      isUpdatingBirthday: isUpdatingBirthday ?? this.isUpdatingBirthday,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final TextEditingController birthDateContorller = TextEditingController();

  final DateTime? oldBirthDate;
  final BuildContext context;

  _ViewModel({
    required this.context,
    required this.oldBirthDate,
  }) {
    state = state.copyWith(newBirthDate: oldBirthDate);
  }

  _ViewModelState _state = const _ViewModelState();

  _ViewModelState get state => _state;

  set state(_ViewModelState val) {
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

    await _userService.updateBirthday(birthday: state.newBirthDate?.toUtc());

    state.copyWith(isUpdatingBirthday: false);
    AppNavigator.popPage();
  }
}

class EditBirthDatePage extends StatelessWidget {
  const EditBirthDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
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
          _ViewModel(context: context, oldBirthDate: oldBirthDate),
      child: const EditBirthDatePage(),
    );
  }
}
