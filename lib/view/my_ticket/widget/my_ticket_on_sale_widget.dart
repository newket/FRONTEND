import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

class MyTicketOnSaleWidget extends StatelessWidget {
  final OnSaleResponse onSaleResponse;

  const MyTicketOnSaleWidget({super.key, required this.onSaleResponse});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: onSaleResponse.tickets.isEmpty
            ? Image.asset('images/my_ticket/artist_on_sale_null.png', width: 350)
            :
        Column(children: [
      Column(
        children: List.generate(
          onSaleResponse.tickets.length,
          (index) {
            return Column(children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(
                        ticketId: onSaleResponse.tickets[index].ticketId,
                      ),
                    ),
                  );
                  //AmplitudeConfig.amplitude.logEvent('TicketDetail(title:${onSaleResponse.tickets[index].title})');
                },
                child: OnSaleWidget(onSaleResponse: onSaleResponse, index: index),
              ),
              const SizedBox(height: 12)
            ]);
          },
        ),
      ),
      const SizedBox(height: 50)
    ]));
  }
}
