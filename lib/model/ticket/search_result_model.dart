import 'package:newket/model/ticket/on_sale_model.dart';
import 'package:newket/model/ticket/opening_notice_model.dart';

class SearchResultResponse {
  List<Artist> artists;
  OpeningNoticeResponse openingNotice;
  OnSaleResponse onSale;

  SearchResultResponse({required this.artists, required this.openingNotice, required this.onSale});

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<Artist> artistItems = artistList.map((i) => Artist.fromJson(i)).toList();
    return SearchResultResponse(
      artists: artistItems,
      openingNotice: OpeningNoticeResponse.fromJson(json['openingNotice'] as Map<String, dynamic>),
      onSale: OnSaleResponse.fromJson(json['onSale'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists.map((v) => v.toJson()).toList(),
      'openingNotice': openingNotice.toJson(),
      'onSale': onSale.toJson(),
    };
  }
}

class Artist {
  int artistId;
  String name;
  String? subName;
  String? imageUrl;

  Artist({required this.artistId, required this.name, required this.subName, required this.imageUrl});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(artistId: json['artistId'], name: json['name'], subName: json['subName'], imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    return {'artistId': artistId, 'name': name, 'subName': subName, 'imageUrl': imageUrl};
  }
}