import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:get/route_manager.dart';
import 'package:newket/theme/Colors.dart';
import 'package:newket/view/v200/login/login.dart';

class BeforeLogin extends StatefulWidget {
  const BeforeLogin({super.key});

  @override
  State<StatefulWidget> createState() => _BeforeLogin();
}

class _BeforeLogin extends State<BeforeLogin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱바
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              AmplitudeConfig.amplitude.logEvent('BeforeLogin->Back');
              Navigator.pop(context); //뒤로가기
            },
            color: f_90,
            icon: const Icon(Icons.keyboard_arrow_left)),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "로그인 후 기능 미리 보기",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            color: f_90,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'images/v2/login/before_login.png',
            width: 241,
          )
        ],
      )),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width - 40,
        height: 122,
        padding: const EdgeInsets.only(bottom: 54, top: 12, left: 20, right: 20),
        child: ElevatedButton(
            onPressed: () async {
              AmplitudeConfig.amplitude.logEvent('BeforeLogin->Login');
              Get.offAll(const LoginV2());
            },
            style: ElevatedButton.styleFrom(
              elevation: 0, // 그림자 제거
              backgroundColor: pn_100, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16), // 상하 패딩
              //fixedSize: Size(MediaQuery.of(context).size.width - 40, 56), // 고정 크기
            ),
            child: const Text(
              '로그인 하러가기',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, color: Colors.white),
            )),
      ),
    );
  }
}
