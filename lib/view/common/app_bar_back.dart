import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';

PreferredSizeWidget appBarBack(BuildContext context, String title) {
  return AppBar(
      leading: IconButton(
          onPressed: () {
            AmplitudeConfig.amplitude.logEvent('Back');
            Navigator.pop(context); //뒤로가기
          },
          color: f_90,
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: f_100,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 0.09,
          letterSpacing: -0.48,
        ),
      ));
}
