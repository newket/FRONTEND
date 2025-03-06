import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonWidget({super.key, required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF1F1F1),
      highlightColor: const Color(0xFFF8F8F8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: Colors.grey),
      ),
    );
  }
}
