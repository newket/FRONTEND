import 'package:newket/model/artist/artist_dto.dart';

class ArtistNotificationResponse {
  List<ArtistDto> artists;

  ArtistNotificationResponse({required this.artists});

  factory ArtistNotificationResponse.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<ArtistDto> artistItems = artistList.map((i) => ArtistDto.fromJson(i)).toList();

    return ArtistNotificationResponse(
      artists: artistItems,
    );
  }
}