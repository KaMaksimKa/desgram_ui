import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../app_navigator.dart';

class ChooseImageViewModelState {
  final int currentBottomIndex;
  final List<File> filesFromGallery;

  ChooseImageViewModelState({
    required this.currentBottomIndex,
    required this.filesFromGallery,
  });

  ChooseImageViewModelState copyWith({
    int? currentBottomIndex,
    List<File>? filesFromGallery,
  }) {
    return ChooseImageViewModelState(
      currentBottomIndex: currentBottomIndex ?? this.currentBottomIndex,
      filesFromGallery: filesFromGallery ?? this.filesFromGallery,
    );
  }
}

class ChooseImageViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  ChooseImageViewModelState _state =
      ChooseImageViewModelState(currentBottomIndex: 0, filesFromGallery: []);
  ChooseImageViewModelState get state => _state;

  set state(ChooseImageViewModelState val) {
    _state = val;
    pageController.animateToPage(val.currentBottomIndex,
        curve: Curves.decelerate, duration: const Duration(milliseconds: 300));
    notifyListeners();
  }

  ChooseImageViewModel() {
    _asyncInit();
  }

  Future _asyncInit() async {
    var files = await getImagesGallerey();
    state = state.copyWith(
      filesFromGallery: files,
    );
  }

  Future pickImage({required File file}) async {
    var newAvatar = await AppNavigator.toEditImagePage(file: file);
    AppNavigator.popPage(newAvatar);
  }

  Future<List<File>> getImagesGallerey() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    if (albums.isEmpty) {
      return [];
    }
    final albumAssets =
        await albums.first.getAssetListRange(start: 0, end: 1000);
    List<File> files = [];

    for (var asset in albumAssets) {
      var file = await asset.file;
      if (file != null) {
        files.add(file);
      }
    }
    return files;
  }
}
