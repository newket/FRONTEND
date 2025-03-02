import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

class WithdrawPopupWidget extends StatelessWidget {
  final VoidCallback onConfirm;

  const WithdrawPopupWidget({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      height: 252,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/mypage/warning.svg", height: 32, width: 32),
          const SizedBox(height: 8),
          Text(
            '잠시만요!\n정말로 탈퇴하시겠어요?',
            textAlign: TextAlign.center,
            style: t2_18Semi(f_100),
          ),
          const SizedBox(height: 12),
          Text(
            '탈퇴하시면 그동안 저장하신 관심 아티스트,\n티켓 오픈 알림 정보가 사라져요.',
            textAlign: TextAlign.center,
            style: c2_14Reg(f_60),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
                  minimumSize: Size.zero,
                  shadowColor: Colors.transparent,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  '아니오',
                  textAlign: TextAlign.center,
                  style: b9_14Reg(f_60),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => onConfirm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pn_100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 53, vertical: 13),
                  minimumSize: Size.zero,
                  shadowColor: Colors.transparent,
                ).copyWith(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  '네, 탈퇴할게요.',
                  textAlign: TextAlign.center,
                  style: b8_14Bold(Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
