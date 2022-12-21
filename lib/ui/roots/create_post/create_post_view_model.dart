import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:desgram_ui/data/services/attach_service.dart';
import 'package:desgram_ui/data/services/post_service.dart';
import 'package:desgram_ui/domain/models/create_post_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';

class CreatePostViewModelState {
  final String description;
  final List<File> files;
  final bool isCommentsEnabled;
  final bool isLikesVisible;
  final bool isLoading;

  CreatePostViewModelState(
      {required this.description,
      required this.files,
      required this.isCommentsEnabled,
      required this.isLikesVisible,
      required this.isLoading});

  CreatePostViewModelState copyWith({
    String? description,
    List<File>? files,
    bool? isCommentsEnabled,
    bool? isLikesVisible,
    bool? isLoading,
  }) {
    return CreatePostViewModelState(
      description: description ?? this.description,
      files: files ?? this.files,
      isCommentsEnabled: isCommentsEnabled ?? this.isCommentsEnabled,
      isLikesVisible: isLikesVisible ?? this.isLikesVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CreatePostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();
  final AttachService _attachService = AttachService();
  final TextEditingController descriptionController = TextEditingController();

  CreatePostViewModel() {
    descriptionController.addListener(() {
      state = state.copyWith(description: descriptionController.text);
    });
  }

  CreatePostViewModelState _state = CreatePostViewModelState(
      description: "",
      files: [],
      isCommentsEnabled: true,
      isLikesVisible: true,
      isLoading: false);

  CreatePostViewModelState get state => _state;

  set state(CreatePostViewModelState val) {
    _state = val;
    notifyListeners();
  }

  Future addImagePost() async {
    var file = await AppNavigator.toChooseImagePostPage();
    List<File> files = List.from(state.files);
    if (file != null) {
      files.add(file);
    }

    state = state.copyWith(files: files);
  }

  Future createPost() async {
    if (state.files.isEmpty) {
      return;
    }
    state = state.copyWith(isLoading: true);
    var metadataModels = await _attachService.uploadFiles(files: state.files);
    if (metadataModels != null) {
      await _postService.createPost(
          model: CreatePostModel(
              description: state.description,
              metadataModels: metadataModels,
              isCommentsEnabled: state.isCommentsEnabled,
              isLikesVisible: state.isLikesVisible));
      state = state.copyWith(isLoading: false);
      AppNavigator.popPage();
    }
  }
}
