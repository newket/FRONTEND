import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage;

  SecureStorage({
    required this.storage,
  });

  //  리프레시 토큰 저장
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      print('[SECURE_STORAGE] saveRefreshToken: $refreshToken');
      await storage.write(key: "REFRESH_TOKEN", value: refreshToken);
    } catch (e) {
      print("[ERR] RefreshToken 저장 실패: $e");
    }
  }

  // 리프레시 토큰 불러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: "REFRESH_TOKEN");
      print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      return refreshToken;
    } catch (e) {
      print("[ERR] RefreshToken 불러오기 실패: $e");
      return null;
    }
  }

  // 에세스 토큰 저장
  Future<void> saveAccessToken(String accessToken) async {
    try {
      print('[SECURE_STORAGE] saveAccessToken: $accessToken');
      await storage.write(key: "ACCESS_TOKEN", value: accessToken);
    } catch (e) {
      print("[ERR] AccessToken 저장 실패: $e");
    }
  }

  // 에세스 토큰 불러오기
  Future<String> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: "ACCESS_TOKEN");
      return accessToken!;
    } catch (e) {
      print("[ERR] AccessToken 불러오기 실패: $e");
      throw Exception("[ERR] AccessToken 불러오기 실패: $e");
    }
  }
}