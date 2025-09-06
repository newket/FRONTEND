import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/enum.dart';
import 'package:newket/constant/fonts.dart';

import '../screen/ticket_list_screen.dart';

class GenreWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final Genre genre;

  const GenreWidget({super.key, required this.title, required this.imagePath, required this.genre});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => TicketListScreen(genre: genre));
        },
        child: Container(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            height: 89,
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
                Positioned(
                  left: 16,
                  top: 16,
                  child: Text(title, style: s1_16Semi(f_100)),
                ),
                Positioned(right: 12, bottom: 12, child: Image.asset(imagePath, width: 48)),
              ],
            )));
  }
}
