import 'package:newket/model/artist/artist_dto.dart';

class TicketDetailResponse {
  final String imageUrl;
  final String title;
  final String place;
  final String placeUrl;
  final String date;
  final List<String> dateList;
  final List<TicketSaleSchedules> ticketSaleSchedules;
  final List<Price> prices;
  final LineupImage? lineup;
  final List<ArtistDto> artists;
  final bool isAvailableNotification;

  TicketDetailResponse({
    required this.imageUrl,
    required this.title,
    required this.place,
    required this.placeUrl,
    required this.date,
    required this.dateList,
    required this.ticketSaleSchedules,
    required this.prices,
    this.lineup,
    required this.artists,
    required this.isAvailableNotification,
  });

  factory TicketDetailResponse.fromJson(Map<String, dynamic> json) {
    return TicketDetailResponse(
      imageUrl: json['imageUrl'],
      title: json['title'],
      place: json['place'],
      placeUrl: json['placeUrl'],
      date: json['date'],
      dateList: List<String>.from(json['dateList']),
      ticketSaleSchedules:
          (json['ticketSaleSchedules'] as List).map((item) => TicketSaleSchedules.fromJson(item)).toList(),
      prices: (json['prices'] as List).map((item) => Price.fromJson(item)).toList(),
      lineup: json['lineup'] != null ? LineupImage.fromJson(json['lineup']) : null,
      artists: (json['artists'] as List).map((item) => ArtistDto.fromJson(item)).toList(),
      isAvailableNotification: json['isAvailableNotification'],
    );
  }
}

class TicketSaleSchedules {
  final String type;
  final String date;
  final List<TicketSaleUrl> ticketSaleUrls;

  TicketSaleSchedules({
    required this.type,
    required this.date,
    required this.ticketSaleUrls,
  });

  factory TicketSaleSchedules.fromJson(Map<String, dynamic> json) {
    return TicketSaleSchedules(
      type: json['type'],
      date: json['date'],
      ticketSaleUrls: (json['ticketSaleUrls'] as List).map((item) => TicketSaleUrl.fromJson(item)).toList(),
    );
  }
}

class TicketSaleUrl {
  final String providerImageUrl;
  final String ticketProvider;
  final String url;

  TicketSaleUrl({
    required this.providerImageUrl,
    required this.ticketProvider,
    required this.url,
  });

  factory TicketSaleUrl.fromJson(Map<String, dynamic> json) {
    return TicketSaleUrl(
      providerImageUrl: json['providerImageUrl'],
      ticketProvider: json['ticketProvider'],
      url: json['url'],
    );
  }
}

class Price {
  final String type;
  final String price;

  Price({
    required this.type,
    required this.price,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      type: json['type'],
      price: json['price'],
    );
  }
}

class LineupImage {
  final String message;
  final String imageUrl;

  LineupImage({
    required this.message,
    required this.imageUrl,
  });

  factory LineupImage.fromJson(Map<String, dynamic> json) {
    return LineupImage(
      message: json['message'],
      imageUrl: json['imageUrl'],
    );
  }
}
