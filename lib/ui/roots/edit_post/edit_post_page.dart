import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/domain/models/post/post_model.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/edit_post/edit_post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../inrernal/dependencies/api_module.dart';
import '../../../utils/helpers/image_content_helper.dart';
import '../../app_widgets/image_user_avatar.dart';

class EditPostPage extends StatelessWidget {
  const EditPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditPostViewModel>();
    var post = viewModel.postModel;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text("Редактировать"),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w600),
          actions: [
            viewModel.state.isEditingPost
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
                    onPressed: viewModel.editPost,
                    icon: const Icon(Icons.check))
          ],
          leading: IconButton(
              iconSize: 35,
              onPressed:
                  viewModel.state.isEditingPost ? null : AppNavigator.popPage,
              icon: const Icon(Icons.close)),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: ImageUserAvatar.fromImageModel(
                            imageModel: post.user.avatar, size: 40),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            post.user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width,
                  child: PageView.builder(
                      onPageChanged: (value) {
                        viewModel.state =
                            viewModel.state.copyWith(currentImageIndex: value);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(baseUrl +
                                      ImageContentHelper.chooseImage(
                                              images: post.imageContents[index]
                                                  .imageCandidates,
                                              quality: ImageQuality.high)
                                          .url))),
                        );
                      },
                      itemCount: post.imageContents.length),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < post.imageContents.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: i == viewModel.state.currentImageIndex
                                    ? const Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color:
                                            Color.fromARGB(255, 187, 187, 187),
                                      ),
                              )
                          ]),
                    ])),
              ]),
            ),
            TextField(
              autofocus: true,
              controller: viewModel.descriptionController,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              minLines: 1,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
              style: const TextStyle(fontSize: 18),
            )
          ]),
        ));
  }

  static Widget create({required PostModel postModel}) {
    return ChangeNotifierProvider(
      create: (context) =>
          EditPostViewModel(postModel: postModel, context: context),
      child: const EditPostPage(),
    );
  }
}
