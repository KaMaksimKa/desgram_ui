import 'dart:io';

import 'package:flutter/material.dart';

import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/app_widgets/crop_image.dart';

class EditImageWidget extends StatelessWidget {
  final File fileImage;
  const EditImageWidget({
    super.key,
    required this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    var cropImageWidget = CropImageWidget(
      fileImage: fileImage,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("Редактирование"),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          actions: [
            IconButton(
                color: Colors.blue,
                iconSize: 35,
                onPressed: () async {
                  var fileCropImage = await cropImageWidget.cropImage();
                  AppNavigator.popPage<File>(fileCropImage);
                },
                icon: const Icon(Icons.arrow_forward))
          ],
          leading: const IconButton(
              iconSize: 35,
              onPressed: AppNavigator.popPage,
              icon: Icon(Icons.arrow_back)),
        ),
        body: Stack(children: [
          Column(children: [
            cropImageWidget,
            Expanded(
                child: Container(
              color: Colors.grey,
            ))
          ])
        ]));
  }
}
