import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/view/common/image_loading_widget.dart';

class LineUpScreen extends StatefulWidget {
  final String message;
  final String imageUrl;

  const LineUpScreen({super.key, required this.message, required this.imageUrl});

  @override
  State<LineUpScreen> createState() => _LineUpScreenState();
}

class _LineUpScreenState extends State<LineUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: f_100,
      appBar: appBarBack(context, widget.message),
      body: SingleChildScrollView(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: ImageLoadingWidget(
            width: MediaQuery.of(context).size.width,
            height: null,
            radius: 0,
            imageUrl: widget.imageUrl,
          ),
        ),
      ),
    );
  }
}
