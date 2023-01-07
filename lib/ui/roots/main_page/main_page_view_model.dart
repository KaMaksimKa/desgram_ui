import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:flutter/material.dart';

import 'main_page_navigator.dart';

class MainPageViewModel extends ChangeNotifier {
  final BuildContext context;

  final List<int> stackIndexBottomBar = [0];
  int indexBottomBar = 0;
  final List<MainPageNavigator> contentMainPageNavigators = [
    MainPageNavigator(),
    MainPageNavigator(),
    MainPageNavigator(),
    MainPageNavigator(),
    MainPageNavigator()
  ];

  final Map<int, Navigator> contentNavigators = <int, Navigator>{};
  final Map<int, String> initialRoutes = {
    0: MainPageRoutes.homeContent,
    1: MainPageRoutes.searchContent,
    2: MainPageRoutes.addContent,
    3: MainPageRoutes.notificationsContent,
    4: MainPageRoutes.accountContent
  };

  MainPageViewModel({required this.context, this.indexBottomBar = 0});

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
    if (currentIndex == 2) {
      AppNavigator.toCreatePostPage();
      return;
    }
    if (indexBottomBar == currentIndex) {
      contentMainPageNavigators[indexBottomBar]
          .key
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      indexBottomBar = currentIndex;
    }
    notifyListeners();
  }
}
