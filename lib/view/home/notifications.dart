import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/theme/Colors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<StatefulWidget> createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //배경
        backgroundColor: b_950,

        //앱바
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: const Text(
            "알림 모아보기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //내용
        body: SingleChildScrollView(
            //스크롤 가능
            child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: FutureBuilder(
                    future: NotificationRepository().getAllNotifications(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Center();
                      } else {
                        final notifications = snapshot.data!.notifications;

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notification.content,
                                    style: const TextStyle(
                                      color: b_400,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Stack(children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 2),
                                        DottedBorder(
                                          color: b_800,
                                          strokeWidth: 6,
                                          dashPattern: const [6, 6],
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width - 53,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: b_950,
                                      height: 10,
                                      width: double.infinity,
                                    )
                                  ]),
                                  const SizedBox(height: 16),
                                ],
                              );
                            });
                      }
                    }))));
  }
}
