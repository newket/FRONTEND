import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

class DateListPopupWidget extends StatelessWidget {
  final List<String> dateList;

  const DateListPopupWidget({super.key, required this.dateList});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 318,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const SizedBox(width: 115, height: 64),
            Text('공연 일시 정보', style: s1_16Semi(f_100)),
            const SizedBox(width: 71),
            GestureDetector(onTap: Get.back, child: const Icon(Icons.close, size: 24))
          ]),
          Container(
              constraints: const BoxConstraints(
                maxHeight: 400, // 최대 높이 400으로 제한
              ),
              child: ListView.builder(
                shrinkWrap: true, // 내용에 맞게 크기를 조정
                itemCount: dateList.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Container(
                      width: 278,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: f_5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            dateList[index],
                            textAlign: TextAlign.right,
                            style: b9_14Reg(f_70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8)
                  ]);
                },
              )),
          const SizedBox(height: 12)
        ]));
  }
}
