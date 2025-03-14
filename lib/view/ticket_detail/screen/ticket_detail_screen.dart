import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/ticket_detail_response.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/artist/screen/image_preview_screen.dart';
import 'package:newket/view/artist/widget/artist_list_widget.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/common/toast_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_skeleton_screen.dart';
import 'package:newket/view/ticket_detail/widget/date_list_popup_widget.dart';
import 'package:newket/view/ticket_detail/widget/ticket_notification_cacle_popup_widget.dart';
import 'package:newket/view/ticket_detail/widget/ticket_sale_bottom_sheet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final int ticketId;

  @override
  State<StatefulWidget> createState() => _TicketDetailScreen();
}

class _TicketDetailScreen extends State<TicketDetailScreen> with WidgetsBindingObserver, RouteAware {
  late TicketRepository ticketRepository;
  late NotificationRequestRepository notificationRequestRepository;
  late bool isNotification;
  late TicketDetailResponse ticketResponse;
  late List<bool> isFavoriteArtist;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  Future<void> _getIsNotification() async {
    final response1 = await ticketRepository.getTicketDetail(widget.ticketId);
    final response2 = await Future.wait(
        response1.artists.map((i) => notificationRequestRepository.isArtistNotification(i.artistId, context)));
    final response3 = await notificationRequestRepository.isTicketNotification(context, widget.ticketId);
    setState(() {
      ticketResponse = response1;
      isFavoriteArtist = response2;
      isNotification = response3;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    notificationRequestRepository = NotificationRequestRepository();
    _getIsNotification();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _getIsNotification();
      routeObserver.unsubscribe(this);
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const TicketDetailSkeletonScreen();
    }

    void launchURL(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw '';
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        //body 위에 appbar
        appBar: AppBar(
          centerTitle: true,
          title: Text('티켓 상세 보기', style: s1_16Semi((_scrollPosition == 0) ? Colors.white : f_100)),
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
        ),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              Stack(
                children: [
                  ImageLoadingWidget(
                    width: double.infinity,
                    height: 537,
                    radius: 0,
                    imageUrl: ticketResponse.imageUrl,
                  ),
                  Container(
                    width: double.infinity,
                    height: 537,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0, -1),
                        end: const Alignment(0, 1),
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          const Color(0x7C454545),
                          const Color(0x91AAAAAA),
                          Colors.white.withValues(alpha: 0.7),
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 143, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: const BorderRadius.all(Radius.circular(14)),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) => ImagePreviewScreen(imageUrl: ticketResponse.imageUrl),
                                  ),
                                );
                                //AmplitudeConfig.amplitude.logEvent('ImagePreview(ticket: ${ticketResponse.title})');
                              },
                              child: ImageLoadingWidget(
                                width: 172,
                                height: 228,
                                radius: 12,
                                imageUrl: ticketResponse.imageUrl,
                              ),
                            ),
                          )),
                          const SizedBox(height: 46),
                          Text(ticketResponse.title, style: t1_20Semi(f_100)),
                          const SizedBox(height: 20),
                          Row(children: [
                            Text('장소', style: c2_14Reg(f_50)),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => launchURL(ticketResponse.placeUrl),
                              child: Row(
                                children: [
                                  Text(ticketResponse.place, style: c1_14Med(f_90)),
                                  const Icon(Icons.keyboard_arrow_right_rounded, size: 22, color: f_90)
                                ],
                              ),
                            )
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            Text('기간', style: c2_14Reg(f_50)),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                          insetPadding: EdgeInsets.zero,
                                          child: DateListPopupWidget(
                                            dateList: ticketResponse.dateList,
                                          ));
                                    });
                              },
                              child: Row(
                                children: [
                                  Text(ticketResponse.date, style: c1_14Med(f_90)),
                                  const Icon(Icons.keyboard_arrow_right_rounded, size: 22, color: f_90)
                                ],
                              ),
                            )
                          ])
                        ],
                      ))
                ],
              ),
              Container(color: f_5, height: 6),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('오픈 정보', style: s1_16Semi(f_100)),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(ticketResponse.ticketSaleSchedules.length, (index) {
                          return Column(children: [
                            ElevatedButton(
                                onPressed: () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true, // 화면 전체를 덮을 수 있도록 설정
                                      backgroundColor: Colors.transparent, // 배경 투명
                                      builder: (context) {
                                        return TicketSaleBottomSheetWidget(
                                          type: ticketResponse.ticketSaleSchedules[index].type,
                                          ticketSaleUrls: ticketResponse.ticketSaleSchedules[index].ticketSaleUrls,
                                        );
                                      },
                                    ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: f_80,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  fixedSize: const Size(double.infinity, 48),
                                  shadowColor: Colors.transparent,
                                ).copyWith(
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                    SizedBox(
                                        width: 72,
                                        child: Text(ticketResponse.ticketSaleSchedules[index].type,
                                            style: b9_14Reg(f_15))),
                                    Container(width: 1.5, height: 12, color: f_40),
                                  ]),
                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    Text(ticketResponse.ticketSaleSchedules[index].date, style: b8_14Med(Colors.white)),
                                    const SizedBox(width: 12),
                                    SvgPicture.asset('images/ticket/send.svg', width: 16, height: 16)
                                  ])
                                ])),
                            const SizedBox(height: 4)
                          ]);
                        }),
                      ),
                      const SizedBox(height: 36),
                      ticketResponse.prices.isNotEmpty
                          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('가격 정보', style: s1_16Semi(f_100)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6, // 가로 간격
                                runSpacing: 6, // 세로 간격
                                children: ticketResponse.prices.map((price) {
                                  return Container(
                                    height: 38,
                                    width: (MediaQuery.of(context).size.width - 46) / 2,
                                    padding: const EdgeInsets.all(9),
                                    decoration: ShapeDecoration(
                                      color: f_5,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textHeightBehavior: const TextHeightBehavior(
                                                  // 텍스트 높이 맞춤
                                                  applyHeightToFirstAscent: false,
                                                  applyHeightToLastDescent: false,
                                                ),
                                                text: TextSpan(
                                                  text: price.type,
                                                  style: button3_12Reg(f_60),
                                                ))),
                                        const SizedBox(width: 12),
                                        RichText(
                                          text: TextSpan(text: price.price, style: c3_12Med(f_100)),
                                          textHeightBehavior: const TextHeightBehavior(
                                            // 텍스트 높이 맞춤
                                            applyHeightToFirstAscent: false,
                                            applyHeightToLastDescent: false,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 34)
                            ])
                          : const SizedBox(),
                      Text('아티스트 정보', style: s1_16Semi(f_100)),
                      const SizedBox(height: 12),
                      Column(
                          children: List.generate(ticketResponse.artists.length, (index) {
                        return GestureDetector(
                            onTap: () {
                              Get.to(() => ArtistProfileScreen(artistId: ticketResponse.artists[index].artistId));
                              //AmplitudeConfig.amplitude.logEvent('ArtistProfile(artist: ${ticketResponse.artists[index].name})');
                            },
                            child: ArtistListWidget(
                              artist: ticketResponse.artists[index],
                              isFavoriteArtist: isFavoriteArtist[index],
                              toastBottom: ticketResponse.isAvailableNotification ? 100 : 40,
                              onConfirm: () {
                                setState(() {
                                  isFavoriteArtist[index] = !isFavoriteArtist[index];
                                });
                              },
                            ));
                      })),
                      const SizedBox(height: 8),
                      Text('티켓오픈일정은 티켓판매처 또는 기획사의 사정에 의해 사전 예고 없이 변경또는 취소 될 수 있습니다.', style: c4_12Reg(f_50)),
                      const SizedBox(height: 30)
                    ],
                  ))
            ])),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: ticketResponse.isAvailableNotification
            ? Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 40,
                height: 88 + MediaQuery.of(context).viewPadding.bottom,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom + 20, top: 12, left: 20, right: 20),
                child: ElevatedButton(
                    onPressed: () async {
                      // 요청 전송
                      if (!isNotification) {
                        HapticFeedback.lightImpact();
                        // 알림 안받은 상태에서
                        bool success =
                            await NotificationRequestRepository().postTicketNotification(context, widget.ticketId);
                        if (success) {
                          ToastManager.showToast(
                              toastBottom: 100,
                              title: '알림 받기가 완료되었어요!',
                              content: '티켓 오픈 하루 전, 1시간 전에 알려드릴게요',
                              context: context);
                          setState(() {
                            isNotification = !isNotification;
                          });
                        }
                      } else {
                        // 알림 받은 상태에서
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  child: TicketNotificationCaclePopupWidget(
                                    onConfirm: () async {
                                      setState(() {
                                        isNotification = !isNotification;
                                      });
                                      await NotificationRequestRepository()
                                          .deleteTicketNotification(context, widget.ticketId);
                                      Navigator.of(context).pop();
                                      ToastManager.showToast(
                                          toastBottom: 100, title: '알림이 해제되었어요', content: null, context: context);
                                    },
                                  ));
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      // 그림자 제거
                      backgroundColor: isNotification ? pt_20 : pn_100,
                      // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // 상하 패딩
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isNotification
                            ? SvgPicture.asset('images/ticket/notification_on.svg', color: pn_100)
                            : SvgPicture.asset('images/search/notification_null.svg', width: 20,),
                        const SizedBox(width: 10),
                        Text(
                          isNotification ? '알림 받는 중' : '알림 받기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              color: isNotification ? pn_100 : Colors.white),
                        )
                      ],
                    )))
            : const SizedBox());
  }
}
