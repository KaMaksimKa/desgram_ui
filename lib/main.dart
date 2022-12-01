import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/authorization.dart';
import 'package:desgram_ui/ui/roots/loader.dart';
import 'package:desgram_ui/ui/roots/user_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) =>
          AppNavigator.onGeneratedRoutes(settings, context),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Loader.create(),
    );
  }
}
