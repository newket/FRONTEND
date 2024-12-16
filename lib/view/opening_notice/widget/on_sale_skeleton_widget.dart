import 'package:flutter/material.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class OnSaleSkeletonWidget extends StatelessWidget {


  const OnSaleSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const SkeletonWidget(width: 244, height: 26),
        const SizedBox(height: 8),
        const SkeletonWidget(width: 192, height: 38),
        const SizedBox(height: 24),
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
       );
  }
}
