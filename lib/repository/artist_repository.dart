import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist/artist_profile_model.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/auth/auth_dio.dart';
import 'package:newket/view/login/screen/before_login_screen.dart';

class ArtistRepository {
  Future<void> requestArtist(ArtistRequest artistRequest) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final requestBody = artistRequest.toJson();
    await dio.post("/api/v2/artists/request", data: requestBody);
  }

  //관심 아티스트 등록
  Future<void> putFavoriteArtists(BuildContext context, FavoriteArtistsRequest favoriteArtistsRequest) async {
    var dio = await authDio(context);
    final requestBody = favoriteArtistsRequest.toJson();
    await dio.put("/api/v1/artists/favorite", data: requestBody);
  }

  //관심 아티스트 불러오기
  Future<FavoriteArtistsResponse> getFavoriteArtists(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/artists/favorite");

    return FavoriteArtistsResponse.fromJson(response.data);
  }

  //관심 아티스트 여부
  Future<bool> getIsFavoriteArtist(int favoriteArtistId, BuildContext context) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get("/api/v1/artists/favorite/$favoriteArtistId");
      return response.data as bool;
    } on DioException {
      return false;
    }
  }

  // 관심 아티스트 추가
  Future<bool> addFavoriteArtist(int artistId, BuildContext context) async {
    try {
      var dio = await authDio(context);
      await dio.put("/api/v1/artists/favorite/$artistId");
      return true;
    } on DioException {
      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BeforeLoginScreen(),
        ),
      );
      return false;
    }
  }

  //관심 아티스트 삭제
  Future<void> deleteFavoriteArtist(int artistId, BuildContext context) async {
    var dio = await authDio(context);
    await dio.delete("/api/v1/artists/favorite/$artistId");
  }

  //아티스트 프로필
  Future<ArtistProfileResponse> getArtistProfile(int artistId) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final response = await dio.get("/api/v1/artists/$artistId");
    return ArtistProfileResponse.fromJson(response.data);
  }
}
