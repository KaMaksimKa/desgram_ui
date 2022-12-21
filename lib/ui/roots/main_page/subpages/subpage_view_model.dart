import 'package:flutter/material.dart';

import '../main_page_navigator.dart';

abstract class SubpageViewModel extends ChangeNotifier {
  final BuildContext context;
  final MainPageNavigator mainPageNavigator;

  SubpageViewModel({
    required this.context,
    required this.mainPageNavigator,
  });
}
