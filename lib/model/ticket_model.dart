class OpeningNoticeResponse {
  List<Concert> concert;

  OpeningNoticeResponse({required this.concert});

  factory OpeningNoticeResponse.fromJson(Map<String, dynamic> json) {
    var concertList = json['concert'] as List;
    List<Concert> concertItems = concertList.map((i) => Concert.fromJson(i)).toList();

    return OpeningNoticeResponse(
      concert: concertItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concert': concert.map((v) => v.toJson()).toList(),
    };
  }
}

class Concert {
  int concertId;
  String imageUrl;
  String title;
  List<TicketingSchedule> ticketingSchedule;

  Concert({
    required this.concertId,
    required this.imageUrl,
    required this.title,
    required this.ticketingSchedule,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    var ticketingScheduleList = json['ticketingSchedule'] as List;
    List<TicketingSchedule> ticketingScheduleItems =
    ticketingScheduleList.map((i) => TicketingSchedule.fromJson(i)).toList();

    return Concert(
      concertId: json['concertId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      ticketingSchedule: ticketingScheduleItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concertId': concertId,
      'imageUrl': imageUrl,
      'title': title,
      'ticketingSchedule': ticketingSchedule.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketingSchedule {
  String type;
  String day;
  String time;

  TicketingSchedule({required this.type, required this.day, required this.time});

  factory TicketingSchedule.fromJson(Map<String, dynamic> json) {
    return TicketingSchedule(
      type: json['type'],
      day:json['day'],
      time:json['time']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'day': day,
      'time': time
    };
  }
}