class UserInfoResponse {
  String name;

  UserInfoResponse(this.name);

  UserInfoResponse.fromJson(Map<String, dynamic> json) :
        name = json['name'];
}