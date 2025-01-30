class OpeningNoticeResponse {
  int totalNum;
  List<Concert> concerts;

  OpeningNoticeResponse({required this.totalNum, required this.concerts});

  factory OpeningNoticeResponse.fromJson(Map<String, dynamic> json) {
    var concertList = json['concerts'] as List;
    List<Concert> concertItems = concertList.map((i) => Concert.fromJson(i)).toList();

    return OpeningNoticeResponse(
      totalNum: json['totalNum'],
      concerts: concertItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalNum': totalNum,
      'concerts': concerts.map((v) => v.toJson()).toList(),
    };
  }
}

class Concert {
  int concertId;
  String imageUrl;
  String title;
  List<TicketingSchedule> ticketingSchedules;

  Concert({
    required this.concertId,
    required this.imageUrl,
    required this.title,
    required this.ticketingSchedules,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    var ticketingScheduleList = json['ticketingSchedules'] as List;
    List<TicketingSchedule> ticketingScheduleItems =
    ticketingScheduleList.map((i) => TicketingSchedule.fromJson(i)).toList();

    return Concert(
      concertId: json['concertId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      ticketingSchedules: ticketingScheduleItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concertId': concertId,
      'imageUrl': imageUrl,
      'title': title,
      'ticketingSchedules': ticketingSchedules.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketingSchedule {
  String type;
  String dday;

  TicketingSchedule({required this.type, required this.dday});

  factory TicketingSchedule.fromJson(Map<String, dynamic> json) {
    return TicketingSchedule(type: json['type'], dday: json['dday']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'dday': dday};
  }
}