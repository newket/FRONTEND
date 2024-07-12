import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/secure/auth_dio.dart';

class TicketRepository{
  Future<OpeningNoticeResponse> openingNoticeApi(BuildContext context) async {
    // var dio = await authDio(context);
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");

    final response = await dio.get(
        "/api/v1/tickets/open"
    );

    return OpeningNoticeResponse.fromJson(response.data);
  }
}