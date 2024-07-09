class SocialLoginRequest {
  String accessToken;

  SocialLoginRequest(this.accessToken);

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "accessToken":accessToken
    };
  }
}

class SocialLoginResponse {
  String accessToken;
  String refreshToken;

  SocialLoginResponse(this.accessToken,this.refreshToken);

  SocialLoginResponse.fromJson(Map<String, dynamic> json) :
    accessToken = json['accessToken'],
    refreshToken = json['refreshToken'];
}