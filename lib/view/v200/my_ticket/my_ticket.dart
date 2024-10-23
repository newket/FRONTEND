import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v200/login/before_login.dart';
import 'package:newket/view/v200/mypage/mypage.dart';

class MyTicketV2 extends StatefulWidget {
  const MyTicketV2({super.key});

  @override
  State<StatefulWidget> createState() => _MyTicketV2();
}

class _MyTicketV2 extends State<MyTicketV2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
      body: Container(
        width: 390,
        height: 547,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.00, 1.00),
            end: Alignment(0, -1),
            colors: [Colors.white, Color(0xFF796FFF), Color(0xFF9F97FF), Color(0xFFE0DDFF)],
          ),
        ),
        child: Column(
          children: [
            Text(
              '김뉴켓님,\n',
              style: TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),

            Text(
              '박재범',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '의 티켓,\n확인해 볼까요?',
              style: TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
