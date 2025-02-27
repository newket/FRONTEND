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