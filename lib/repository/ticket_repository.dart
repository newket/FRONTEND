import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/secure/auth_dio.dart';

class TicketRepository{
  //예매 오픈 임박 순
  Future<OpeningNoticeResponse> openingNoticeApi(BuildContext context) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/open"
    );

    return OpeningNoticeResponse.fromJson(response.data);
  }

  //최신 등록 순
  Future<OpeningNoticeResponse> openingNoticeApiOrderById(BuildContext context) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/open?orderby=new"
    );

    return OpeningNoticeResponse.fromJson(response.data);
  }

  //공연 날짜 임박 순
  Future<OnSaleResponse> onSaleApi(BuildContext context) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/onsale"
    );

    return OnSaleResponse.fromJson(response.data);
  }

  //최신 등록 순
  Future<OnSaleResponse> onSaleApiOrderById(BuildContext context) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/onsale?orderby=new"
    );

    return OnSaleResponse.fromJson(response.data);
  }

  //티켓 상세 - 예매중
  Future<TicketDetail> ticketDetail(BuildContext context, int concertId) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/$concertId"
    );

    return TicketDetail.fromJson(response.data);
  }
}