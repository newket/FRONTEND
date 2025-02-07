import 'dart:ffi';

class AutocompleteResponse {
  List<Artist> artists;
  List<Ticket> tickets;

  AutocompleteResponse({required this.artists ,required this.tickets});

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    var artistList = json['artists'] as List;
    List<Artist> artistItems = artistList.map((i) => Artist.fromJson(i)).toList();
    var ticketList = json['tickets'] as List;
    List<Ticket> ticketItems = ticketList.map((i)=>Ticket.fromJson(i)).toList();

    return AutocompleteResponse(
      artists: artistItems,
      tickets: ticketItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artists': artists.map((v) => v.toJson()).toList(),
      'tickets': tickets.map((v) => v.toJson()).toList(),
    };
  }
}

class Artist {
  int artistId;
  String name;
  String? subName;

  Artist({
    required this.artistId,
    required this.name,
    required this.subName,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['artistId'],
      name: json['name'],
      subName: json['subName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'name': name,
      'subName': subName,
    };
  }
}

class Ticket {
  int concertId;
  String title;

  Ticket({
    required this.concertId,
    required this.title,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      concertId: json['concertId'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'concertId': concertId,
      'title': title,
    };
  }
}