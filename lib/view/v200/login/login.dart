import 'package:flutter/material.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:get/get.dart';
import 'package:newket/view/v200/tapbar/tab_bar.dart';


class LoginV2 extends StatefulWidget {
  const LoginV2({super.key});

  @override
  State<StatefulWidget> createState() => _LoginV2();
}

class _LoginV2 extends State<LoginV2> {
  late AuthRepository authRepository;
  String? userInfo = ""; //user의 정보를 저장하기 위한 변수

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset("images/v2/login/login.png", fit: BoxFit.cover),
      // 다른 위젯들
      Scaffold(
          backgroundColor: Colors.transparent, // 배경색을 투명으로 설정,
          //내용
          body: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //타이틀
              Column(
                children: [
                  const SizedBox(height: 92),
                  const Text("원하는 티켓을 내손에!",
                      style: TextStyle(
                          fontFamily: 'Pretendard', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/v2/login/logo.png", height: 37, width: 37),
                      const SizedBox(width: 5),
                      const Text("NEWKET",
                          style: TextStyle(
                              fontFamily: 'Pretendard', fontSize: 40, color: Colors.white, fontWeight: FontWeight.w800))
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  //애플 로그인
                  IconButton(
                      icon: Image.asset("images/v2/login/applelogin.png", width: 320),
                      onPressed: () async {
                        await authRepository.appleLoginApi();
                      }),
                  //카카오 로그인
                  IconButton(
                      icon: Image.asset("images/v1/onboarding/kakao_login_large_wide.png", width: 320),
                      onPressed: () async {
                        await authRepository.kakaoLoginApi();
                      }),
                  IconButton(
                      icon: const Text(
                        '로그인 없이 둘러볼래요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: f_70,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () async {
                        Get.offAll(const TabBarV2());
                      }),
                  const SizedBox(height: 60),
                ],
              )
            ],
          )))
    ]);
  }
}
