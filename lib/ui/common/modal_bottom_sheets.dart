import 'package:desgram_ui/data/services/attach_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:desgram_ui/domain/exceptions/exceptions.dart';
import 'package:desgram_ui/inrernal/config/shared_prefs.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';
import 'package:desgram_ui/ui/common/no_network_dialog.dart';
import 'package:flutter/material.dart';

class ModalBottomSheets {
  static final AttachService _attachService = AttachService();
  static final UserService _userService = UserService();

  static Future showEditAvatar({required BuildContext context}) async {
    final userService = UserService();
    var currentUserId = await SharedPrefs.getCurrentUserId();
    if (currentUserId == null) {
      return;
    }
    var currentUser =
        await userService.getUserByIdFromDb(userId: currentUserId);

    if (currentUser == null) {
      return;
    }

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 4,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 67, 67, 67),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageUserAvatar(
                      imageContentModel: currentUser.avatar, size: 50)
                ],
              ),
              const Divider(
                height: 20,
                color: Colors.grey,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _uploadNewAvatar();
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.image_outlined,
                                size: 30,
                              )),
                          Expanded(
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "Новое фото профиля",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                        ],
                      )),
                  if (currentUser.avatar != null)
                    TextButton(
                        onPressed: _deleteAvatar,
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 30,
                                )),
                            Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "Удалить текущее фото",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ))
                          ],
                        ))
                ]),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          );
        });
  }

  static Future _uploadNewAvatar() async {
    var newAvatar = await AppNavigator.toChooseImagePage();
    if (newAvatar == null) {
      return;
    }
    _showLoadingIndicator();
    try {
      var metadataModel = await _attachService.uploadFile(file: newAvatar);
      if (metadataModel != null) {
        await _userService.addAvatar(metadataModel: metadataModel);
      }
    } on NoNetworkException {
      showNoNetworkDialog(context: AppNavigator.key.currentContext!);
    } finally {
      AppNavigator.popPage();
    }
  }

  static Future _deleteAvatar() async {
    _showLoadingIndicator();
    try {
      await _userService.deleteAvatar();
    } on NoNetworkException {
      showNoNetworkDialog(context: AppNavigator.key.currentContext!);
    } finally {
      AppNavigator.popPage();
    }
  }

  static Future _showLoadingIndicator() async {
    showDialog(
        barrierDismissible: false,
        context: AppNavigator.key.currentState!.context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Загрузка",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
              ),
            ));
  }
}
