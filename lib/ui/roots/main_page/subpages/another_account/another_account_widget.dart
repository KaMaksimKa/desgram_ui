import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/ui/app_widgets/user_action_button.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/another_account/another_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../inrernal/dependencies/api_module.dart';
import '../../../../app_widgets/image_user_avatar.dart';
import '../../main_page_navigator.dart';

class AnotherAccountWidget extends StatelessWidget {
  const AnotherAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AnotherAccountViewModel>();
    var userModel = viewModel.state.currentUserModel;
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.6),
          child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
        title: userModel == null
            ? const CircularProgressIndicator()
            : Text(userModel.name),
        actions: [
          IconButton(
            onPressed: viewModel.showMoreAnotherAccount,
            icon: const Icon(Icons.more_vert),
            color: Colors.black,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: userModel == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: ImageUserAvatar(
                                imageContentModel: userModel.avatar,
                                size: 100,
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountPosts}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Публик...")
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: viewModel.toFollowers,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountFollowers}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Подп...")
                                        ],
                                      ),
                                    )),
                                    Expanded(
                                        child: TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: viewModel.toFollowing,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${userModel.amountFollowing}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Text("Подп...")
                                        ],
                                      ),
                                    )),
                                  ],
                                ))
                          ],
                        ),
                        UserActionButton(
                          userModel: userModel,
                          deleteRequest: viewModel.deleteRequest,
                          subscribe: viewModel.subscribe,
                          unsubscribe: viewModel.unsubscribe,
                          unblockUser: viewModel.unblockUser,
                        )
                      ]),
                    )
                  ])),
                  const SliverAppBar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                    pinned: true,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(0.6),
                      child: Divider(
                          color: Colors.grey, height: 0.6, thickness: 0.6),
                    ),
                    flexibleSpace: Center(
                        child: Icon(
                      Icons.grid_on,
                      size: 30,
                    )),
                  ),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => viewModel.mainPageNavigator
                              .toFeedUser(viewModel.userId),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(baseUrl +
                                        viewModel
                                            .state
                                            .posts[index]
                                            .imageContents[0]
                                            .imageCandidates[0]
                                            .url))),
                          ),
                        );
                      },
                      childCount: viewModel.state.posts.length,
                    ),
                  ),
                  if (viewModel.state.isPostsLoading)
                    SliverToBoxAdapter(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                    )
                ],
              ),
      ),
    );
  }

  static Widget create(
      {required MainPageNavigator mainPageNavigator, required String userId}) {
    return ChangeNotifierProvider(
      create: (context) => AnotherAccountViewModel(
          context: context,
          mainPageNavigator: mainPageNavigator,
          userId: userId),
      child: const AnotherAccountWidget(),
    );
  }
}
