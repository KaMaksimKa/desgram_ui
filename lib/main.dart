import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:desgram_ui/ui/roots/authorization.dart';
import 'package:desgram_ui/ui/roots/loader.dart';
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
      home: Authorization.create(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => TestHomePageState();
}

class TestHomePageState extends State<TestHomePage> {
  void _goToLoader(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Loader();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(children: [
        TextButton(
            onPressed: () => _goToLoader(context),
            child: const Text(
              "Loader",
              style: TextStyle(fontSize: 30),
            ))
      ])),
    );
  }
}
