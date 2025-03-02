import 'package:flutter/material.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class ArtistNotificationSkeletonScreen extends StatelessWidget {
  const ArtistNotificationSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarBack(context, "알림 받는 아티스트 목록"),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 13,
              itemBuilder: (context, index) {
                return const Column(
                  children: [
                    Row(children: [
                      SkeletonWidget(width: 48, height: 48, radius: 12),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SkeletonWidget(width: 148, height: 22, radius: 8),
                        SizedBox(height: 4),
                        SkeletonWidget(width: 96, height: 16, radius: 8),
                      ]),
                    ]),
                    SizedBox(height: 12)
                  ],
                );
              })),
    );
  }
}
