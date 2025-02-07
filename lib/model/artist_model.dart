class Artist {
  String name;
  String? nicknames;
  int artistId;

  Artist({
    required this.name,
    required this.nicknames,
    required this.artistId,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      nicknames: json['nicknames'],
      artistId: json['artistId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nicknames': nicknames,
      'artistId': artistId,
    };
  }
}

class FavoriteArtistsResponse {
  List<Artist> artists;

  FavoriteArtistsResponse({required this.artists});

  factory FavoriteArtistsResponse.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<Artist> artistItems = artistList.map((i) => Artist.fromJson(i)).toList();

    return FavoriteArtistsResponse(
      artists: artistItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists.map((v) => v.toJson()).toList(),
    };
  }
}

class FavoriteArtistsRequest {
  List<int> artistIds;

  FavoriteArtistsRequest(this.artistIds);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"artistIds": artistIds};
  }
}

class ArtistRequest {
  String artistName;
  String? artistInfo;
  String deviceToken;

  ArtistRequest({
    required this.artistName,
    required this.artistInfo,
    required this.deviceToken,
  });

  factory ArtistRequest.fromJson(Map<String, dynamic> json) {
    return ArtistRequest(
      artistName: json['artistName'],
      artistInfo: json['artistInfo'],
      deviceToken: json['deviceToken'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'artistName': artistName,
      'artistInfo': artistInfo,
      'deviceToken': deviceToken,
    };
  }
}