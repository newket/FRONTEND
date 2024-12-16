import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  final double width;
  final double height;
  const SkeletonWidget({
    super.key,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(240, 240, 240, 1),
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey),
      ),
    );
  }
}