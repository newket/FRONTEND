import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';

class ImageLoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final String imageUrl;

  const ImageLoadingWidget({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child; // 로딩이 완료되었을 때의 이미지
          }
          return Container(
            height: height,
            width: width,
            color: f_10, // 로딩 중일 때의 배경색
          );
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Container(
            height: height,
            width: width,
            color: f_10, // 로딩 실패 시의 배경색
          );
        },
      ),
    );
  }
}
