import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/artist/widget/artist_list_skeleton_ui_widget.dart';
import 'package:newket/view/common/skeleton_widget.dart';
import 'package:newket/view/ticket_list/widget/ticket_skeleton_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

class SearchResultSkeletonWidget extends StatelessWidget {
  const SearchResultSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonWidget(width: 77, height: 24, radius: 8),
              SizedBox(height: 12),
              ArtistListSkeletonUiWidget(),
            ],
          ),
        ),
        Container(height: 4, color: f_10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonWidget(width: 169, height: 24, radius: 8),
              const SizedBox(height: 10),
              Column(
                children: List.generate(4, (index) {
                  return const Column(
                    children: [
                      SkeletonWidget(width: double.infinity, height: 110, radius: 8),
                      SizedBox(height: 12)
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ],
    );
  }
}
