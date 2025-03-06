import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/view/common/image_loading_widget.dart';

class ArtistHorizontalListWidget extends StatelessWidget {
  final ArtistDto artist;

  const ArtistHorizontalListWidget({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          ImageLoadingWidget(width: 79, height: 79, radius: 12, imageUrl: artist.imageUrl ?? ''),
          const SizedBox(height: 4),
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: artist.name,
                style: const TextStyle(
                  color: f_70,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.40,
                  letterSpacing: -0.36,
                )),
          )
        ],
      ),
    );
  }
}
