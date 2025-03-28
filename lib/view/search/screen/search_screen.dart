import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/artist/widget/artist_list_skeleton_ui_widget.dart';
import 'package:newket/view/artist/widget/artist_list_widget.dart';
import 'package:newket/view/search/widget/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> with WidgetsBindingObserver, RouteAware {
  late ArtistRepository artistRepository;
  late NotificationRequestRepository notificationRequestRepository;

  late Timer skeletonTimer;
  bool isLoading = true;
  bool showSkeleton = false;
  List<ArtistDto> artistList = [];
  List<bool> isFavoriteArtist = [];
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    showSkeleton = true;
    artistRepository = ArtistRepository();
    notificationRequestRepository = NotificationRequestRepository();
    WidgetsBinding.instance.addObserver(this);
    Smartlook.instance.trackEvent('SearchScreen');
  }

  Future<void> _initializeArtistsAndFavorites() async {
    setState(() {
      isLoading = true;
    }); // 200ms 후 Skeleton UI 표시
    skeletonTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        showSkeleton = true;
      });
    });

    final response = await artistRepository.getRandomArtists();
    final favoriteStatuses = await Future.wait(
      response.map((i) async {
        if (!mounted) return false; // 위젯이 dispose되었으면 기본값 반환
        return await notificationRequestRepository.isArtistNotification(i.artistId, context);
      }),
    );

    if (!mounted) return; // dispose된 후 setState 방지

    setState(() {
      artistList = response;
      isFavoriteArtist = favoriteStatuses;
      showSkeleton = false;
      isLoading = false;
    });
  }

  Future<void> refresh() async {
    HapticFeedback.mediumImpact();
    _initializeArtistsAndFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _initializeArtistsAndFavorites();
      routeObserver.unsubscribe(this);
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

// Scaffold 위젯을 감싸는 부분 수정
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchBarWidget(),
              RefreshIndicator(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  onRefresh: refresh, // 새로고침 기능 추가
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(), // 스크롤이 항상 가능하도록 설정
                      child: Column(children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('추천 아티스트', style: s1_16Semi(f_100)),
                              const SizedBox(height: 12),
                              if (isLoading)
                                if (showSkeleton)
                                  Column(
                                      children: List.generate(10, (index) {
                                    return const ArtistListSkeletonUiWidget();
                                  }))
                                else
                                  const SizedBox()
                              else
                                Column(
                                  children: List.generate(artistList.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => ArtistProfileScreen(artistId: artistList[index].artistId));
                                      },
                                      child: ArtistListWidget(
                                          artist: artistList[index],
                                          isFavoriteArtist: isFavoriteArtist[index],
                                          toastBottom: 40),
                                    );
                                  }),
                                ),
                            ],
                          ),
                        )
                      ])))
            ],
          ),
        ),
      ),
    );
  }
}
