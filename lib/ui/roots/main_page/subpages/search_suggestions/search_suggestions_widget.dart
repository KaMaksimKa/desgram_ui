import 'package:desgram_ui/ui/app_widgets/image_user_avatar.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/subpages/search_suggestions/search_suggestions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  const SearchSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SearchSuggestionsViewModel>();
    return Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0.6),
            child: Divider(color: Colors.grey, height: 0.6, thickness: 0.6),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          flexibleSpace: Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 7, left: 50, right: 20),
            child: TextField(
              controller: viewModel.searchController,
              textInputAction: TextInputAction.search,
              onChanged: viewModel.onChangedSearchString,
              onSubmitted: viewModel.toSearchResult,
              autofocus: true,
              decoration: const InputDecoration(
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
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var user = viewModel.state.suggestionsUsers[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size.fromHeight(55),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () => viewModel.mainPageNavigator
                          .toAnotherAccountContent(userId: user.id),
                      icon: ImageUserAvatar.fromImageModel(
                        imageModel: user.avatar,
                        size: 40,
                      ),
                      label: Text(
                        user.name,
                      )),
                ],
              );
            }, childCount: viewModel.state.suggestionsUsers.length)),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              var hashtag = viewModel.state.suggestionsHashtags[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.centerLeft,
                        minimumSize: const Size.fromHeight(55),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        viewModel.mainPageNavigator
                            .toFeedHashtag(hashtag: hashtag.hashtag);
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black)),
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
                            hashtag.hashtag,
                          ),
                          Text(
                            "Кол. постов: ${hashtag.amountPosts}",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                          )
                        ],
                      )),
                ],
              );
            }, childCount: viewModel.state.suggestionsHashtags.length)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(55),
                          textStyle: const TextStyle(fontSize: 22),
                        ),
                        onPressed: () => viewModel.toSearchResult(
                            viewModel.state.suggestionsSearchString[index]),
                        icon: const Icon(
                          Icons.search,
                          size: 35,
                        ),
                        label: Text(
                          viewModel.state.suggestionsSearchString[index],
                        )),
                    childCount:
                        viewModel.state.suggestionsSearchString.length)),
            if (viewModel.state.searchString.isNotEmpty)
              SliverToBoxAdapter(
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size.fromHeight(55),
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                    onPressed: () =>
                        viewModel.toSearchResult(viewModel.state.searchString),
                    icon: const Icon(
                      Icons.search,
                      size: 35,
                    ),
                    label: Text(
                      viewModel.state.searchString,
                    )),
              )
          ],
        ));
  }

  static Widget create(MainPageNavigator mainPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => SearchSuggestionsViewModel(
          context: context, mainPageNavigator: mainPageNavigator),
      child: const SearchSuggestionsWidget(),
    );
  }
}
