import 'package:newket/config/dio_client.dart';
import 'package:newket/model/ticket/autocomplete_response.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/model/ticket/search_result_response.dart';
import 'package:newket/model/ticket/ticket_detail_response.dart';

class TicketRepository {
  var dio = DioClient.dio;

  // 오픈 예정 티켓 (예매 오픈 임박 순)
  Future<BeforeSaleTicketsResponse> getBeforeSaleTickets() async {
    final response = await dio.get("/api/v1/tickets/before-sale");

    return BeforeSaleTicketsResponse.fromJson(response.data);
  }

  // 오픈 예정 티켓 (최신 등록 순)
  Future<BeforeSaleTicketsResponse> getBeforeSaleTicketsOrderById() async {
    final response = await dio.get("/api/v1/tickets/before-sale?orderby=new");

    return BeforeSaleTicketsResponse.fromJson(response.data);
  }

  // 예매 중인 티켓 (공연 날짜 임박 순)
  Future<OnSaleResponse> getOnSaleTickets() async {
    final response = await dio.get("/api/v1/tickets/on-sale");

    return OnSaleResponse.fromJson(response.data);
  }

  // 예매 중인 티켓 (최신 등록 순)
  Future<OnSaleResponse> getOnSaleTicketsById() async {
    final response = await dio.get("/api/v1/tickets/on-sale?orderby=new");

    return OnSaleResponse.fromJson(response.data);
  }

  //티켓 상세
  Future<TicketDetailResponse> getTicketDetail(int ticketId) async {
    final response = await dio.get("/api/v1/tickets/$ticketId");

    return TicketDetailResponse.fromJson(response.data);
  }

  // 공연명+아티스트로 검색
  Future<SearchResultResponse> searchResult(String keyword) async {
    final response = await dio.get("/api/v1/tickets/search?keyword=$keyword");

    return SearchResultResponse.fromJson(response.data);
  }

  // 공연명+아티스트로 검색 자동완성
  Future<AutocompleteResponse> autocomplete(String keyword) async {
    final response = await dio.get("/api/v1/tickets/autocomplete?keyword=$keyword");

    return AutocompleteResponse.fromJson(response.data);
  }
}
