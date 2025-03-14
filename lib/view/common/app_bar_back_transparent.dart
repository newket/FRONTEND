import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/fonts.dart';

PreferredSizeWidget appBarBackTransparent(BuildContext context, String title) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        //AmplitudeConfig.amplitude.logEvent('Back');
        Navigator.pop(context);
      },
      color: Colors.white,
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    ),
    backgroundColor: Colors.transparent,
    centerTitle: true,
    title: Text(title, style: s1_16Semi(Colors.white)),
    scrolledUnderElevation: 0,
    elevation: 0.0,
  );
}
