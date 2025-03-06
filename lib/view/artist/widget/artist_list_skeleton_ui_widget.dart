import 'package:flutter/material.dart';
import 'package:newket/view/common/skeleton_widget.dart';

class ArtistListSkeletonUiWidget extends StatelessWidget {
  const ArtistListSkeletonUiWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
                height: 48,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    const SkeletonWidget(width: 48, height: 48, radius: 12),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40 - 48 - 12 - 16 - 95,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonWidget(width: 148, height: 22, radius: 8),
                          SizedBox(height: 4),
                          SkeletonWidget(width: 96, height: 16, radius: 8),
                        ],
                      ),
                    )
                  ]),
                  const SkeletonWidget(width: 95, height: 36, radius: 42)
                ])),
            const SizedBox(height: 12),
          ],
        ));
  }
}
