class ConcertIds{
  List<int> concertIds;

  ConcertIds(this.concertIds);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"concertIds": concertIds};
  }
}

class Notifications{
  List<Notification> notifications;

  NotificationsV1({required this.notifications});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    var notificationList = json['notifications'] as List;
    List<Notification> notificationItems = notificationList.map((i) => Notification.fromJson(i)).toList();

    return NotificationsV1(
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