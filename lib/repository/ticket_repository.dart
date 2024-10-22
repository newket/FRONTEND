import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/secure/auth_dio.dart';

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
  Future<TicketDetail> ticketDetail(int concertId) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v2/tickets/$concertId"
    );

    return TicketDetail.fromJson(response.data);
  }

  //티켓 검색
  Future<SearchTicketResponse> searchTicket(String keyword) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/search?keyword=$keyword"
    );

    return SearchTicketResponse.fromJson(response.data);
  }

  //관심 아티스트의 오픈 예정 티켓
  Future<FavoriteOpeningNotice> getFavoriteOpeningNotice(BuildContext context) async {
    var dio = await authDio(context);

    final response = await dio.get("/api/v1/tickets/favorite");
    return FavoriteOpeningNotice.fromJson(response.data);
  }
}