import 'dart:ffi';

class UserInfoResponse {
  String provider;
  String name;
  String email;

  UserInfoResponse(this.provider, this.name, this.email);

  UserInfoResponse.fromJson(Map<String, dynamic> json)
      : provider = json['provider'],
        name = json['name'],
        email = json['email'];
}

class UserDeviceToken {
  String token;

  UserDeviceToken(this.token);

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "token":token
    };
  }
}

class NotificationAllow {
  bool artistNotification;
  bool ticketNotification;

  NotificationAllow(this.artistNotification, this.ticketNotification);

  NotificationAllow.fromJson(Map<String, dynamic> json)
      : artistNotification = json['artistNotification'],
        ticketNotification = json['ticketNotification'];
}
