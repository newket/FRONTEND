import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/artist/widget/artist_list_widget.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/view/my_ticket/screen/artist_notification_skeleton_screen.dart';

class ArtistNotificationScreen extends StatefulWidget {
  const ArtistNotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArtistNotificationScreen();
}

class _ArtistNotificationScreen extends State<ArtistNotificationScreen> with WidgetsBindingObserver, RouteAware {
  late NotificationRequestRepository notificationRequestRepository;
  List<ArtistDto> myArtists = [];
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  bool isLoading = true;

  Future<void> _getFavoriteArtists(BuildContext context) async {
    final artists = await notificationRequestRepository.getAllArtistNotification(context);
    setState(() {
      myArtists = artists.artists;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    notificationRequestRepository = NotificationRequestRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _getFavoriteArtists(context);
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ArtistNotificationSkeletonScreen();
    }
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        appBar: appBarBack(context, "알림 받는 아티스트 목록"),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: myArtists.length,
                itemBuilder: (context, index) {
                  final myArtist = myArtists[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => ArtistProfileScreen(artistId: myArtist.artistId)),
                    child: ArtistListWidget(artist: myArtist, isFavoriteArtist: true, toastBottom: 88),
                  );
                })));
  }
}
