import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';

void showToast(double bottom, String title, String content, BuildContext context) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: bottom, // Toast 위치 조정
      left: 20, // 화면의 가운데 정렬
      child: Material(color: Colors.transparent, child: ToastWidget(title: title, content: content)),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // 5초 후에 Toast를 자동으로 제거
  Future.delayed(const Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}

class ToastWidget extends StatelessWidget {
  final String title;
  final String content;

  const ToastWidget({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: ShapeDecoration(
        color: f_80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('images/mypage/checkbox.svg', height: 24, width: 24),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
                softWrap: true, // 줄바꿈 허용
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  color: b_400,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
                softWrap: true, // 줄바꿈 허용
                overflow: TextOverflow.visible,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
