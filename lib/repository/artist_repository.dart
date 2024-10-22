import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/secure/auth_dio.dart';
import 'package:newket/view/v200/login/before_login.dart';

class ArtistRepository {
  Future<SearchArtists> searchArtist(String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get("/api/v1/artists?keyword=$keyword");

    return SearchArtists.fromJson(response.data);
  }

  Future<void> requestArtist(String artistName) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final deviceToken = await FirebaseMessaging.instance.getToken();

    await dio.post("/api/v1/artists/request?artistName=$artistName&deviceToken=$deviceToken");
  }

  Future<SearchArtists> getFavoriteArtists(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/artists/favorite");

    return SearchArtists.fromJson(response.data);
  }

  Future<void> putFavoriteArtists(BuildContext context, FavoriteArtists favoriteArtists) async {
    var dio = await authDio(context);
    final requestBody = favoriteArtists.toJson();
    await dio.put("/api/v1/artists/favorite", data: requestBody);
  }

  Future<bool> getIsFavoriteArtist(int favoriteArtistId) async {
    var dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    if (accessToken == null|| accessToken.isEmpty) {
      return false;
    } else {
      dio.options.baseUrl = dotenv.get("BASE_URL");
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get("/api/v1/artists/favorite/$favoriteArtistId");
      return response.data as bool;
    }
  }

  Future<void> addFavoriteArtist(int artistId, BuildContext context) async {
    var dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    if (accessToken==null || accessToken.isEmpty) {
      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BeforeLogin(),
        ),
      );
    } else {
      dio.options.baseUrl = dotenv.get("BASE_URL");
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      await dio.put("/api/v1/artists/favorite/$artistId");
    }
  }

  Future<void> deleteFavoriteArtist(int artistId, BuildContext context) async {
    var dio = await authDio(context);
    await dio.delete("/api/v1/artists/favorite/$artistId");
  }
}
