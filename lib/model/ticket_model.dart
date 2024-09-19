// OpeningNoticeResponse
class OpeningNoticeResponse {
  int totalNum;
  String artistName;
  List<Concert> concerts;

  OpeningNoticeResponse({required this.totalNum, required this.artistName, required this.concerts});

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

// OnSale
class OnSaleResponse {
  int totalNum;
  List<ConcertOnSale> concerts;

  OnSaleResponse({required this.totalNum, required this.concerts});

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
  List<ConcertTicketProvider> ticketProviders;

  TicketDetail({
    required this.imageUrl,
    required this.title,
    required this.place,
    required this.placeUrl,
    required this.date,
    required this.ticketProviders,
  });

  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    var dateList = json['date'] as List;
    var providerList = json['ticketProviders'] as List;

    return TicketDetail(
      imageUrl: json['imageUrl'],
      title: json['title'],
      place: json['place'],
      placeUrl: json['placeUrl'],
      date: List<String>.from(dateList),
      ticketProviders: providerList.map((provider) => ConcertTicketProvider.fromJson(provider)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'place': place,
      'placeUrl': placeUrl,
      'date': date,
      'ticketProviders': ticketProviders.map((v) => v.toJson()).toList()
    };
  }
}

class ConcertTicketProvider {
  String ticketProvider;
  String url;
  List<ConcertTicketingSchedule> ticketingSchedules;

  ConcertTicketProvider({
    required this.ticketProvider,
    required this.url,
    required this.ticketingSchedules,
  });

  factory ConcertTicketProvider.fromJson(Map<String, dynamic> json) {
    var scheduleList = json['ticketingSchedules'] as List;

    return ConcertTicketProvider(
      ticketProvider: json['ticketProvider'],
      url: json['url'],
      ticketingSchedules: scheduleList.map((schedule) => ConcertTicketingSchedule.fromJson(schedule)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketProvider': ticketProvider,
      'url': url,
      'ticketingSchedule': ticketingSchedules.map((v) => v.toJson()).toList(),
    };
  }
}

class ConcertTicketingSchedule {
  String type;
  String date;
  String time;

  ConcertTicketingSchedule({
    required this.type,
    required this.date,
    required this.time,
  });

  factory ConcertTicketingSchedule.fromJson(Map<String, dynamic> json) {
    return ConcertTicketingSchedule(
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

//search
class SearchTicketResponse {
  OpeningNoticeResponse openingNotice;
  OnSaleResponse onSale;

  SearchTicketResponse({required this.openingNotice, required this.onSale});

  factory SearchTicketResponse.fromJson(Map<String, dynamic> json) {
    return SearchTicketResponse(
      openingNotice: OpeningNoticeResponse.fromJson(json['openingNotice'] as Map<String, dynamic>),
      onSale: OnSaleResponse.fromJson(json['onSale'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openingNotice': openingNotice.toJson(),
      'onSale': onSale.toJson(),
    };
  }
}
