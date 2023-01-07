import 'package:flutter/material.dart';

import '../main_page_navigator.dart';

class SubpageWidget extends StatefulWidget {
  final MainPageNavigator mainPageNavigator;

  const SubpageWidget({
    super.key,
    required this.mainPageNavigator,
  });
  @override
  State<SubpageWidget> createState() => _SubpageWidgetState();
}

class _SubpageWidgetState extends State<SubpageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
