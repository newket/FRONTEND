import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class MyPageSkeletonScreen extends StatelessWidget {
  const MyPageSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지', style: t2_18Semi(f_100)), backgroundColor: Colors.white, centerTitle: false),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
            child: SkeletonWidget(width: double.infinity, height: 80, radius: 8),
          ),
          Container(color: f_10, height: 2),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('알림 설정', style: s1_16Semi(f_100)),
                const SizedBox(height: 20),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SkeletonWidget(width: 148, height: 22, radius: 8),
                    SizedBox(height: 4),
                    SkeletonWidget(width: 96, height: 16, radius: 8),
                  ]),
                  SkeletonWidget(width: 44, height: 24, radius: 8),
                ]),
                const SizedBox(height: 24),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SkeletonWidget(width: 148, height: 22, radius: 8),
                    SizedBox(height: 4),
                    SkeletonWidget(width: 96, height: 16, radius: 8),
                  ]),
                  SkeletonWidget(width: 44, height: 24, radius: 8),
                ])
              ])),
          Container(color: f_10, height: 2),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonWidget(width: 96, height: 22, radius: 8),
                SizedBox(height: 20),
                SkeletonWidget(width: 96, height: 22, radius: 8),
                SizedBox(height: 20),
                SkeletonWidget(width: 48, height: 22, radius: 8),
                SizedBox(height: 20),
                SkeletonWidget(width: 48, height: 22, radius: 8),
                SizedBox(height: 20),
                SkeletonWidget(width: 48, height: 22, radius: 8),
              ],
            ),
          )
        ],
      ),
    );
  }
}
