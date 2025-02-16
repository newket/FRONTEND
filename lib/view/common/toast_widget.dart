import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();

  factory ToastManager() => _instance;

  ToastManager._internal();

  OverlayEntry? _overlayEntry;

  static void showToast(
      {required double toastBottom, required String title, required String? content, required BuildContext context}) {
    _instance._removeToast(); // 기존 토스트 제거

    _instance._overlayEntry = OverlayEntry(
      builder: (context) => SwipeToast(
        toastBottom: toastBottom,
        title: title,
        content: content,
        onDismiss: _instance._removeToast,
      ),
    );

    Overlay.of(context).insert(_instance._overlayEntry!);
  }

  void _removeToast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class SwipeToast extends StatefulWidget {
  final double toastBottom;
  final String title;
  final String? content;
  final VoidCallback onDismiss;

  const SwipeToast({
    super.key,
    required this.toastBottom,
    required this.title,
    required this.content,
    required this.onDismiss,
  });

  @override
  State<StatefulWidget> createState() => _SwipeToastState();
}

class _SwipeToastState extends State<SwipeToast> {
  double _offsetY = 0.0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), _dismissToast);
  }

  void _dismissToast() {
    if (mounted) {
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(const Duration(milliseconds: 50), widget.onDismiss);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _offsetY + widget.toastBottom,
      left: 20,
      right: 20,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            // _offsetY 값을 제한하고, 내려갈 때 opacity를 점차적으로 감소
            _offsetY = (_offsetY - details.primaryDelta!).clamp(-double.infinity, 20);
            // opacity는 내려간 만큼 점차 줄어듦
            _opacity = (_offsetY < 0) ? 1 + (_offsetY / 200) : 1;
          });
        },
        onVerticalDragEnd: (details) {
          if (_offsetY < -50) {
            _dismissToast();
          } else {
            setState(() {
              _offsetY = 0; // 원래 자리로 복귀
              _opacity = 1.0; // 원래 투명도로 복귀
            });
          }
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 50),
          opacity: _opacity,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: ShapeDecoration(
              color: f_90,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('images/mypage/checkbox.svg', height: 24, width: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextStyle(style: s1_16Semi(Colors.white)!, child: Text(widget.title)),
                      if (widget.content != null) const SizedBox(height: 2),
                      if (widget.content != null) DefaultTextStyle(style: c4_12Reg(f_30)!, child: Text(widget.content!))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
