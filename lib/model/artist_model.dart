class SearchArtists {
  List<Artist> artists;

  SearchArtists({required this.artists});

  factory SearchArtists.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<Artist> artistItems = artistList.map((i) => Artist.fromJson(i)).toList();

    return SearchArtists(
      artists: artistItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists.map((v) => v.toJson()).toList(),
    };
  }
}

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

class FavoriteArtistV1s {
  List<int> artistIds;

  FavoriteArtistV1s(this.artistIds);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"artistIds": artistIds};
  }
}