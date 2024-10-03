import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:get/route_manager.dart';
import 'package:newket/view/onboarding/login.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationSetting();
}

class _NotificationSetting extends State<NotificationSetting> {
  late UserRepository userRepository;
  bool artistNotification = true;
  bool ticketNotification = true;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    _loadNotificationSettings(); // 알림 설정 불러오기
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final response = await userRepository.getNotificationAllow();
      // 알림 설정 값 상태에 반영
      setState(() {
        artistNotification = response.artistNotification;
        ticketNotification = response.ticketNotification;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      Get.offAll(const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: b_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: const Text(
            "알림 설정",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: b_950,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                width: double.infinity,
                height: 66,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '관심 아티스트 알림',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '관심 아티스트의 티켓이 등록되면 알림을 보내드려요.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            color: b_100,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    CupertinoSwitch(
                      value: artistNotification,
                      activeColor: p_700,
                      onChanged: (bool value) async {
                        // UI 상태 업데이트
                        setState(() {
                          artistNotification = value;
                        });
                        String isAllow = value ? 'on' : 'off';
                        await userRepository.putNotificationAllow(isAllow, "artist");
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                width: double.infinity,
                height: 66,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '티켓 오픈 임박 알림',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '티켓 오픈 하루 전, 1시간 전에 알려드려요.',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 12,
                            color: b_100,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    CupertinoSwitch(
                      value: ticketNotification,
                      activeColor: p_700,
                      onChanged: (bool value) async {
                        // UI 상태 업데이트
                        setState(() {
                          ticketNotification = value;
                        });
                        String isAllow = value ? 'on' : 'off';
                        await userRepository.putNotificationAllow(isAllow, "ticket");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        );
  }
}
