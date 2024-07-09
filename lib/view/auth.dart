import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/secure/token_storage.dart';
import 'package:newket/repository/auth_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {

  late AuthRepository authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository(SecureStorage(storage: FlutterSecureStorage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("NEWKET",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 40,
                    color: Color(0xff5A4EF6),
                    fontWeight: FontWeight.w900)),
            Text("뉴켓에 오신것을 환영합니다.",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w200)),
            IconButton(
                icon: Image.asset("images/login/kakao_login_medium_wide.png"),
                onPressed: () async {
                  await authRepository.kakaoLoginApi();
                })
          ],
        )));
  }
}
