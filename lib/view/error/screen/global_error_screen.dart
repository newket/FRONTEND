import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

class GlobalErrorScreen extends StatefulWidget {
  final Future<void> Function()? onRetry;

  const GlobalErrorScreen({super.key, this.onRetry});

  @override
  State<GlobalErrorScreen> createState() => _GlobalErrorScreenState();
}

class _GlobalErrorScreenState extends State<GlobalErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: f_90,
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: [
          Image.asset("images/error/global.png", height: 176, width: 176),
          const SizedBox(height: 20),
          Text('페이지에 오류가 발생했어요', style: t1_20Semi(f_100)),
          const SizedBox(height: 8),
          Text('다시 시도해주세요', style: b9_14Reg(f_100)),
        ],
      )),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width - 40,
        height: 88 + MediaQuery.of(context).viewPadding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 20, top: 12, left: 20, right: 20),
        child: ElevatedButton(
            onPressed: widget.onRetry,
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
            child: Text(
              '새로고침',
              textAlign: TextAlign.center,
              style: b1_16Semi(Colors.white),
            )),
      ),
    );
  }
}
