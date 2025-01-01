import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/common/app_bar_back.dart';

class MyFavoriteArtistScreen extends StatefulWidget {
  const MyFavoriteArtistScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyFavoriteArtistScreen();
}

class _MyFavoriteArtistScreen extends State<MyFavoriteArtistScreen> {
  late ArtistRepository artistRepository;
  List<Artist> myArtists = []; //선택한 아티스트들을 담을 리스트

  Future<void> _getFavoriteArtists(BuildContext context) async {
    final artists = await artistRepository.getFavoriteArtists(context);
    setState(() {
      myArtists = artists.artists;
    });
  }

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    _getFavoriteArtists(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록

        //배경
        backgroundColor: Colors.white,

        //앱바
        appBar: appBarBack(context, "나의 관심 아티스트"),

        //내용
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: myArtists.length,
                itemBuilder: (context, index) {
                  final myArtist = myArtists[index];
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                        height: 48,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                myArtist.name,
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16,
                                  color: f_100,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (myArtist.nicknames != null)
                                Text(
                                  myArtist.nicknames!,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: f_50,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                            ],
                          ),
                          GestureDetector(
                              child: SvgPicture.asset(
                                'images/opening_notice/notification_off.svg',
                                width: 16,
                                height: 16,
                                color: f_40,
                              ),
                              onTap: () async {
                                await artistRepository.deleteFavoriteArtist(myArtist.artistId, context);
                                _getFavoriteArtists(context);
                              })
                        ])),
                    const SizedBox(height: 16)
                  ]);
                })));
  }
}
