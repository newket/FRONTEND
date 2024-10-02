import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/secure/auth_dio.dart';

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
}
