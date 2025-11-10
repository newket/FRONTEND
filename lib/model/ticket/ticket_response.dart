import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';

class TicketResponse {
  final BeforeSaleTicketsResponse beforeSaleTickets;
  final OnSaleResponse onSaleTickets;

  TicketResponse({
    required this.beforeSaleTickets,
    required this.onSaleTickets,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      beforeSaleTickets: BeforeSaleTicketsResponse.fromJson(json['beforeSaleTickets']),
      onSaleTickets: OnSaleResponse.fromJson(json['onSaleTickets']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beforeSaleTickets': beforeSaleTickets.toJson(),
      'onSaleTickets': onSaleTickets.toJson(),
    };
  }
}
