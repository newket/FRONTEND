import 'package:flutter/material.dart';
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
    authRepository = AuthRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/login/background.png"), // 배경 이미지
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent, // 배경색을 투명으로 설정,
            appBar: AppBar(backgroundColor: Colors.transparent),

            //내용
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(height: 0),

                //타이틀
                const Column(
                  children: [
                    Text("원하는 티켓을 내손에!",
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("images/login/logo_title.png"),
                          width: 50,
                        ),
                        SizedBox(width: 5),
                        Text("NEWKET",
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 50,
                                color: Colors.white,
                                fontWeight: FontWeight.w800))
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 0),

                //카카오 로그인
                IconButton(
                    icon: Image.asset("images/login/kakao_login_large_wide.png",width: 320),
                    onPressed: () async {
                      await authRepository.kakaoLoginApi();
                    }),

                const SizedBox(height: 0),

              ],
            ))));
  }
}
