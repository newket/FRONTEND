class ArtistDto {
  int artistId;
  String name;
  String? subName;
  String? imageUrl;

  ArtistDto({required this.artistId, required this.name, required this.subName, required this.imageUrl});

  factory ArtistDto.fromJson(Map<String, dynamic> json) {
    return ArtistDto(
        artistId: json['artistId'], name: json['name'], subName: json['subName'], imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {'artistId': artistId, 'name': name, 'subName': subName, 'imageUrl': imageUrl};
  }
}
