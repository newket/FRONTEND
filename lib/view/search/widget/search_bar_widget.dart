import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/view/search/screen/searching_screen.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Container(
        height: 44,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: pt_40),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('images/search/search.svg', height: 20, width: 20),
            const SizedBox(width: 12),
            Expanded(
                child: GestureDetector(
                    child: Text('아티스트 또는 공연 이름을 검색해보세요', style: b9_14Reg(f_50)),
                    onTap: () {
                      Get.to(
                        () => const SearchingScreen(keyword: ''),
                        fullscreenDialog: true,
                        transition: Transition.noTransition,
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
