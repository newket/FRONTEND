import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/view/search/screen/searching_screen.dart';

class SearchingBarWidget extends StatelessWidget {
  final String? keyword;
  final String? hintText;

  const SearchingBarWidget({super.key, this.keyword, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  AmplitudeConfig.amplitude.logEvent('Back');
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24, color: f_90)),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width - 68,
              decoration: ShapeDecoration(
                color: pn_05,
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
                          child: Text(
                            keyword ?? '아티스트 또는 공연 이름을 검색해보세요',
                            style: (keyword?.isNotEmpty ?? false) ? c1_14Med(f_80) : b9_14Reg(f_50),
                          ),
                          onTap: () => {
                                Get.to(
                                  SearchingScreen(keyword: keyword ?? ''),
                                  fullscreenDialog: true,
                                  transition: Transition.noTransition,
                                )
                              })),
                  (keyword?.isNotEmpty ?? false)
                      ? GestureDetector(
                          child: SvgPicture.asset('images/search/close-circle.svg', height: 24, width: 24),
                          onTap: () => {
                            Get.to(
                              const SearchingScreen(),
                              fullscreenDialog: true,
                              transition: Transition.noTransition,
                            )
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ));
  }
}
