import 'package:flutter/material.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class TicketSkeletonWidget extends StatelessWidget {


  const TicketSkeletonWidget({
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
              SkeletonWidget(width: 43, height: 22, radius: 8),
              SkeletonWidget(width: 131, height: 34, radius: 8),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(
              10,
                  (index) {
                return Column(children: [
                  SkeletonWidget(width: MediaQuery.of(context).size.width - 40, height: 122, radius: 8),
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
