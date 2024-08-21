import 'package:flutter/cupertino.dart';
import 'package:newket/model/user_model.dart';
import 'package:newket/secure/auth_dio.dart';

class UserRepository {

  Future<UserInfoResponse> getUserInfoApi(BuildContext context) async {
    var dio = await authDio(context);

    final response = await dio.get(
        "/api/v1/users"
    );
    return UserInfoResponse.fromJson(response.data);
  }
}
