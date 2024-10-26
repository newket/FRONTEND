class SocialLoginRequest {
  String accessToken;

  SocialLoginRequest(this.accessToken);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"accessToken": accessToken};
  }
}

class SocialLoginAppleRequest {
  String socialId;

  SocialLoginAppleRequest(this.socialId);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"socialId": socialId};
  }
}

class SocialLoginResponse {
  String accessToken;
  String refreshToken;

  SocialLoginResponse(this.accessToken, this.refreshToken);

  SocialLoginResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}

class ReissueRequest {
  String refreshToken;

  ReissueRequest(this.refreshToken);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"refreshToken": refreshToken};
  }
}

class ReissueResponse {
  String accessToken;
  String refreshToken;

  ReissueResponse(this.accessToken, this.refreshToken);

  ReissueResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}

class SignUpRequest {
  String accessToken;

  SignUpRequest(this.accessToken);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"accessToken": accessToken};
  }
}

class SignUpAppleRequest {
  String name;
  String email;
  String socialId;

  SignUpAppleRequest({required this.name, required this.email, required this.socialId});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"name": name, "email": email, "socialId": socialId};
  }
}

class WithDrawApple {
  String authorizationCode;

  WithDrawApple(this.authorizationCode);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"authorizationCode": authorizationCode};
  }
}
