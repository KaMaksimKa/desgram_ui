import 'dart:io';

import 'package:desgram_ui/data/clients/auth_client.dart';
import 'package:desgram_ui/data/services/auth_service.dart';
import 'package:desgram_ui/inrernal/config/token_storage.dart';
import 'package:desgram_ui/inrernal/dependencies/repository_module.dart';
import 'package:desgram_ui/ui/app_navigator.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../../data/clients/api_client.dart';

String baseUrl = "http://10.0.2.2:5000";

class ApiModule {
  static AuthClient? _authClient;
  static ApiClient? _apiClient;

  static AuthClient getAuthClient() {
    if (_authClient == null) {
      final dio = Dio();

      _authClient = AuthClient(dio, baseUrl: baseUrl);
    }
    return _authClient!;
  }

  static ApiClient getApiClient() {
    if (_apiClient == null) {
      final dio = addIntercepters(Dio());
      _apiClient = ApiClient(dio, baseUrl: baseUrl);
    }
    return _apiClient!;
  }

  static Dio addX509Certificate(Dio dio) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  static Dio addIntercepters(Dio dio) {
    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await TokenStorage.getAccessToken();
        options.headers.addAll({"Authorization": "Bearer $accessToken"});
        return handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          RequestOptions options = e.response!.requestOptions;

          var refreshToken = await TokenStorage.getRefreshToken();
          try {
            var tokenModel = await RepositoryModule.getApiRepository()
                .refreshToken(refreshToken: refreshToken!);
            await TokenStorage.setTokenModel(tokenModel);
            options.headers["Authorization"] =
                "Bearer ${tokenModel!.accessToken}";
          } catch (e) {
            AuthService().cleanUserLocalData();
            AppNavigator.toAuth(isRemoveUntil: true);
            return handler
                .resolve(Response(requestOptions: options, statusCode: 400));
          }
          return handler.resolve(await dio.fetch(options));
        } else {
          return handler.next(e);
        }
      },
    ));

    return dio;
  }
}

class UnauthorizedException implements Exception {}
