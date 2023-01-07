import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/ui/common/modal_bottom_sheets.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/account/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:desgram_ui/inrernal/dependencies/api_module.dart';
import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';

import '../../main_page_navigator.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AccountViewModel>();
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
            onPressed: viewModel.showAccountMenu,
            icon: const Icon(Icons.menu),
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
                                child: GestureDetector(
                              onTap: () => ModalBottomSheets.showEditAvatar(
                                  context: context),
                              child: ImageUserAvatar(
                                imageContentModel: userModel.avatar,
                                size: 100,
                              ),
                            )),
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
                        ElevatedButton(
                          onPressed: viewModel.toEditProfilePage,
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              minimumSize: const Size.fromHeight(37),
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          child: const Text("Редактировать профиль"),
                        ),
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
                              .toFeedUser(viewModel.currentUserId),
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

  static Widget create(MainPageNavigator mainPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => AccountViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const AccountWidget(),
    );
  }
}
