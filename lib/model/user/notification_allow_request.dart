class NotificationAllowRequest {
  String isAllow;
  String target;
  String token;

  NotificationAllowRequest({
    required this.isAllow,
    required this.target,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'isAllow': isAllow,
      'target': target,
      'token': token,
    };
  }
}