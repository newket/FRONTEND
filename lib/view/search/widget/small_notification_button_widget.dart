import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';

class SmallNotificationButtonWidget extends StatelessWidget {
  const SmallNotificationButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 95,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: pn_100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(42),
          ),
        ),
        child: Row(children: [
          SvgPicture.asset(
            'images/opening_notice/notification_on.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 4),
          const Text(
            "알림 받기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.36,
            ),
          ),
        ]));
  }
}
