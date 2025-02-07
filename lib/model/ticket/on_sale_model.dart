class OnSaleResponse {
  int totalNum;
  List<Concert> concerts;

  OnSaleResponse({required this.totalNum, required this.concerts});

  factory OnSaleResponse.fromJson(Map<String, dynamic> json) {
    var concertList = json['concerts'] as List;
    List<Concert> concertItems = concertList.map((i) => Concert.fromJson(i)).toList();

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

class Concert {
  int concertId;
  String imageUrl;
  String title;
  String date;

  Concert({
    required this.concertId,
    required this.imageUrl,
    required this.title,
    required this.date,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
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