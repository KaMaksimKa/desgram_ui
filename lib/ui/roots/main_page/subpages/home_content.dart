// ignore: unused_import
import 'package:desgram_ui/ui/roots/main_page/main_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_page_navigator.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class HomeContent extends StatelessWidget {
  final MainPageNavigator appPageNavigator;

  const HomeContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
      ),
      body: Center(
          child: IconButton(
              onPressed: () {
                appPageNavigator.toAnotherAccountContent();
              },
              icon: const Icon(
                Icons.home,
              ))),
    );
  }

  static Widget create(MainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: HomeContent(appPageNavigator: appPageNavigator),
    );
  }
}
