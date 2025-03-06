import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class MyTicketSkeletonScreen extends StatelessWidget {
  const MyTicketSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(height: 16),
                  Row(
                      children: List.generate(5, (index) {
                    return const Row(children: [
                      Column(children: [
                        SkeletonWidget(width: 60, height: 60, radius: 16),
                        SizedBox(height: 4),
                        SkeletonWidget(width: 48, height: 16, radius: 16),
                      ]),
                      SizedBox(width: 8)
                    ]);
                  })),
                  const SizedBox(height: 38),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(),
                    SkeletonWidget(width: 51, height: 22, radius: 8),
                    SizedBox(),
                    SkeletonWidget(width: 51, height: 22, radius: 8),
                    SizedBox()
                  ]),
                  const SizedBox(height: 29),
                  const SkeletonWidget(width: double.infinity, height: 36, radius: 8),
                  const SizedBox(height: 20),
                  Column(
                      children: List.generate(4, (index) {
                    return const Column(children: [
                      SkeletonWidget(width: double.infinity, height: 110, radius: 8),
                      SizedBox(height: 12),
                    ]);
                  }))
                ]))));
  }
}
