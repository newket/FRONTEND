import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/view/my_ticket/widget/my_ticket_before_sale_widget.dart';
import 'package:newket/view/my_ticket/widget/my_ticket_on_sale_widget.dart';

class MyTicketTabBar1 extends StatefulWidget {
  final BeforeSaleTicketsResponse beforeSaleResponse;
  final OnSaleResponse onSaleResponse;

  const MyTicketTabBar1({super.key, required this.beforeSaleResponse, required this.onSaleResponse});

  @override
  State<MyTicketTabBar1> createState() => _MyTicketTabBar1State();
}

class _MyTicketTabBar1State extends State<MyTicketTabBar1> with TickerProviderStateMixin {
  late TabController controller2;

  @override
  void initState() {
    super.initState();
    controller2 = TabController(length: 2, vsync: this);
    controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: f_5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: TabBar(
              tabs: <Tab>[
                Tab(
                  height: 36,
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("오픈 예정 티켓", style: c3_12Med(controller2.index == 0 ? f_80 : f_70)),
                      const SizedBox(width: 6),
                      Text("${widget.beforeSaleResponse.totalNum}개", style: c3_12Med(f_50))
                    ],
                  ),
                ),
                Tab(
                  height: 36,
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("예매 중인 티켓", style: c3_12Med(controller2.index == 1 ? f_80 : f_70)),
                      const SizedBox(width: 6),
                      Text("${widget.onSaleResponse.totalNum}개", style: c3_12Med(f_50))
                    ],
                  ),
                ),
              ],
              controller: controller2,
              dividerColor: Colors.transparent,
              indicator: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              indicatorPadding: const EdgeInsets.all(3),
              labelPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller2,
            children: <Widget>[
               MyTicketBeforeSaleWidget(beforeSaleResponse: widget.beforeSaleResponse),
               MyTicketOnSaleWidget(onSaleResponse: widget.onSaleResponse),
            ],
          ))
        ],
      ),
    );
  }
}
