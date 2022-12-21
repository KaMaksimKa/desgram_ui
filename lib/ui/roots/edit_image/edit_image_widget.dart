import 'dart:io';

import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/edit_image/edit_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditImageWidget extends StatelessWidget {
  const EditImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditImageViewModel>();
    viewModel.widgetSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.width);
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
                onPressed: () => viewModel.editImage(
                    screenSize: MediaQuery.of(context).size),
                icon: const Icon(Icons.arrow_forward))
          ],
          leading: const IconButton(
              iconSize: 35,
              onPressed: AppNavigator.popPage,
              icon: Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                RepaintBoundary(
                  key: viewModel.editingImageKey,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    child: InteractiveViewer(
                      transformationController:
                          viewModel.transformationController,
                      // boundaryMargin: EdgeInsets.all(50),
                      maxScale: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Image.file(viewModel.file),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  color: Color.fromARGB(255, 207, 207, 207),
                ))
              ],
            ),
          ],
        ));
  }

  static Widget create({required File file}) {
    return ChangeNotifierProvider(
      create: (context) => EditImageViewModel(context: context, file: file),
      child: const EditImageWidget(),
    );
  }
}
