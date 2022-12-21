import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/models/email_code_model.dart';
import 'package:desgram_ui/domain/models/try_create_user_model.dart';

import '../../domain/exceptions/bad_request_exception.dart';
import '../app_navigator.dart';

class _ViewModelState {
  final String? codeId;
  final String? code;
  final String? codeError;
  final bool isLoading;

  const _ViewModelState(
      {this.code, this.codeId, this.isLoading = false, this.codeError});

  _ViewModelState copyWith({
    String? codeId,
    String? code,
    String? codeError,
    bool? isLoading,
  }) {
    return _ViewModelState(
      codeId: codeId ?? this.codeId,
      code: code ?? this.code,
      codeError: codeError ?? this.codeError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final BuildContext context;
  final TryCreateUserModel tryCreateUserModel;

  TextEditingController codeController = TextEditingController();

  _ViewModelState _state = const _ViewModelState();

  _ViewModelState get state => _state;

  set state(_ViewModelState value) {
    _state = value;
    notifyListeners();
  }

  _ViewModel({required this.context, required this.tryCreateUserModel}) {
    sendSingUpCode();

    codeController.addListener(() {
      state = state.copyWith(code: codeController.text);
    });
  }

  bool checkFields() {
    return state.code?.isEmpty == false;
  }

  void sendSingUpCode() async {
    state = state.copyWith(
        codeId: await _userService.sendSingUpCode(tryCreateUserModel.email));
  }

  void createUser() async {
    var emailCodeId = state.codeId;
    var confirmCode = state.code;
    if (emailCodeId != null && confirmCode != null) {
      state = state.copyWith(isLoading: true);
      try {
        await _userService
            .createUser(
                tryCreateUserModel: tryCreateUserModel,
                emailCodeModel:
                    EmailCodeModel(id: emailCodeId, code: confirmCode))
            .then((value) => state = state.copyWith(isLoading: false));
        AppNavigator.toAuth(isRemoveUntil: true);
      } on BadRequestException catch (e) {
        String? confirmCodeError;
        if (e.errors.containsKey("Code")) {
          confirmCodeError = e.errors["Code"]![0];
        }

        state = state.copyWith(codeError: confirmCodeError, isLoading: false);
      }
    }
  }
}

class ConfirmUser extends StatelessWidget {
  final String email;

  const ConfirmUser({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Column(
                    children: [
                      const Text(
                        "Введите код подтверждения",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Введите код подтверждения, который мы отправили на электронный адрес $email.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: viewModel.codeController,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                            errorText: viewModel.state.codeError,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: "######",
                            hintStyle: const TextStyle(
                                fontSize: 19, color: Colors.grey)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: viewModel.checkFields()
                            ? viewModel.createUser
                            : null,
                        child: const Text(
                          'Подтвердить',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Назад"),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: viewModel.sendSingUpCode,
                              child: const Text("Запросить новый код"),
                            ),
                          ])
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Есть аккаунт?",
                      style:
                          TextStyle(color: Color.fromARGB(255, 112, 109, 109)),
                    ),
                    TextButton(
                        onPressed: AppNavigator.toAuth, child: Text("Вход."))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create(TryCreateUserModel tryCreateUserModel) {
    return ChangeNotifierProvider<_ViewModel>(
      create: (context) =>
          _ViewModel(context: context, tryCreateUserModel: tryCreateUserModel),
      child: ConfirmUser(
        email: tryCreateUserModel.email,
      ),
    );
  }
}
