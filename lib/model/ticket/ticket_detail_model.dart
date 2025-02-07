class TicketDetailResponse {
  String imageUrl;
  String title;
  String place;
  String placeUrl;
  List<String> date;
  List<ConcertTicketProvider> ticketProviders;
  List<TicketArtist> artists;
  bool isAvailableNotification;

  TicketDetailResponse(
      {required this.imageUrl,
        required this.title,
        required this.place,
        required this.placeUrl,
        required this.date,
        required this.ticketProviders,
        required this.artists,
        required this.isAvailableNotification});

  factory TicketDetailResponse.fromJson(Map<String, dynamic> json) {
    var dateList = json['date'] as List;
    var artistList = json['artists'] as List;
    var providerList = json['ticketProviders'] as List;

    return TicketDetailResponse(
        imageUrl: json['imageUrl'],
        title: json['title'],
        place: json['place'],
        placeUrl: json['placeUrl'],
        date: List<String>.from(dateList),
        ticketProviders: providerList.map((provider) => ConcertTicketProvider.fromJson(provider)).toList(),
        artists: artistList.map((artist) => TicketArtist.fromJson(artist)).toList(),
        isAvailableNotification: json['isAvailableNotification']);
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

class TicketArtist {
  String name;
  String? nicknames;
  int artistId;

  TicketArtist({
    required this.name,
    required this.nicknames,
    required this.artistId,
  });

  factory TicketArtist.fromJson(Map<String, dynamic> json) {
    return TicketArtist(
      name: json['name'],
      nicknames: json['nicknames'],
      artistId: json['artistId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nicknames': nicknames,
      'artistId': artistId,
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
  String dday;

  ConcertTicketingSchedule({required this.type, required this.date, required this.time, required this.dday});

  factory ConcertTicketingSchedule.fromJson(Map<String, dynamic> json) {
    return ConcertTicketingSchedule(type: json['type'], date: json['date'], time: json['time'], dday: json['dday']);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'date': date, 'time': time, 'dday': dday};
  }
}