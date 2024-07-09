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

class ReissueRequest{
  String refreshToken;

  ReissueRequest(this.refreshToken);
  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "refreshToken":refreshToken
    };
  }
}

class ReissueResponse {
  String accessToken;
  String refreshToken;

  ReissueResponse(this.accessToken,this.refreshToken);

  ReissueResponse.fromJson(Map<String, dynamic> json) :
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}