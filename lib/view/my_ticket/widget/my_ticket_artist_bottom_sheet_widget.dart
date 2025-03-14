import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_profile_response.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/common/skeleton_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/before_sale_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

class MyTicketArtistBottomSheetWidget extends StatefulWidget {
  final int artistId;
  final VoidCallback onConfirm;

  const MyTicketArtistBottomSheetWidget({super.key, required this.artistId, required this.onConfirm});

  @override
  State<MyTicketArtistBottomSheetWidget> createState() => _MyTicketArtistBottomSheetWidgetState();
}

class _MyTicketArtistBottomSheetWidgetState extends State<MyTicketArtistBottomSheetWidget> {
  late ArtistRepository artistRepository;
  late ArtistProfileResponse artistProfileResponse;

  bool isLoading = true;

  Future<void> _loadMyTicket() async {
    final artist = await artistRepository.getArtistProfile(widget.artistId);

    if (!mounted) return;

    setState(() {
      artistProfileResponse = artist;
      isLoading = false;
    });
  }

  @override
  void initState() {
    artistRepository = ArtistRepository();
    _loadMyTicket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
          height: MediaQuery
              .of(context)
              .size
              .height - 164,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x1E1A1A25),
                blurRadius: 52,
                offset: Offset(0, 6),
                spreadRadius: 0,
              )
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SkeletonWidget(width: double.infinity, height: 40, radius: 8),
            SizedBox(height: 20),
            SkeletonWidget(width: 106, height: 26, radius: 8),
            SizedBox(height: 12),
            SkeletonWidget(width: double.infinity, height: 110, radius: 8),
            SizedBox(height: 12),
            SkeletonWidget(width: double.infinity, height: 110, radius: 8),
            SizedBox(height: 12),
            SkeletonWidget(width: double.infinity, height: 110, radius: 8),
            SizedBox(height: 12),
          ]));
    }
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height - 164,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x1E1A1A25),
              blurRadius: 52,
              offset: Offset(0, 6),
              spreadRadius: 0,
            )
          ],
        ),
        child: SingleChildScrollView(child: Column(children: [
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Get.to(() => ArtistProfileScreen(artistId: widget.artistId));
                widget.onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: f_5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(10),
                fixedSize: const Size(double.infinity, 40),
                shadowColor: Colors.transparent,
              ).copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('아티스트 프로필 보기', style: button3_12Reg(f_70)),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: f_70),
              ])),
          const SizedBox(height: 28),
          (artistProfileResponse.onSaleTickets.totalNum == 0 && artistProfileResponse.beforeSaleTickets.totalNum == 0)
              ? Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset('images/my_ticket/artist_ticket_null.png', width: 350, height: 254)))
              : const SizedBox(),
          artistProfileResponse.beforeSaleTickets.totalNum > 0
              ? Column(
            children: [
              Row(
                children: [
                  Text("오픈 예정 티켓", style: s1_16Semi(f_100)),
                  const SizedBox(width: 8),
                  Text("${artistProfileResponse.beforeSaleTickets.totalNum}개", style: b7_16Reg(f_50))
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(
                  artistProfileResponse.beforeSaleTickets.tickets.length,
                      (index) {
                    return Column(children: [
                      GestureDetector(
                        onTap: () {
                          //AmplitudeConfig.amplitude.logEvent('OpeningNoticeDetail(title:${artistProfileResponse.beforeSaleTickets.tickets[index].title})');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketDetailScreen(
                                    ticketId: artistProfileResponse.beforeSaleTickets.tickets[index].ticketId,
                                  ),
                            ),
                          );
                        },
                        child: BeforeSaleWidget(
                            beforeSaleTicketsResponse: artistProfileResponse.beforeSaleTickets, index: index),
                      ),
                      const SizedBox(height: 12)
                    ]);
                  },
                ),
              ),
              const SizedBox(height: 28)
            ],
          )
              : const SizedBox(),
          artistProfileResponse.onSaleTickets.totalNum > 0
              ? Column(children: [
            Row(
              children: [
                Text("예매 중인 티켓", style: s1_16Semi(f_100)),
                const SizedBox(width: 8),
                Text("${artistProfileResponse.onSaleTickets.totalNum}개", style: b7_16Reg(f_50))
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(
                artistProfileResponse.onSaleTickets.totalNum,
                    (index) {
                  return Column(children: [
                    GestureDetector(
                      onTap: () {
                        //AmplitudeConfig.amplitude.logEvent('OpeningNoticeDetail(title:${artistProfileResponse.onSaleTickets.tickets[index].title})');
                        // 상세 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TicketDetailScreen(
                                  ticketId: artistProfileResponse.onSaleTickets.tickets[index]
                                      .ticketId, // 상세 페이지에 데이터 전달
                                ),
                          ),
                        );
                      },
                      child: OnSaleWidget(onSaleResponse: artistProfileResponse.onSaleTickets, index: index),
                    ),
                    const SizedBox(height: 12)
                  ]);
                },
              ),
            ),
            const SizedBox(height: 28)
          ])
              : const SizedBox()
        ])));
  }
}
