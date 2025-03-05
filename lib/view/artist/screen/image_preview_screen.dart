import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Dismissible(
            key: const Key('dismissible'),
            direction: DismissDirection.down,
            onDismissed: (_) => Navigator.of(context).pop(),
            child: Container(
                color: Colors.black.withValues(alpha: 0.8),
                child: Stack(
                  children: [
                    Center(
                        child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.network(
                        imageUrl,
                        width: 350,
                        fit: BoxFit.contain,
                      ),
                    )),
                    Positioned(
                        top: 60,
                        right: 20,
                        child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Text('닫기', style: button2_14Semi(f_5)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.close, color: Colors.white, size: 20)
                                ],
                              ),
                            ))),
                  ],
                ))));
  }
}
