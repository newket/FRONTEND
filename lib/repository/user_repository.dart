import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/secure/token_storage.dart';

class UserRepository {
  final Dio dio = Dio();
  final SecureStorage storage;

  UserRepository(this.storage) {
    dio.options.baseUrl = dotenv.get("BASE_URL");
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  Future<String> getUserApi() async {
    String accessToken = await storage.readAccessToken();

    final response = await dio.get(
        "/api/v1/users",
        options: Options(
            headers: {
              "Authorization": "Bearer ${accessToken}",
            }
        )
    );
    print(response.statusCode);
    print("user아이디:${response.data}");
    return response.data.toString();
  }
}
