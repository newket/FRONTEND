

class BeforeSaleTicketsResponse {
  int totalNum;
  List<BeforeSaleTicketDto> tickets;

  BeforeSaleTicketsResponse({required this.totalNum, required this.tickets});

  factory BeforeSaleTicketsResponse.fromJson(Map<String, dynamic> json) {
    var ticketList = json['tickets'] as List;
    List<BeforeSaleTicketDto> ticketItems = ticketList.map((i) => BeforeSaleTicketDto.fromJson(i)).toList();

    return BeforeSaleTicketsResponse(
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

class BeforeSaleTicketDto {
  int ticketId;
  String imageUrl;
  String title;
  List<TicketSaleScheduleDto> ticketSaleSchedules;

  BeforeSaleTicketDto({
    required this.ticketId,
    required this.imageUrl,
    required this.title,
    required this.ticketSaleSchedules,
  });

  factory BeforeSaleTicketDto.fromJson(Map<String, dynamic> json) {
    var ticketSaleScheduleList = json['ticketSaleSchedules'] as List;
    List<TicketSaleScheduleDto> ticketSaleScheduleItems =
        ticketSaleScheduleList.map((i) => TicketSaleScheduleDto.fromJson(i)).toList();

    return BeforeSaleTicketDto(
      ticketId: json['ticketId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      ticketSaleSchedules: ticketSaleScheduleItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'imageUrl': imageUrl,
      'title': title,
      'ticketSaleSchedules': ticketSaleSchedules.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketSaleScheduleDto {
  String type;
  String dday;

  TicketSaleScheduleDto({required this.type, required this.dday});

  factory TicketSaleScheduleDto.fromJson(Map<String, dynamic> json) {
    return TicketSaleScheduleDto(type: json['type'], dday: json['dday']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'dday': dday};
  }
}
