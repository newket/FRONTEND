import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/auth/auth_dio.dart';
import 'package:newket/model/ticket/autocomplete_model.dart';
import 'package:newket/model/ticket/favorite_artist_opening_notice_model.dart';
import 'package:newket/model/ticket/on_sale_model.dart';
import 'package:newket/model/ticket/opening_notice_model.dart';
import 'package:newket/model/ticket/search_result_model.dart';
import 'package:newket/model/ticket/ticket_detail_model.dart';

class TicketRepository{
  //예매 오픈 임박 순
  Future<OpeningNoticeResponse> openingNoticeApi() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/open"
    );

    return OpeningNoticeResponse.fromJson(response.data);
  }

  //최신 등록 순
  Future<OpeningNoticeResponse> openingNoticeApiOrderById() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/open?orderby=new"
    );

    return OpeningNoticeResponse.fromJson(response.data);
  }

  //공연 날짜 임박 순
  Future<OnSaleResponse> onSaleApi() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/onsale"
    );

    return OnSaleResponse.fromJson(response.data);
  }

  //최신 등록 순
  Future<OnSaleResponse> onSaleApiOrderById() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/onsale?orderby=new"
    );

    return OnSaleResponse.fromJson(response.data);
  }

  //티켓 상세 - 예매중
  Future<TicketDetailResponse> ticketDetail(int concertId) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v2/tickets/$concertId"
    );

    return TicketDetailResponse.fromJson(response.data);
  }

  //관심 아티스트의 오픈 예정 티켓
  Future<FavoriteOpeningNoticeResponse> getFavoriteOpeningNotice(BuildContext context) async {
    var dio = await authDio(context);

    final response = await dio.get("/api/v1/tickets/favorite");
    return FavoriteOpeningNoticeResponse.fromJson(response.data);
  }

  //아티스트와 티켓 조회
  Future<SearchResultResponse> searchArtistsAndTickets(String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/search?keyword=$keyword"
    );

    return SearchResultResponse.fromJson(response.data);
  }

  //자동완성
  Future<AutocompleteResponse> autocomplete(String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/autocomplete?keyword=$keyword"
    );

    return AutocompleteResponse.fromJson(response.data);
  }
}