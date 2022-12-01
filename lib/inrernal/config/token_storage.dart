import 'package:desgram_ui/domain/models/token_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  static Future<TokenModel?> getTokenModel() async {
    const storage = FlutterSecureStorage();

    final accessToken = await storage.read(key: _accessTokenKey);
    final refreshToken = await storage.read(key: _refreshTokenKey);

    return accessToken != null && refreshToken != null
        ? TokenModel(accessToken: accessToken, refreshToken: refreshToken)
        : null;
  }

  static Future setTokenModel(TokenModel? tokenModel) async {
    const storage = FlutterSecureStorage();

    storage.delete(key: _accessTokenKey);
    storage.delete(key: _refreshTokenKey);

    if (tokenModel != null) {
      storage.write(key: _accessTokenKey, value: tokenModel.accessToken);
      storage.write(key: _refreshTokenKey, value: tokenModel.refreshToken);
    }
  }

  static Future<String?> getAccessToken() async {
    const storage = FlutterSecureStorage();

    final accessToken = await storage.read(key: _accessTokenKey);

    return accessToken;
  }

  static Future<String?> getRefreshToken() async {
    const storage = FlutterSecureStorage();

    final refreshToken = await storage.read(key: _refreshTokenKey);

    return refreshToken;
  }
}
