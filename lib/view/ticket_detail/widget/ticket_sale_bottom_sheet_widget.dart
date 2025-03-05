import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/ticket_detail_response.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketSaleBottomSheetWidget extends StatelessWidget {
  final String type;
  final List<TicketSaleUrl> ticketSaleUrls;

  const TicketSaleBottomSheetWidget({super.key, required this.type, required this.ticketSaleUrls});

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 222,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(width: 24),
            Text('$type 바로가기', style: s1_16Semi(f_100)),
            GestureDetector(onTap: Get.back, child: const Icon(Icons.close, size: 24)),
          ]),
          const SizedBox(height: 24),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(ticketSaleUrls.length, (index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GestureDetector(
                      onTap: () => launchURL(ticketSaleUrls[index].url),
                      child: Column(children: [
                        ImageLoadingWidget(
                            width: 60, height: 60, radius: 15, imageUrl: ticketSaleUrls[index].providerImageUrl),
                        const SizedBox(height: 4),
                        Text(ticketSaleUrls[index].ticketProvider, style: button3_12Reg(f_70))
                      ]),
                    ));
              }))
        ],
      ),
    );
  }
}
