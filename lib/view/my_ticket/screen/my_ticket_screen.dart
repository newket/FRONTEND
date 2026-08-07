import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/notification_request/artist_notification_response.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/my_ticket/screen/artist_notification_screen.dart';
import 'package:newket/view/my_ticket/screen/my_ticket_skeleton_screen.dart';
import 'package:newket/view/my_ticket/widget/my_ticket_artist_bottom_sheet_widget.dart';
import 'package:newket/view/my_ticket/widget/my_ticket_tab_bar1.dart';
import 'package:newket/view/my_ticket/widget/my_ticket_tab_bar2.dart';
import 'package:newket/view/search/screen/searching_screen.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyTicketScreen();
}

class _MyTicketScreen extends State<MyTicketScreen> with TickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  late NotificationRequestRepository notificationRequestRepository;
  late ArtistNotificationResponse artists;
  late BeforeSaleTicketsResponse beforeSaleResponse;
  late OnSaleResponse onSaleResponse;
  late BeforeSaleTicketsResponse notificationTickets;

  late TabController controller;

  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  bool isLoading = true;

  int? selectedIndex;

  PersistentBottomSheetController? _bottomSheetController;
  void Function(void Function())? _bottomSheetSetState;
  int? selectedArtistId;

  void _onArtistTap(int index, int artistId) {
    if (selectedIndex == index) {
      // 같은 아이템을 두 번 클릭하면 바텀시트 닫기
      _bottomSheetController?.close();
      _bottomSheetController = null;
      setState(() => selectedIndex = null);
      return;
    }

    setState(() {
      selectedIndex = index;
      selectedArtistId = artistId;
    });

    _showBottomSheet(artistId);
  }

  void _showBottomSheet(int artistId) {
    _bottomSheetController = Scaffold.of(context).showBottomSheet(
      (context) => StatefulBuilder(
        builder: (context, setState) {
          _bottomSheetSetState = setState; // setState 저장
          return MyTicketArtistBottomSheetWidget(
            artistId: selectedArtistId ?? artistId,
            onConfirm: () {
              _bottomSheetController?.close();
              _bottomSheetController = null;
              _bottomSheetSetState = null;
              setState(() => selectedIndex = null);
            },
          );
        },
      ),
      backgroundColor: Colors.white,
    );

    // 바텀시트가 닫힐 때 컨트롤러 초기화
    _bottomSheetController!.closed.then((_) {
      _bottomSheetController = null;
      _bottomSheetSetState = null;
      setState(() => selectedIndex = null);
    });
  }

  @override
  void initState() {
    super.initState();
    notificationRequestRepository = NotificationRequestRepository();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
  }

  Future<void> _loadMyTicket() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "ACCESS_TOKEN");

    if (token != null) {
      final artistList = await notificationRequestRepository.getAllArtistNotification(context);
      final beforeSaleTicketList = await notificationRequestRepository.getAllBeforeSaleTicketNotification(context);
      final onSaleTicketList = await notificationRequestRepository.getAllArtistOnSaleTicket(context);
      final notificationTicketList = await notificationRequestRepository.getAllTicketNotification(context);

      if (!mounted) return;

      setState(() {
        artists = artistList;
        beforeSaleResponse = beforeSaleTicketList;
        onSaleResponse = onSaleTicketList;
        notificationTickets = notificationTicketList;
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _loadMyTicket();
      routeObserver.unsubscribe(this);
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const MyTicketSkeletonScreen();
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverToBoxAdapter(
                            child: Row(
                          children: [
                            Container(
                                width: 84,
                                height: 125,
                                color: Colors.white,
                                padding: const EdgeInsets.only(top: 16, bottom: 20, left: 20, right: 4),
                                child: artists.artists.isEmpty
                                    ? Column(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () => Get.to(() => const SearchingScreen(keyword: '')),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: pn_10,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                padding: const EdgeInsets.all(14),
                                                fixedSize: const Size(60, 60),
                                                shadowColor: Colors.transparent,
                                              ).copyWith(
                                                splashFactory: NoSplash.splashFactory,
                                              ),
                                              child: const Icon(Icons.add, color: pn_100, size: 32)),
                                          const SizedBox(height: 21)
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () => Get.to(() => const ArtistNotificationScreen()),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: f_5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                padding: const EdgeInsets.all(18),
                                                fixedSize: const Size(60, 60),
                                                shadowColor: Colors.transparent,
                                              ).copyWith(
                                                splashFactory: NoSplash.splashFactory,
                                              ),
                                              child: SvgPicture.asset("images/my_ticket/triple_line.svg")),
                                          const SizedBox(height: 4),
                                          Text('전체보기', style: c3_12Med(f_70))
                                        ],
                                      )),
                            if (artists.artists.isEmpty)
                              Column(
                                children: [
                                  const SizedBox(height: 17),
                                  Image.asset(
                                    'images/my_ticket/bubble.png',
                                    width: 240,
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              )
                            else
                              Expanded(
                                  child: Container(
                                      height: 125,
                                      padding: const EdgeInsets.only(top: 16, left: 4, bottom: 20),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: artists.artists.length,
                                          itemBuilder: (context, index) {
                                            final artist = artists.artists[index];
                                            final bool isSelected = selectedIndex == index;
                                            return SizedBox(
                                              width: 68,
                                              height: 81,
                                              child: GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  _onArtistTap(index, artists.artists[index].artistId);
                                                },
                                                child: Opacity(
                                                  opacity: selectedIndex == null || selectedIndex == index
                                                      ? 1.0
                                                      : 0.3, // 선택된 아이템은 100%, 나머지는 30%
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(18),
                                                          ),
                                                          foregroundDecoration: isSelected
                                                              ? BoxDecoration(
                                                                  border: Border.all(color: pn_100, width: 2),
                                                                  // 🔹 테두리 안쪽으로 적용
                                                                  borderRadius: BorderRadius.circular(16),
                                                                )
                                                              : null,
                                                          child: ImageLoadingWidget(
                                                            width: 60,
                                                            height: 60,
                                                            radius: 16,
                                                            imageUrl: artist.imageUrl ?? '',
                                                          )),
                                                      const SizedBox(height: 2),
                                                      RichText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        text: TextSpan(
                                                          text: artist.name,
                                                          style: c3_12Med(isSelected ? pn_100 : f_70), // 선택 시 보라색 텍스트
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })))
                          ],
                        ))
                      ];
                    },
                    body: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: 44,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TabBar(
                            tabs: <Tab>[
                              Tab(
                                icon: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: 40,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("티켓 소식", style: button2_14Semi(controller.index == 0 ? pn_100 : f_40))
                                        ])),
                              ),
                              Tab(
                                icon: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: 40,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("알림 받는 티켓", style: button2_14Semi(controller.index == 1 ? pn_100 : f_40))
                                        ])),
                              ),
                            ],
                            controller: controller,
                            dividerColor: Colors.transparent,
                            // 흰 줄 제거
                            indicatorColor: pn_100,
                            indicatorWeight: 2,
                            indicatorPadding: const EdgeInsets.all(-11),
                            // indicator 위치 내리기
                            labelPadding: EdgeInsets.zero, //탭 크기가 안 작아지게
                          ),
                        ),
                        Container(height: 1, color: f_10, width: double.infinity),
                        Expanded(
                            child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: controller,
                          children: <Widget>[
                            if (artists.artists.isEmpty)
                              Column(children: [
                                const SizedBox(height: 80),
                                Image.asset('images/my_ticket/artist_notification_null.png', width: 350),
                              ])
                            else
                              MyTicketTabBar1(beforeSaleResponse: beforeSaleResponse, onSaleResponse: onSaleResponse),
                            if (notificationTickets.tickets.isEmpty)
                              Column(children: [
                                const SizedBox(height: 80),
                                Image.asset('images/my_ticket/ticket_notification_null.png', width: 350),
                              ])
                            else
                              MyTicketTabBar2(notificationTickets: notificationTickets)
                          ],
                        ))
                      ],
                    )))));
  }
}
