import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/account_content.dart';
import 'package:desgram_ui/ui/roots/add_content.dart';
import 'package:desgram_ui/ui/roots/another_account_content.dart';
import 'package:desgram_ui/ui/roots/home_content.dart';
import 'package:desgram_ui/ui/roots/notifications_content%20.dart';
import 'package:desgram_ui/ui/roots/search_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  final List<int> stackIndexBottomBar = [0];
  int indexBottomBar = 0;
  final List<ContentMainPageNavigator> contentNavigators = [
    ContentMainPageNavigator(),
    ContentMainPageNavigator(),
    ContentMainPageNavigator(),
    ContentMainPageNavigator(),
    ContentMainPageNavigator()
  ];

  _ViewModel({
    required this.context,
  });

  bool maybePopStackIndexBottomBar() {
    if (stackIndexBottomBar.length != 1) {
      stackIndexBottomBar.removeLast();
      _updateCurrentIndexNavBar(stackIndexBottomBar.last);
      return true;
    } else {
      return false;
    }
  }

  void addStackIndexBottomBar(int currentIndex) {
    if (indexBottomBar != currentIndex) {
      stackIndexBottomBar.add(currentIndex);
    }
    _updateCurrentIndexNavBar(currentIndex);
  }

  void _updateCurrentIndexNavBar(int currentIndex) {
    if (indexBottomBar == currentIndex) {
      contentNavigators[indexBottomBar]
          .key
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      indexBottomBar = currentIndex;
    }
    notifyListeners();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Offstage(
              offstage: viewModel.indexBottomBar != 0,
              child: Navigator(
                initialRoute: ContentMainPageRoutes.homeContent,
                key: viewModel.contentNavigators[0].key,
                onGenerateRoute: (settings) => viewModel.contentNavigators[0]
                    .onGeneratedRoutes(settings, context),
              ),
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 1,
              child: Navigator(
                initialRoute: ContentMainPageRoutes.searchContent,
                key: viewModel.contentNavigators[1].key,
                onGenerateRoute: (settings) => viewModel.contentNavigators[1]
                    .onGeneratedRoutes(settings, context),
              ),
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 2,
              child: Navigator(
                initialRoute: ContentMainPageRoutes.addContent,
                key: viewModel.contentNavigators[2].key,
                onGenerateRoute: (settings) => viewModel.contentNavigators[2]
                    .onGeneratedRoutes(settings, context),
              ),
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 3,
              child: Navigator(
                initialRoute: ContentMainPageRoutes.notificationsContent,
                key: viewModel.contentNavigators[3].key,
                onGenerateRoute: (settings) => viewModel.contentNavigators[3]
                    .onGeneratedRoutes(settings, context),
              ),
            ),
            Offstage(
              offstage: viewModel.indexBottomBar != 4,
              child: Navigator(
                initialRoute: ContentMainPageRoutes.accountContent,
                key: viewModel.contentNavigators[4].key,
                onGenerateRoute: (settings) => viewModel.contentNavigators[4]
                    .onGeneratedRoutes(settings, context),
              ),
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
            .contentNavigators[viewModel.indexBottomBar].key.currentState!
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
      create: (context) => _ViewModel(
        context: context,
      ),
      child: const MainPage(),
    );
  }
}

class ContentMainPageRoutes {
  static const homeContent = "home_content";
  static const searchContent = "search_content";
  static const addContent = "add_content";
  static const notificationsContent = "notifications_content";
  static const accountContent = "account_content";
  static const anotherAccountContent = "another_account_content";
}

class ContentMainPageNavigator {
  final key = GlobalKey<NavigatorState>();

  void toAnotherAccountContent() {
    key.currentState?.pushNamed(ContentMainPageRoutes.anotherAccountContent);
  }

  Route<dynamic>? onGeneratedRoutes(
      RouteSettings settings, BuildContext context) {
    switch (settings.name) {
      case ContentMainPageRoutes.homeContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => HomeContent.create(this)));
      case ContentMainPageRoutes.searchContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => SearchContent.create(this)));
      case ContentMainPageRoutes.addContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AddContent.create(this)));
      case ContentMainPageRoutes.notificationsContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => NotificationsContent.create(this)));
      case ContentMainPageRoutes.accountContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AccountContent.create(this)));
      case ContentMainPageRoutes.anotherAccountContent:
        return PageRouteBuilder(
            pageBuilder: ((_, __, ___) => AnotherAccountContent.create(this)));
    }
    return null;
  }
}
