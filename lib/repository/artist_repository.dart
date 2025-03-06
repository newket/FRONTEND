import 'package:dio/dio.dart';
import 'package:newket/config/dio_client.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/model/artist/artist_profile_response.dart';
import 'package:newket/model/artist/artist_request.dart';

class ArtistRepository {
  var dio = DioClient.dio;

  Future<void> requestArtist(ArtistRequest artistRequest) async {
    final requestBody = artistRequest.toJson();
    await dio.post(
      "/api/v1/artists/request",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
        },
      ),
    );
  }

  //아티스트 프로필
  Future<ArtistProfileResponse> getArtistProfile(int artistId) async {
    final response = await dio.get("/api/v1/artists/$artistId");
    return ArtistProfileResponse.fromJson(response.data);
  }

  //아티스트 랜덤 추천
  Future<List<ArtistDto>> getRandomArtists() async {
    final response = await dio.get("/api/v1/artists/random");
    print((response.data as List).map((e) => ArtistDto.fromJson(e)).toList());
    return (response.data as List).map((e) => ArtistDto.fromJson(e)).toList();
  }
}
