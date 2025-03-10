import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/app_bar_back_transparent.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class TicketDetailSkeletonScreen extends StatelessWidget {
  const TicketDetailSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarBackTransparent(context, '티켓 상세 보기'),
        extendBodyBehindAppBar: true, //body 위에 appbar
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          Container(
            width: double.infinity,
            height: 537,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0, -1),
                end: const Alignment(0, 1),
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  const Color(0x7C454545),
                  const Color(0x91AAAAAA),
                  Colors.white.withValues(alpha: 0.7),
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 143, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(14)),
                        ),
                        child: const ImageLoadingWidget(
                          width: 172,
                          height: 228,
                          radius: 12,
                          imageUrl: '',
                        ),
                      )),
                  const SizedBox(height: 46),
                  const SkeletonWidget(width: 350, height: 26, radius: 8),
                  const SizedBox(height: 4),
                  const SkeletonWidget(width: 157, height: 26, radius: 8),
                  const SizedBox(height: 25),
                  const SkeletonWidget(width: 127, height: 22, radius: 8),
                  const SizedBox(height: 4),
                  const SkeletonWidget(width: 222, height: 22, radius: 8),
                ],
              )),
        ],
        ),
          Container(color: f_5, height: 6),
          const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonWidget(width: 58, height: 24, radius: 8),
                    SizedBox(height: 8),
                    SkeletonWidget(width: 350, height: 48, radius: 8),
                    SizedBox(height: 4),
                    SkeletonWidget(width: 350, height: 48, radius: 8),
                    SizedBox(height: 40),
                    SkeletonWidget(width: 58, height: 24, radius: 8),
                  ]))]))
    );
  }
}
