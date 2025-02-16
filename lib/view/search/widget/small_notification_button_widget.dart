import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/model/ticket/search_result_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/common/toast_widget.dart';

class SmallNotificationButtonWidget extends StatefulWidget {
  final bool isFavoriteArtist;
  final Artist artist;

  const SmallNotificationButtonWidget({super.key, required this.isFavoriteArtist, required this.artist});

  @override
  State<StatefulWidget> createState() => _SmallNotificationButtonWidgetState();
}

class _SmallNotificationButtonWidgetState extends State<SmallNotificationButtonWidget> {
  late bool _isPressed;
  late bool _showArrow;
  late ArtistRepository artistRepository;

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    _isPressed = widget.isFavoriteArtist;
    _showArrow = widget.isFavoriteArtist;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: AlignmentDirectional.centerEnd,
      width: _isPressed ? 24 : 95,
      height: 36,
      padding: _isPressed ? const EdgeInsets.all(0) : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: _showArrow ? Colors.transparent : pn_100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(42),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          if (!_isPressed) {
            HapticFeedback.lightImpact();
            final isSuccess = await artistRepository.addFavoriteArtist(widget.artist.artistId, context);
            if (isSuccess) {
              setState(() {
                _isPressed = true;
              });
              // 컨테이너가 먼저 확장된 후 화살표가 나타나도록 딜레이 추가
              Future.delayed(const Duration(milliseconds: 150), () {
                setState(() {
                  _showArrow = true;
                });
              });
              ToastManager.showToast(toastBottom: widget.toastBottom, title: '앞으로 ${widget.artist.name}의 티켓이 뜨면 알려드릴게요!', content: '마이페이지에서 해당 정보를 변경할 수 있어요.',context: context);
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!_isPressed) ...[
              SvgPicture.asset(
                'images/search/notification_null.svg',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                "알림 받기",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.67,
                  letterSpacing: -0.36,
                ),
              ),
            ] else ...[
              SvgPicture.asset(
                'images/search/arrow_right.svg',
                width: 24,
                height: 24,
              )
            ]
          ],
        ),
      ),
    );
  }
}
