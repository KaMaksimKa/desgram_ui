import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/main_page/main_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<MainPageViewModel>();

    if (!viewModel.contentNavigators.containsKey(viewModel.indexBottomBar)) {
      viewModel.contentNavigators[viewModel.indexBottomBar] = Navigator(
        initialRoute: viewModel.initialRoutes[viewModel.indexBottomBar],
        key: viewModel.contentMainPageNavigators[viewModel.indexBottomBar].key,
        onGenerateRoute: (settings) => viewModel
            .contentMainPageNavigators[viewModel.indexBottomBar]
            .onGeneratedRoutes(settings, context),
      );
    }

    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Offstage(
              offstage: viewModel.indexBottomBar != 0,
              child: viewModel.contentNavigators[0],
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 1,
              child: viewModel.contentNavigators[1],
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 2,
              child: viewModel.contentNavigators[2],
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 3,
              child: viewModel.contentNavigators[3],
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 4,
              child: viewModel.contentNavigators[4],
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: viewModel.indexBottomBar,
          iconSize: 30,
          onTap: viewModel.addStackIndexBottomBar,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                activeIcon: Icon(Icons.add_box),
                label: "Add"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: "Favorite"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                activeIcon: Icon(Icons.account_circle),
                label: "Account"),
          ],
        ),
      ),
      onWillPop: () async {
        var isFirstContent = !await viewModel
            .contentMainPageNavigators[viewModel.indexBottomBar]
            .key
            .currentState!
            .maybePop();
        if (!isFirstContent) {
          return false;
        }
        var isFirstContentPage = !viewModel.maybePopStackIndexBottomBar();
        if (!isFirstContentPage) {
          return false;
        }

        if (AppNavigator.key.currentState!.canPop()) {
          AppNavigator.key.currentState!.pop();
          return false;
        }
        return true;
      },
    );
  }

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => MainPageViewModel(
        context: context,
      ),
      child: const MainPage(),
    );
  }
}
