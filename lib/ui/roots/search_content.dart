import 'package:desgram_ui/ui/roots/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class SearchContent extends StatelessWidget {
  final ContentMainPageNavigator appPageNavigator;

  const SearchContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Поиск"),
      ),
      body: Center(
          child: IconButton(
              onPressed: () {
                appPageNavigator.toAnotherAccountContent();
              },
              icon: const Icon(
                Icons.search,
              ))),
    );
  }

  static Widget create(ContentMainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: SearchContent(appPageNavigator: appPageNavigator),
    );
  }
}
