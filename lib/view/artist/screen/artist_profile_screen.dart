import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_profile_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/artist/screen/ImagePreviewScreen.dart';
import 'package:newket/view/artist/screen/artist_profile_skeleton_screen.dart';
import 'package:newket/view/artist/widget/artist_horizontal_list_widget.dart';
import 'package:newket/view/artist/widget/medium_notification_button_widget.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/concert_list/widget/on_sale_widget.dart';
import 'package:newket/view/concert_list/widget/opening_notice_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  final int artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  State<StatefulWidget> createState() => _ArtistProfileScreen();
}

class _ArtistProfileScreen extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  ArtistRepository artistRepository = ArtistRepository();
  late TabController controller;
  late Future repository;
  late Timer skeletonTimer;
  bool showSkeleton = false;
  bool isFavoriteArtist = false;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    repository = artistRepository.getArtistProfile(widget.artistId);
    controller = TabController(length: 2, vsync: this);

    _loadFavoriteStatus();

    // 200ms 후 Skeleton UI 표시
    skeletonTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        showSkeleton = true;
      });
    });
    _scrollController.addListener(_scrollListener);
    controller.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  void _loadFavoriteStatus() async {
    final favoriteStatus = await artistRepository.getIsFavoriteArtist(widget.artistId, context);
    if (!mounted) return;
    setState(() {
      isFavoriteArtist = favoriteStatus;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _loadFavoriteStatus();
      routeObserver.unsubscribe(this);
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    skeletonTimer.cancel();
    controller.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: repository,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) &&
              showSkeleton) {
            return const ArtistProfileSkeletonScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ArtistProfileSkeletonScreen();
          }
          ArtistProfileResponse response = snapshot.data!;
          return NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: SliverAppBar(
                      centerTitle: true,
                      title: Text('아티스트 프로필', style: s1_16Semi((_scrollPosition == 0) ? Colors.white : f_100)),
                      backgroundColor: (_scrollPosition == 0) ? Colors.transparent : Colors.white,
                      scrolledUnderElevation: 0,
                      elevation: 0.0,
                      leading: IconButton(
                        onPressed: () {
                          AmplitudeConfig.amplitude.logEvent('Back');
                          Navigator.pop(context);
                        },
                        color: (_scrollPosition == 0) ? Colors.white : f_100,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      floating: true,
                      pinned: true,
                      primary: true,
                      forceElevated: innerBoxIsScrolled,
                      expandedHeight: null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ImageLoadingWidget(
                              width: MediaQuery.of(context).size.width,
                              height: 394,
                              radius: 0,
                              imageUrl: response.info.imageUrl ?? '',
                            ),
                            Container(
                              height: 394,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(0, -1),
                                  end: const Alignment(0, 1),
                                  colors: [
                                    const Color(0x81B5B5B5),
                                    Colors.white.withValues(alpha: 0.73),
                                    Colors.white.withValues(alpha: 0.89),
                                    Colors.white
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 135),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (_, __, ___) =>
                                                ImagePreviewScreen(imageUrl: response.info.imageUrl ?? ''),
                                          ),
                                        );
                                        AmplitudeConfig.amplitude
                                            .logEvent('ImagePreview(artist: ${response.info.name})');
                                      },
                                      child: ImageLoadingWidget(
                                        width: 120,
                                        height: 120,
                                        radius: 16,
                                        imageUrl: response.info.imageUrl ?? '',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(text: response.info.name, style: h2_24Semi(f_100)),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(text: response.info.subName ?? '', style: b9_14Reg(f_60)),
                                  ),
                                  const SizedBox(height: 8),
                                  MediumNotificationButtonWidget(
                                      isFavoriteArtist: isFavoriteArtist, artist: response.info),
                                ],
                              ),
                            ),
                          ],
                        ),
                        response.members.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(children: [
                                    const SizedBox(width: 20),
                                    Text("멤버", style: s1_16Semi(f_100)),
                                    const SizedBox(width: 8),
                                    Text("${response.members.length.toString()}명", style: b7_16Reg(f_50))
                                  ]),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: response.members.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => ArtistProfileScreen(
                                                                  artistId: response.members[index].artistId)));
                                                      AmplitudeConfig.amplitude.logEvent(
                                                          'ArtistProfile(artist: ${response.members[index].name})');
                                                    },
                                                    child:
                                                        ArtistHorizontalListWidget(artist: response.members[index])));
                                          })),
                                ],
                              )
                            : const SizedBox(),
                        response.groups.isNotEmpty
                            ? Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(children: [
                                    const SizedBox(width: 20),
                                    Text("소속 그룹", style: s1_16Semi(f_100)),
                                    const SizedBox(width: 8),
                                    Text("${response.groups.length.toString()}개", style: b7_16Reg(f_50))
                                  ]),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: response.groups.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ArtistProfileScreen(
                                                                artistId: response.groups[index].artistId),
                                                          ));
                                                      AmplitudeConfig.amplitude.logEvent(
                                                          'ArtistProfile(artist: ${response.groups[index].name})');
                                                    },
                                                    child: ArtistHorizontalListWidget(artist: response.groups[index])));
                                          })),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ];
              },
              body: Column(
                children: [
                  SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top - 24),
                  Row(children: [const SizedBox(width: 20), Text("티켓", style: s1_16Semi(f_100))]),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    height: 44,
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      controller: controller,
                      isScrollable: true,
                      // 글씨 크기에 맞춰 탭 크기 조절
                      padding: const EdgeInsets.only(left: 8),
                      labelPadding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 14),
                      //간격
                      tabs: [
                        Tab(
                            child: Text("판매 중  ${response.openingNotice.totalNum + response.onSale.totalNum}개  ",
                                style: b8_14Med(controller.index == 0 ? pn_100 : f_40))),
                        Tab(
                            child: Text(
                          "판매 종료  ${response.afterSale.totalNum}개  ",
                          style: b8_14Med(controller.index == 1 ? pn_100 : f_40),
                        ))
                      ],
                      indicatorColor: pn_100,
                      indicatorWeight: 1,
                      dividerHeight: 6,
                      dividerColor: f_5,
                      indicatorPadding: const EdgeInsets.only(bottom: 6),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(controller: controller, children: [
                    //판매 중
                    SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: [
                          const SizedBox(height: 14),
                          (response.onSale.totalNum == 0 && response.openingNotice.totalNum == 0)
                              ? Column(children: [
                                  const SizedBox(height: 30),
                                  Image.asset('images/my_ticket/ticket_null.png', width: 160, height: 160),
                                  const SizedBox(height: 30),
                                  Text('판매 중인 티켓이 없어요', style: b6_16Med(f_60))
                                ])
                              : const SizedBox(),
                          response.openingNotice.totalNum > 0
                              ? Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        response.openingNotice.concerts.length,
                                        (index) {
                                          return Column(children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => TicketDetailScreen(
                                                      concertId: response
                                                          .openingNotice.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                    ),
                                                  ),
                                                );
                                                AmplitudeConfig.amplitude.logEvent(
                                                    'TicketDetail(title:${response.openingNotice.concerts[index].title})');
                                              },
                                              child: OpeningNoticeWidget(
                                                  openingResponse: response.openingNotice, index: index),
                                            ),
                                            const SizedBox(height: 12)
                                          ]);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          response.onSale.totalNum > 0
                              ? Column(children: [
                                  Column(
                                    children: List.generate(
                                      response.onSale.concerts.length,
                                      (index) {
                                        return Column(children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TicketDetailScreen(
                                                    concertId: response.onSale.concerts[index].concertId,
                                                  ),
                                                ),
                                              );
                                              AmplitudeConfig.amplitude.logEvent(
                                                  'TicketDetail(title:${response.onSale.concerts[index].title})');
                                            },
                                            child: OnSaleWidget(onSaleResponse: response.onSale, index: index),
                                          ),
                                          const SizedBox(height: 12)
                                        ]);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 28)
                                ])
                              : const SizedBox()
                        ])),
                    //판매 종료
                    SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 14),
                            (response.afterSale.totalNum == 0)
                                ? Column(children: [
                                    const SizedBox(height: 30),
                                    Image.asset('images/my_ticket/ticket_null.png', width: 160, height: 160),
                                    const SizedBox(height: 30),
                                    Text('판매 종료된 티켓이 없어요', style: b6_16Med(f_60))
                                  ])
                                : const SizedBox(),
                            response.afterSale.totalNum > 0
                                ? Column(
                                    children: [
                                      Column(
                                        children: List.generate(
                                          response.afterSale.concerts.length,
                                          (index) {
                                            return Column(children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TicketDetailScreen(
                                                        concertId: response.afterSale.concerts[index].concertId,
                                                      ),
                                                    ),
                                                  );
                                                  AmplitudeConfig.amplitude.logEvent(
                                                      'TicketDetail(title:${response.afterSale.concerts[index].title})');
                                                },
                                                child: OnSaleWidget(onSaleResponse: response.afterSale, index: index),
                                              ),
                                              const SizedBox(height: 12)
                                            ]);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ))
                  ]))
                ],
              ));
        },
      ),
    );
  }
}
