import 'package:flutter/cupertino.dart';
import 'package:newket/secure/auth_dio.dart';

class UserRepository {

  Future<String> getUserApi(BuildContext context) async {
    var dio = await authDio(context);

    final response = await dio.get(
        "/api/v1/users"
    );
    print(response.statusCode);
    print("user아이디:${response.data}");
    return response.data.toString();
  }
}
