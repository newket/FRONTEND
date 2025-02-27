import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';

class SearchResultResponse {
  List<ArtistDto> artists;
  BeforeSaleTicketsResponse beforeSaleTickets;
  OnSaleResponse onSaleTickets;

  SearchResultResponse({required this.artists, required this.beforeSaleTickets, required this.onSaleTickets});

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<ArtistDto> artistItems = artistList.map((i) => ArtistDto.fromJson(i)).toList();
    return SearchResultResponse(
      artists: artistItems,
      beforeSaleTickets: BeforeSaleTicketsResponse.fromJson(json['beforeSaleTickets'] as Map<String, dynamic>),
      onSaleTickets: OnSaleResponse.fromJson(json['onSaleTickets'] as Map<String, dynamic>),
    );
  }
}