import 'dart:io';

import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

String baseUrl = "https://10.0.2.2:5001";

class ApiModule {
  static AuthClient? _authClient;
  static AuthClient getAuthClient() {
    if (_authClient == null) {
      final dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      _authClient = AuthClient(dio, baseUrl: baseUrl);
    }
    return _authClient!;
  }
}
