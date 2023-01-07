import 'package:desgram_ui/firebase_options.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../data/services/database.dart';

Future initFarebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  FirebaseMessaging.onMessage.listen(onMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
}

Future initApp() async {
  await initFarebase();
  await DB.instanse.init();
}

void onMessage(RemoteMessage event) {}

void onMessageOpenedApp(RemoteMessage event) {
  AppNavigator.toMainPage(indexBottomBar: 3);
}
