import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';

class ImageLoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  final String imageUrl;

  const ImageLoadingWidget({
    super.key,
    this.width,
    this.height,
    required this.radius,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (context, url) {
          return Container(
            height: height,
            width: width,
            color: f_10,
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height,
            width: width,
            color: f_10,
          );
        },
        imageBuilder: (context, imageProvider) {
          return Image(
            image: imageProvider,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
