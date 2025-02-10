import 'package:newket/model/ticket/on_sale_model.dart';
import 'package:newket/model/ticket/opening_notice_model.dart';
import 'package:newket/model/ticket/search_result_model.dart';

class ArtistProfileResponse {
  Artist info;
  List<Artist> members;
  List<Artist> groups;
  OpeningNoticeResponse openingNotice;
  OnSaleResponse onSale;
  OnSaleResponse afterSale;

  ArtistProfileResponse(
      {required this.info,
      required this.members,
      required this.groups,
      required this.openingNotice,
      required this.onSale,
      required this.afterSale});

  factory ArtistProfileResponse.fromJson(Map<String, dynamic> json) {
    return ArtistProfileResponse(
      info: Artist.fromJson(json['info']),
      members: (json['members'] as List<dynamic>?)?.map((e) => Artist.fromJson(e)).toList() ?? [],
      groups: (json['groups'] as List<dynamic>?)?.map((e) => Artist.fromJson(e)).toList() ?? [],
      openingNotice: OpeningNoticeResponse.fromJson(json['openingNotice']),
      onSale: OnSaleResponse.fromJson(json['onSale']),
      afterSale: OnSaleResponse.fromJson(json['afterSale']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'members': members.map((v) => v.toJson()).toList(),
      'groups': groups.map((v) => v.toJson()).toList(),
      'openingNotice': openingNotice.toJson(),
      'onSale': onSale.toJson(),
      'afterSale': afterSale.toJson(),
    };
  }
}
