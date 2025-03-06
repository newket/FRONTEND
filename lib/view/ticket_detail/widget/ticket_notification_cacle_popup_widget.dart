import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_dto.dart';

class TicketNotificationCaclePopupWidget extends StatelessWidget {
  final VoidCallback onConfirm;

  const TicketNotificationCaclePopupWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      height: 198,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/artist/alarm.svg", height: 32, width: 32),
          const SizedBox(height: 8),
          Text(
            '티켓 알림을 해제할까요?',
            textAlign: TextAlign.center,
            style: t2_18Semi(f_100),
          ),
          const SizedBox(height: 8),
          Text(
            '알림을 해제하면 해당 티켓의 오픈 소식을 받을 수 없어요!',
            textAlign: TextAlign.center,
            style: c4_12Reg(f_60),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: f_5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 53, vertical: 13),
                  fixedSize: const Size(143, 48),
                  shadowColor: Colors.transparent,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  '아니오',
                  textAlign: TextAlign.center,
                  style: button2_14Semi(f_60),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pn_100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 13),
                  fixedSize: const Size(143, 48),
                  shadowColor: Colors.transparent,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  '네, 해제할게요',
                  textAlign: TextAlign.center,
                  style: button2_14Semi(Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
