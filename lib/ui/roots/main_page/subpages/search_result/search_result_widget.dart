import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/search_result/search_result_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app_widgets/image_user_avatar.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchResultViewModel>();
    var hashtags = viewModel.state.hashtags;
    var users = viewModel.state.users;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding:
              const EdgeInsets.only(top: 7, bottom: 7, left: 50, right: 20),
          child: GestureDetector(
            onTap: () {
              viewModel.mainPageNavigator.toSearchSuggestions();
            },
            child: TextFormField(
              enabled: false,
              initialValue: viewModel.searchString,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                fillColor: Color.fromARGB(255, 235, 230, 230),
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                            onTap: () {
                              viewModel.state =
                                  viewModel.state.copyWith(indexPageView: 0);
                            },
                            child: Icon(
                              Icons.supervisor_account_outlined,
                              size: 35,
                              color: viewModel.state.indexPageView == 0
                                  ? Colors.black
                                  : Colors.grey,
                            ))),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        viewModel.state =
                            viewModel.state.copyWith(indexPageView: 1);
                      },
                      child: Text(
                        "#",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: viewModel.state.indexPageView == 1
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 1, thickness: 1)
            ],
          ),
        ),
      ),
      body: SizedBox(
          child: PageView(
        controller: viewModel.pageController,
        onPageChanged: (value) {
          viewModel.state = viewModel.state.copyWith(indexPageView: value);
        },
        children: [
          RefreshIndicator(
              onRefresh: viewModel.refreshUsers,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.usersScrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            alignment: Alignment.centerLeft,
                            minimumSize: const Size.fromHeight(55),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () => viewModel.mainPageNavigator
                              .toAnotherAccountContent(userId: users[index].id),
                          icon: ImageUserAvatar.fromImageModel(
                            imageModel: users[index].avatar,
                            size: 40,
                          ),
                          label: Text(
                            users[index].name,
                          )),
                    ),
                    childCount: users.length,
                  )),
                  if (viewModel.state.isUsersLoading)
                    SliverToBoxAdapter(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                    )
                ],
              )),
          RefreshIndicator(
              onRefresh: viewModel.refreshHashtags,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: viewModel.hashtagsScrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            alignment: Alignment.centerLeft,
                            minimumSize: const Size.fromHeight(55),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            viewModel.mainPageNavigator.toFeedHashtag(
                                hashtag: hashtags[index].hashtag);
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            alignment: Alignment.center,
                            child: const Text(
                              "#",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hashtags[index].hashtag,
                              ),
                              Text(
                                "Кол. постов: ${hashtags[index].amountPosts}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              )
                            ],
                          )),
                    ),
                    childCount: hashtags.length,
                  )),
                  if (viewModel.state.isHashtagLoading)
                    SliverToBoxAdapter(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          )),
                    )
                ],
              ))
        ],
      )),
    );
  }

  static Widget create(
      {required MainPageNavigator mainPageNavigator,
      required String searchString}) {
    return ChangeNotifierProvider(
      create: (context) => SearchResultViewModel(
          searchString: searchString,
          context: context,
          mainPageNavigator: mainPageNavigator),
      child: const SearchResultWidget(),
    );
  }
}
