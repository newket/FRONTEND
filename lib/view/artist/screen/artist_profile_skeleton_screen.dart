import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/app_bar_back_transparent.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class ArtistProfileSkeletonScreen extends StatelessWidget {
  const ArtistProfileSkeletonScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarBackTransparent(context, '아티스트 프로필'),
        extendBodyBehindAppBar: true, //body 위에 appbar
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              Container(
                height: 394,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0, -1),
                    end: const Alignment(0, 1),
                    colors: [
                      const Color(0x81B5B5B5),
                      Colors.white.withValues(alpha: 0.73),
                      Colors.white.withValues(alpha: 0.89),
                      Colors.white
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 135),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                        ),
                        child: const SkeletonWidget(width: 120, height: 120, radius: 16)),
                    const SizedBox(height: 6),
                    const SkeletonWidget(width: 120, height: 34, radius: 8),
                    const SizedBox(height: 4),
                    const SkeletonWidget(width: 120, height: 15, radius: 8),
                    const SizedBox(height: 11),
                    const SkeletonWidget(width: 136, height: 44, radius: 42),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Row(children: [
            SizedBox(width: 20),
            SkeletonWidget(width: 63, height: 26, radius: 8),
          ]),
          const SizedBox(height: 8),
          SizedBox(
              height: 100,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Column(children: [
                          SkeletonWidget(width: 79, height: 79, radius: 12),
                          SizedBox(height: 4),
                          SkeletonWidget(width: 79, height: 17, radius: 8)
                        ]));
                  })),
          const SizedBox(height: 36),
          const Row(children: [
            SizedBox(width: 20),
            SkeletonWidget(width: 31, height: 24, radius: 8),
          ]),
          const SizedBox(height: 9),
          const Row(children: [
            SizedBox(width: 20),
            SkeletonWidget(width: 79, height: 22, radius: 8),
            SizedBox(width: 24),
            SkeletonWidget(width: 79, height: 22, radius: 8),
          ]),
          const SizedBox(height: 9),
          Container(height: 6, color: f_5),
          const SizedBox(height: 14),
          const Row(children: [SizedBox(width: 20), const SkeletonWidget(width: 350, height: 110, radius: 8)])
        ])));
  }
}
