import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_profile_response.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_skeleton_screen.dart';
import 'package:newket/view/artist/screen/image_preview_screen.dart';
import 'package:newket/view/artist/widget/artist_horizontal_list_widget.dart';
import 'package:newket/view/artist/widget/medium_notification_button_widget.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/before_sale_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

class ArtistProfileScreen extends StatefulWidget {
  final int artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  State<StatefulWidget> createState() => _ArtistProfileScreen();
}

class _ArtistProfileScreen extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  ArtistRepository artistRepository = ArtistRepository();
  NotificationRequestRepository notificationRequestRepository = NotificationRequestRepository();
  late TabController controller;
  late Future repository;
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
    final favoriteStatus = await notificationRequestRepository.isArtistNotification(widget.artistId, context);
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
    controller.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appbarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    return FutureBuilder(
        future: repository,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ArtistProfileSkeletonScreen();
          }
          ArtistProfileResponse response = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                title: Text('아티스트 프로필', style: s1_16Semi((_scrollPosition == 0) ? Colors.white : f_100)),
                backgroundColor: (_scrollPosition == 0) ? Colors.transparent : Colors.white,
                scrolledUnderElevation: 0,
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () {
                    //AmplitudeConfig.amplitude.logEvent('Back');
                    Navigator.pop(context);
                  },
                  color: (_scrollPosition == 0) ? Colors.white : f_100,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                primary: true,
                flexibleSpace: (_scrollPosition == 0)
                    ? Stack(
                        children: [
                          Positioned(
                              top: -0,
                              child: ImageLoadingWidget(
                                  width: MediaQuery.of(context).size.width,
                                  height: 399,
                                  radius: 0,
                                  imageUrl: response.info.imageUrl ?? '')),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0, -1),
                                end: const Alignment(0, 1),
                                colors: [
                                  const Color(0x81B5B5B5),
                                  Colors.white.withValues(alpha: 0.73),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(color: Colors.white)),
            body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                  top: -appbarHeight,
                                  child: ImageLoadingWidget(
                                      width: MediaQuery.of(context).size.width,
                                      height: 399,
                                      radius: 0,
                                      imageUrl: response.info.imageUrl ?? '')),
                              Container(
                                height: 399 - appbarHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: const Alignment(0, -1),
                                    end: const Alignment(0, 1),
                                    colors: [
                                      Colors.white.withValues(alpha: 0.73),
                                      Colors.white.withValues(alpha: 0.89),
                                      Colors.white,
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 34),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: const BorderRadius.all(Radius.circular(18)),
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
                                          //AmplitudeConfig.amplitude.logEvent('ImagePreview(artist: ${response.info.name})');
                                        },
                                        child: ImageLoadingWidget(
                                          width: 120,
                                          height: 120,
                                          radius: 16,
                                          imageUrl: response.info.imageUrl ?? '',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        height: 33,
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(text: response.info.name, style: h2_24Semi(f_100)),
                                        )),
                                    SizedBox(
                                        height: 22,
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(text: response.info.subName ?? '', style: b9_14Reg(f_60)),
                                        )),
                                    const SizedBox(height: 10),
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
                                                        //AmplitudeConfig.amplitude.logEvent('ArtistProfile(artist: ${response.members[index].name})');
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
                                                        //AmplitudeConfig.amplitude.logEvent('ArtistProfile(artist: ${response.groups[index].name})');
                                                      },
                                                      child:
                                                          ArtistHorizontalListWidget(artist: response.groups[index])));
                                            })),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: 36),
                          Row(children: [const SizedBox(width: 20), Text("티켓", style: s1_16Semi(f_100))]),
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: [
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
                              child: Text(
                                  "판매 중  ${response.beforeSaleTickets.totalNum + response.onSaleTickets.totalNum}개  ",
                                  style: b8_14Med(controller.index == 0 ? pn_100 : f_40))),
                          Tab(
                              child: Text(
                            "판매 종료  ${response.afterSaleTickets.totalNum}개  ",
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
                            (response.onSaleTickets.totalNum == 0 && response.beforeSaleTickets.totalNum == 0)
                                ? Column(children: [
                                    const SizedBox(height: 30),
                                    Image.asset('images/my_ticket/ticket_null.png', width: 160, height: 160),
                                    const SizedBox(height: 30),
                                    Text('판매 중인 티켓이 없어요', style: b6_16Med(f_60))
                                  ])
                                : const SizedBox(),
                            response.beforeSaleTickets.totalNum > 0
                                ? Column(
                                    children: [
                                      Column(
                                        children: List.generate(
                                          response.beforeSaleTickets.tickets.length,
                                          (index) {
                                            return Column(children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TicketDetailScreen(
                                                        ticketId: response.beforeSaleTickets.tickets[index].ticketId,
                                                      ),
                                                    ),
                                                  );
                                                  //AmplitudeConfig.amplitude.logEvent('TicketDetail(title:${response.beforeSaleTickets.tickets[index].title})');
                                                },
                                                child: BeforeSaleWidget(
                                                    beforeSaleTicketsResponse: response.beforeSaleTickets,
                                                    index: index),
                                              ),
                                              const SizedBox(height: 12)
                                            ]);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            response.onSaleTickets.totalNum > 0
                                ? Column(children: [
                                    Column(
                                      children: List.generate(
                                        response.onSaleTickets.tickets.length,
                                        (index) {
                                          return Column(children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => TicketDetailScreen(
                                                      ticketId: response.onSaleTickets.tickets[index].ticketId,
                                                    ),
                                                  ),
                                                );
                                                //AmplitudeConfig.amplitude.logEvent('TicketDetail(title:${response.beforeSaleTickets.tickets[index].title})');
                                              },
                                              child: OnSaleWidget(onSaleResponse: response.onSaleTickets, index: index),
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
                              (response.afterSaleTickets.totalNum == 0)
                                  ? Column(children: [
                                      const SizedBox(height: 30),
                                      Image.asset('images/my_ticket/ticket_null.png', width: 160, height: 160),
                                      const SizedBox(height: 30),
                                      Text('판매 종료된 티켓이 없어요', style: b6_16Med(f_60))
                                    ])
                                  : const SizedBox(),
                              response.afterSaleTickets.totalNum > 0
                                  ? Column(
                                      children: [
                                        Column(
                                          children: List.generate(
                                            response.afterSaleTickets.totalNum,
                                            (index) {
                                              return Column(children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => TicketDetailScreen(
                                                          ticketId: response.afterSaleTickets.tickets[index].ticketId,
                                                        ),
                                                      ),
                                                    );
                                                    //AmplitudeConfig.amplitude.logEvent('TicketDetail(title:${response.afterSaleTickets.tickets[index].title})');
                                                  },
                                                  child: OnSaleWidget(
                                                      onSaleResponse: response.afterSaleTickets, index: index),
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
                )),
          );
        });
  }
}
