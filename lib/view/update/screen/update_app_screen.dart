import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/colors.dart';

class UpdateAppScreen extends StatelessWidget {
  final String androidUrl;
  final String iosUrl;

  const UpdateAppScreen({super.key, required this.androidUrl, required this.iosUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF666666),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              width: 326,
              height: 194,
              padding: const EdgeInsets.all(16),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('images/update/update.svg', height: 32, width: 32),
                  const SizedBox(height: 8),
                  Text('뉴켓 업데이트 안내', style: t2_18Semi(f_100)),
                  const SizedBox(height: 2),
                  Text('원활한 서비스 이용을 위해 업데이트가 필요해요', style: c2_14Reg(f_60)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final url = Platform.isAndroid ? androidUrl : iosUrl;
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pn_100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 98),
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text("업데이트 하기", style: b8_14Bold(Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
