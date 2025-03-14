import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:get/route_manager.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/login/screen/login_screen.dart';

class BeforeLoginScreen extends StatefulWidget {
  const BeforeLoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BeforeLoginScreen();
}

class _BeforeLoginScreen extends State<BeforeLoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱바
      appBar: appBarBack(context, "미리보기"),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
          child:
      Image.asset('images/login/before_login.png', width: 241, fit: BoxFit.cover)),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width - 40,
        height: 88 + MediaQuery.of(context).viewPadding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 20, top: 12, left: 20, right: 20),
        child: ElevatedButton(
            onPressed: () async {
              //AmplitudeConfig.amplitude.logEvent('BeforeLogin->Login');
              Get.offAll(() => const LoginScreen());
              var storage = const FlutterSecureStorage();
              await storage.deleteAll();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              // 그림자 제거
              backgroundColor: pn_100,
              // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              // 상하 패딩
              shadowColor: Colors.transparent,
            ).copyWith(
              splashFactory: NoSplash.splashFactory,
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
