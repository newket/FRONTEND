import 'package:flutter/material.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class ConcertSkeletonUIWidget extends StatelessWidget {


  const ConcertSkeletonUIWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 13),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonWidget(width: 50, height: 24),
              SkeletonWidget(width: 150, height: 34),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(
              10,
                  (index) {
                return Column(children: [
                  SkeletonWidget(width: MediaQuery.of(context).size.width - 40, height: 122),
                  const SizedBox(height: 12)
                ]);
              },
            ),
          )
        ],
      ),
    );
  }
}
