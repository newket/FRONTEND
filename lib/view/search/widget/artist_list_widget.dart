import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/search_result_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/search/widget/small_notification_button_widget.dart';

class ArtistListWidget extends StatefulWidget {
  final Artist artist;
  final bool isFavoriteArtist;
  final double toastBottom;

  const ArtistListWidget({super.key, required this.artist, required this.isFavoriteArtist, required this.toastBottom});

  @override
  State<StatefulWidget> createState() => _ArtistListWidget();
}

class _ArtistListWidget extends State<ArtistListWidget> {
  late ArtistRepository artistRepository;
  late final Artist artist;

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    artist = widget.artist;
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.artist.imageUrl ?? "",
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // 로딩이 완료되었을 때의 이미지
                          }
                          return Container(
                            height: 48,
                            width: 48,
                            color: f_10, // 로딩 중일 때의 배경색
                          );
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Container(
                            height: 48,
                            width: 48,
                            color: f_10, // 로딩 실패 시의 배경색
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40 - 48 - 12 - 16 - 95,
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
                  SmallNotificationButtonWidget(isFavoriteArtist: widget.isFavoriteArtist, artist: artist, toastBottom: widget.toastBottom,)
                ])),
            const SizedBox(height: 12),
          ],
        ));
  }
}
