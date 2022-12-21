import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/app_widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_image_post_view_model.dart';

class ChooseImagePostWidget extends StatelessWidget {
  const ChooseImagePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChooseImagePostViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Фото для поста"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        leading: const IconButton(
            iconSize: 35,
            onPressed: AppNavigator.popPage,
            icon: Icon(Icons.close)),
      ),
      body: CameraWidget(
        onFile: (file) {
          AppNavigator.toEditImagePage(file: file).then((value) async {
            AppNavigator.popPage(value);
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 15),
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: const Text(
                "Галерея",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            )),
            Expanded(
                child: Container(
              child: const Text(
                "Фото",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            )),
          ],
        ),
      )),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ChooseImagePostViewModel(),
      child: const ChooseImagePostWidget(),
    );
  }
}
