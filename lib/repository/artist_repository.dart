import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/model/artist_model.dart';


class ArtistRepository{
  Future<SearchArtists> searchArtist(BuildContext context, String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/artists?keyword=$keyword"
    );

    return SearchArtists.fromJson(response.data);
  }
}