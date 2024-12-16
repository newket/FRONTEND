import 'package:flutter/material.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:get/get.dart';
import 'package:newket/view/tapbar/screen/tab_bar_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
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
      Image.asset("images/login/login.png", width: double.infinity, height: double.infinity, fit: BoxFit.cover),
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
                      Image.asset("images/login/logo.png", height: 37, width: 37),
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
                  GestureDetector(
                      child: Image.asset("images/login/apple_login.png", width: 350),
                      onTap: () async {
                        await authRepository.appleLoginApi();
                      }),
                  const SizedBox(height: 12),
                  //카카오 로그인
                  GestureDetector(
                      child: Image.asset("images/login/kakao_login.png", width: 350),
                      onTap: () async {
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
                        Get.offAll(const TabBarScreen());
                      }),
                  const SizedBox(height: 60),
                ],
              )
            ],
          )))
    ]);
  }
}
