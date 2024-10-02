import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:get/route_manager.dart';
import 'package:newket/view/tapbar/tap_bar.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  late AuthRepository authRepository;
  String? userInfo = ""; //user의 정보를 저장하기 위한 변수
  static final storage = new FlutterSecureStorage();

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    userInfo = await storage.read(key: "ACCESS_TOKEN");

    //user의 정보가 있다면 바로 홈으로 넝어가게 합니다.
    if (userInfo != null) {
      Get.offAll(const TapBar());
    }
  }

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    //비동기로 flutter secure storage 정보를 불러오는 작업.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/onboarding/background.png"), // 배경 이미지
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent, // 배경색을 투명으로 설정,

            //내용
            body: Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //타이틀
                const Column(
                  children: [
                    SizedBox(height: 92),
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
                          image: AssetImage("images/onboarding/logo_title.png"),
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
                Column(
                  children: [
                    //카카오 로그인
                    IconButton(
                        icon: Image.asset("images/onboarding/kakao_login_large_wide.png",width: 320),
                        onPressed: () async {
                          await authRepository.kakaoLoginApi();
                        }),

                    const SizedBox(height: 60),
                  ],
                )
              ],
            ))));
  }
}
