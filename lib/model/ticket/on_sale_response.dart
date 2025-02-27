class OnSaleResponse {
  int totalNum;
  List<OnSaleTicketDto> tickets;

  OnSaleResponse({required this.totalNum, required this.tickets});

  factory OnSaleResponse.fromJson(Map<String, dynamic> json) {
    var ticketList = json['tickets'] as List;
    List<OnSaleTicketDto> ticketItems = ticketList.map((i) => OnSaleTicketDto.fromJson(i)).toList();

    return OnSaleResponse(
      totalNum: json['totalNum'],
      tickets: ticketItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalNum': totalNum,
      'tickets': tickets.map((v) => v.toJson()).toList(),
    };
  }
}

class OnSaleTicketDto {
  int ticketId;
  String imageUrl;
  String title;
  String date;

  OnSaleTicketDto({
    required this.ticketId,
    required this.imageUrl,
    required this.title,
    required this.date,
  });

  factory OnSaleTicketDto.fromJson(Map<String, dynamic> json) {
    return OnSaleTicketDto(
      ticketId: json['ticketId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'imageUrl': imageUrl,
      'title': title,
      'date': date,
    };
  }
}
