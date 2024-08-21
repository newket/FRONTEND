// OpeningNoticeResponse
class OpeningNoticeResponse {
  int totalNum;
  String artistName;
  List<Concert> concerts;

  OpeningNoticeResponse({
    required this.totalNum,
    required this.artistName,
    required this.concerts
  });

  factory OpeningNoticeResponse.fromJson(Map<String, dynamic> json) {
    var concertList = json['concerts'] as List;
    List<Concert> concertItems = concertList.map((i) => Concert.fromJson(i)).toList();

    return OpeningNoticeResponse(
      totalNum: json['totalNum'],
      artistName: json['artistName'],
      concerts: concertItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalNum': totalNum,
      'artistName': artistName,
      'concerts': concerts.map((v) => v.toJson()).toList(),
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
  String dday;

  TicketingSchedule({required this.type, required this.dday});

  factory TicketingSchedule.fromJson(Map<String, dynamic> json) {
    return TicketingSchedule(
        type: json['type'],
        dday:json['dday']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'dday': dday
    };
  }
}


// OnSale
class OnSaleResponse {
  int totalNum;
  List<ConcertOnSale> concerts;

  OnSaleResponse({
    required this.totalNum,
    required this.concerts
  });

  factory OnSaleResponse.fromJson(Map<String, dynamic> json) {
    var concertList = json['concerts'] as List;
    List<ConcertOnSale> concertItems = concertList.map((i) => ConcertOnSale.fromJson(i)).toList();

    return OnSaleResponse(
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

class ConcertOnSale {
  int concertId;
  String imageUrl;
  String title;
  String date;

  ConcertOnSale({
    required this.concertId,
    required this.imageUrl,
    required this.title,
    required this.date,
  });

  factory ConcertOnSale.fromJson(Map<String, dynamic> json) {
    return ConcertOnSale(
      concertId: json['concertId'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concertId': concertId,
      'imageUrl': imageUrl,
      'title': title,
      'date': date,
    };
  }
}

//TicketDetail
class TicketDetail {
  String imageUrl;
  String title;
  String place;
  String placeUrl;
  List<String> date;
  List<TicketProvider> ticketProvider;

  TicketDetail({
    required this.imageUrl,
    required this.title,
    required this.place,
    required this.placeUrl,
    required this.date,
    required this.ticketProvider,
  });

  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    var dateList = json['date'] as List;
    var ticketProviderList = json['ticketProvider'] as List;

    return TicketDetail(
      imageUrl: json['imageUrl'],
      title: json['title'],
      place: json['place'],
      placeUrl: json['placeUrl'],
      date: List<String>.from(dateList),
      ticketProvider: ticketProviderList
          .map((provider) => TicketProvider.fromJson(provider))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'place': place,
      'placeUrl': placeUrl,
      'date': date,
      'ticketProvider': ticketProvider.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketProvider {
  String ticketProvider;
  String url;
  List<TicketingSchedule2> ticketingSchedule;

  TicketProvider({
    required this.ticketProvider,
    required this.url,
    required this.ticketingSchedule,
  });

  factory TicketProvider.fromJson(Map<String, dynamic> json) {
    var scheduleList = json['ticketingSchedule'] as List;

    return TicketProvider(
      ticketProvider: json['ticketProvider'],
      url: json['url'],
      ticketingSchedule: scheduleList
          .map((schedule) => TicketingSchedule2.fromJson(schedule))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketProvider': ticketProvider,
      'url': url,
      'ticketingSchedule':
      ticketingSchedule.map((v) => v.toJson()).toList(),
    };
  }
}

class TicketingSchedule2 {
  String type;
  String date;
  String time;

  TicketingSchedule2({
    required this.type,
    required this.date,
    required this.time,
  });

  factory TicketingSchedule2.fromJson(Map<String, dynamic> json) {
    return TicketingSchedule2(
      type: json['type'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date,
      'time': time,
    };
  }
}
