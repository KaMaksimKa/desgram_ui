import 'dart:io';

import 'package:desgram_ui/data/services/attach_service.dart';
import 'package:desgram_ui/data/services/user_service.dart';
import 'package:flutter/cupertino.dart';

class ChooseNewAvatarViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final AttachService _attachService = AttachService();

  Future uploadNewAvatar({required File file}) async {
    var metadataModel = await _attachService.uploadFile(file: file);
    if (metadataModel != null) {
      await _userService.addAvatar(metadataModel: metadataModel);
    }
  }
}
