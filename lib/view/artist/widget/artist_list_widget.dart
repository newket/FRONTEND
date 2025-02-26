import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/search/widget/small_notification_button_widget.dart';

class ArtistListWidget extends StatefulWidget {
  final ArtistDto artist;
  final bool isFavoriteArtist;
  final double toastBottom;
  final VoidCallback? onConfirm;

  const ArtistListWidget({super.key,
    required this.artist,
    required this.isFavoriteArtist,
    required this.toastBottom,
    this.onConfirm});

  @override
  State<StatefulWidget> createState() => _ArtistListWidget();
}

class _ArtistListWidget extends State<ArtistListWidget> {
  @override
  void initState() {
    super.initState();
  }

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
                    ImageLoadingWidget(width: 48, height: 48, radius: 12, imageUrl: widget.artist.imageUrl ?? ""),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 40 - 48 - 12 - 16 - 95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: widget.artist.name,
                              style: b8_14Med(f_100),
                            ),
                          ),
                          if (widget.artist.subName != null)
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.artist.subName!,
                                style: c4_12Reg(f_40),
                              ),
                            ),
                        ],
                      ),
                    )
                  ]),
                  SmallNotificationButtonWidget(
                    isFavoriteArtist: widget.isFavoriteArtist,
                    artist: widget.artist,
                    toastBottom: widget.toastBottom,
                    onConfirm: () => widget.onConfirm!(),
                  )
                ])),
            const SizedBox(height: 12),
          ],
        ));
  }
}
