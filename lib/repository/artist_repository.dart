import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/auth/auth_dio.dart';
import 'package:newket/view/login/screen/before_login_screen.dart';

class ArtistRepository {
  Future<SearchArtists> searchArtist(String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get("/api/v1/artists?keyword=$keyword");

    return SearchArtists.fromJson(response.data);
  }

  Future<void> requestArtist(ArtistRequest artistRequest) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final requestBody = artistRequest.toJson();
    await dio.post("/api/v2/artists/request", data: requestBody);
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


  Future<bool> getIsFavoriteArtist(int favoriteArtistId, BuildContext context) async {
    try{
      var dio = await authDio(context);
      final response = await dio.get("/api/v1/artists/favorite/$favoriteArtistId");
      return response.data as bool;
    }  on DioException {
      return false;
    }
  }


  Future<bool> addFavoriteArtist(int artistId, BuildContext context) async {
    try{
      var dio = await authDio(context);
      await dio.put("/api/v1/artists/favorite/$artistId");
      return true;
    }  on DioException {
      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BeforeLogin(),
        ),
      );
      return false;
    }
  }

  Future<void> deleteFavoriteArtist(int artistId, BuildContext context) async {
    var dio = await authDio(context);
    await dio.delete("/api/v1/artists/favorite/$artistId");
  }
}
