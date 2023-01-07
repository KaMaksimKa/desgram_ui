import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/app_widgets/camera_widget.dart';
import 'package:desgram_ui/ui/app_widgets/keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_image_view_model.dart';

class ChooseImageWidget extends StatelessWidget {
  const ChooseImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ChooseImageViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: viewModel.state.currentBottomIndex == 0
            ? const Text("Галерея")
            : const Text("Фото"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        leading: const IconButton(
            iconSize: 35,
            onPressed: AppNavigator.popPage,
            icon: Icon(Icons.close)),
      ),
      body: SizedBox(
          child: PageView(
        controller: viewModel.pageController,
        onPageChanged: (value) {
          viewModel.state = viewModel.state.copyWith(currentBottomIndex: value);
        },
        children: [
          CustomScrollView(
            slivers: [
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return GestureDetector(
                      onTap: () {
                        viewModel.pickImage(
                            file: viewModel.state.filesFromGallery[index]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(
                                    viewModel.state.filesFromGallery[index]))),
                      ),
                    );
                  }, childCount: viewModel.state.filesFromGallery.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 1.0,
                  ))
            ],
          ),
          KeepAliveWidget(
            child: CameraWidget(
              onFile: (file) => viewModel.pickImage(file: file),
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 15),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                viewModel.state =
                    viewModel.state.copyWith(currentBottomIndex: 0);
              },
              child: Text(
                "Галерея",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: viewModel.state.currentBottomIndex == 0
                        ? Colors.black
                        : Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                viewModel.state =
                    viewModel.state.copyWith(currentBottomIndex: 1);
              },
              child: Text(
                "Фото",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: viewModel.state.currentBottomIndex == 1
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            )),
          ],
        ),
      )),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => ChooseImageViewModel(),
      child: const ChooseImageWidget(),
    );
  }
}
