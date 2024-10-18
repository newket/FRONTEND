class ConcertIds{
  List<int> concertIds;

  ConcertIds(this.concertIds);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"concertIds": concertIds};
  }
}

class Notifications{
  List<Notification> notifications;

  Notifications({required this.notifications});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    var notificationList = json['notifications'] as List;
    List<Notification> notificationItems = notificationList.map((i) => Notification.fromJson(i)).toList();

    return Notifications(
      notifications: notificationItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((v) => v.toJson()).toList(),
    };
  }
}

class Notification{
  String title;
  String content;

  Notification({
    required this.title,
    required this.content,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {

    return Notification(
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}