import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_page_navigator.dart';

class _ViewModel extends ChangeNotifier {
  final BuildContext context;

  _ViewModel({
    required this.context,
  });
}

class AddContent extends StatelessWidget {
  final MainPageNavigator appPageNavigator;

  const AddContent({super.key, required this.appPageNavigator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить"),
      ),
      body: Center(
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_box,
              ))),
    );
  }

  static Widget create(MainPageNavigator appPageNavigator) {
    return ChangeNotifierProvider(
      create: (context) => _ViewModel(context: context),
      child: AddContent(appPageNavigator: appPageNavigator),
    );
  }
}
