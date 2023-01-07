import 'package:cached_network_image/cached_network_image.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../inrernal/dependencies/api_module.dart';
import '../../main_page_navigator.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchViewModel>();
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.6),
          child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          child: GestureDetector(
            onTap: () {
              viewModel.mainPageNavigator.toSearchSuggestions();
            },
            child: const TextField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  fillColor: Color.fromARGB(255, 235, 230, 230),
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Поиск",
                  hintStyle: TextStyle(
                      fontSize: 19, color: Color.fromARGB(255, 120, 119, 119))),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.asyncInit,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: viewModel.scrollController,
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: viewModel.mainPageNavigator.toFeedInteresting,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(baseUrl +
                                  viewModel.state.posts[index].imageContents[0]
                                      .imageCandidates[0].url))),
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
      create: (context) => SearchViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const SearchWidget(),
    );
  }
}
