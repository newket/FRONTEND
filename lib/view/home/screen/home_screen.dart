import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/ticket_response.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/common/skeleton_widget.dart';
import 'package:newket/view/ticket_list/screen/ticket_list_screen.dart';
import 'package:newket/view/ticket_list/widget/genre_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

import '../../../constant/enum.dart';
import '../../ticket_detail/screen/ticket_detail_screen.dart';
import '../../ticket_list/widget/before_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with WidgetsBindingObserver, RouteAware {
  bool isLoading = true;
  late TicketRepository ticketRepository;
  late TicketResponse top5tickets;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  void _load() async {
    final tickets = await ticketRepository.top5();
    if (!mounted) return;
    setState(() {
      top5tickets = tickets;
      isLoading = false;
    });
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    _load();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);
    Smartlook.instance.trackEvent('HomeScreen');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: (_scrollPosition == 0) ? const Color(0xffF9F9F9) : Colors.white,
          title: const Text(
            'NEWKET',
            style: TextStyle(
              color: pn_100,
              fontSize: 24,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w800,
              height: 1.33,
              letterSpacing: -0.72,
            ),
          ),
          scrolledUnderElevation: 0,
        ),
        backgroundColor: const Color(0xffF9F9F9),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, spacing: 8, children: [
                  GestureDetector(
                      onTap: () {
                        Get.to(() => const TicketListScreen(genre: Genre.ALL));
                        final Properties properties = Properties();
                        properties.putString('page', value: 'home');
                        properties.putString('genre', value: 'ALL');
                        Smartlook.instance.trackEvent('HomeScreen', properties: properties);
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 48) / 2,
                        height: 282,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: f_15,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(left: 16, top: 16, child: Text('전체 티켓', style: s1_16Semi(f_100))),
                            Positioned(
                              left: 16,
                              top: 44,
                              child: SizedBox(width: 91, child: Text('알림 받을 티켓을 찾아보세요!', style: c1_14Med(f_50))),
                            ),
                            Positioned(right: 0, bottom: 0, child: Image.asset('images/ticket/all.png', width: 134.78)),
                          ],
                        ),
                      )),
                  const Column(
                    spacing: 8,
                    children: [
                      GenreWidget(title: '콘서트/팬미팅', imagePath: 'images/ticket/concert.png', genre: Genre.CONCERT),
                      GenreWidget(title: '뮤지컬/연극', imagePath: 'images/ticket/musical.png', genre: Genre.MUSICAL),
                      GenreWidget(title: '페스티벌', imagePath: 'images/ticket/festival.png', genre: Genre.FESTIVAL)
                    ],
                  ),
                ]),
                const SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('오늘의 인기 티켓 TOP 5', style: s1_16Semi(f_100)),
                      const SizedBox(height: 8),
                      if (isLoading)
                        Column(
                          children: List.generate(
                            5,
                            (index) => Column(
                              children: [
                                SkeletonWidget(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 110,
                                  radius: 8,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        Column(
                          children: List.generate(
                            top5tickets.beforeSaleTickets.totalNum,
                            (index) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(
                                          ticketId: top5tickets.beforeSaleTickets.tickets[index].ticketId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: BeforeSaleWidget(
                                    beforeSaleTicketsResponse: top5tickets.beforeSaleTickets,
                                    index: index,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            top5tickets.onSaleTickets.totalNum,
                            (index) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(
                                          ticketId: top5tickets.onSaleTickets.tickets[index].ticketId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: OnSaleWidget(
                                    onSaleResponse: top5tickets.onSaleTickets,
                                    index: index,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            )));
  }
}
