import 'package:flutter/material.dart';
import 'package:newket/component/common/app_bar_back.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/constant/colors.dart';

class MyFavoriteArtistV2 extends StatefulWidget {
  const MyFavoriteArtistV2({super.key});

  @override
  State<StatefulWidget> createState() => _MyFavoriteArtistV2();
}

class _MyFavoriteArtistV2 extends State<MyFavoriteArtistV2> {
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
                              child: const Text(
                                "관심 아티스트에서 제거",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 12,
                                  color: f_60,
                                  fontWeight: FontWeight.w500,
                                ),
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
