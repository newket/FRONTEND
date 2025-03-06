import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';

class ArtistProfileResponse {
  ArtistDto info;
  List<ArtistDto> members;
  List<ArtistDto> groups;
  BeforeSaleTicketsResponse beforeSaleTickets;
  OnSaleResponse onSaleTickets;
  OnSaleResponse afterSaleTickets;

  ArtistProfileResponse(
      {required this.info,
      required this.members,
      required this.groups,
      required this.beforeSaleTickets,
      required this.onSaleTickets,
      required this.afterSaleTickets});

  factory ArtistProfileResponse.fromJson(Map<String, dynamic> json) {
    return ArtistProfileResponse(
      info: ArtistDto.fromJson(json['info']),
      members: (json['members'] as List<dynamic>?)?.map((e) => ArtistDto.fromJson(e)).toList() ?? [],
      groups: (json['groups'] as List<dynamic>?)?.map((e) => ArtistDto.fromJson(e)).toList() ?? [],
      beforeSaleTickets: BeforeSaleTicketsResponse.fromJson(json['beforeSaleTickets']),
      onSaleTickets: OnSaleResponse.fromJson(json['onSaleTickets']),
      afterSaleTickets: OnSaleResponse.fromJson(json['afterSaleTickets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'members': members.map((v) => v.toJson()).toList(),
      'groups': groups.map((v) => v.toJson()).toList(),
      'beforeSaleTickets': beforeSaleTickets.toJson(),
      'onSaleTickets': onSaleTickets.toJson(),
      'afterSaleTickets': afterSaleTickets.toJson(),
    };
  }
}
