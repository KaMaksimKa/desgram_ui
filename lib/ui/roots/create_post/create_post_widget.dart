import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/ui/roots/create_post/create_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_navigator.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreatePostViewModel>();
    var files = viewModel.state.files;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Новая публикация"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
        actions: [
          viewModel.state.isLoading
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
                  onPressed: viewModel.createPost,
                  icon: const Icon(Icons.check))
        ],
        leading: IconButton(
            iconSize: 35,
            onPressed: viewModel.state.isLoading ? null : AppNavigator.popPage,
            icon: const Icon(Icons.close)),
      ),
      body: Column(children: [
        Container(
          height: 80,
          child: ListView.builder(
            itemCount: viewModel.state.files.length + 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  // margin: EdgeInsets.all(3),
                  width: 80.0,
                  child: IconButton(
                      onPressed: viewModel.addImagePost,
                      iconSize: 80,
                      icon: const Icon(
                        Icons.add_box,
                      )),
                );
              }
              return Container(
                margin: EdgeInsets.all(3),
                width: 80.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(viewModel.state.files[index - 1]))),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: TextField(
            style: TextStyle(fontSize: 22),
            controller: viewModel.descriptionController,
            decoration: const InputDecoration(hintText: "Добавте подпись..."),
            maxLines: 10,
            minLines: 1,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                      flex: 3,
                      child: Text(
                        "Скрывать число лайков",
                        style: TextStyle(fontSize: 18),
                      )),
                  Expanded(
                      flex: 1,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: !viewModel.state.isLikesVisible,

                        onChanged: (bool value) {
                          viewModel.state =
                              viewModel.state.copyWith(isLikesVisible: !value);
                        },
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Expanded(
                      flex: 3,
                      child: Text(
                        "Выключить комментарии",
                        style: TextStyle(fontSize: 18),
                      )),
                  Expanded(
                      flex: 1,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: !viewModel.state.isCommentsEnabled,

                        onChanged: (bool value) {
                          viewModel.state = viewModel.state
                              .copyWith(isCommentsEnabled: !value);
                        },
                      )),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => CreatePostViewModel(),
      child: const CreatePostWidget(),
    );
  }
}
