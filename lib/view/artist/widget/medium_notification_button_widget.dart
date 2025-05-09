import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/config/notification_permission.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_dto.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/view/artist/widget/artist_notification_cancel_popup_widget.dart';
import 'package:newket/view/common/notification_disabled_popup_widget.dart';
import 'package:newket/view/common/toast_widget.dart';

class MediumNotificationButtonWidget extends StatefulWidget {
  final bool isFavoriteArtist;
  final ArtistDto artist;

  const MediumNotificationButtonWidget({super.key, required this.isFavoriteArtist, required this.artist});

  @override
  State<StatefulWidget> createState() => _MediumNotificationButtonWidget();
}

class _MediumNotificationButtonWidget extends State<MediumNotificationButtonWidget> {
  late bool _isPressed;
  late NotificationRequestRepository notificationRequestRepository;

  @override
  void initState() {
    super.initState();
    notificationRequestRepository = NotificationRequestRepository();
    _isPressed = widget.isFavoriteArtist;
  }

  @override
  void didUpdateWidget(covariant MediumNotificationButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavoriteArtist != oldWidget.isFavoriteArtist) {
      if (mounted) {
        setState(() {
          _isPressed = widget.isFavoriteArtist;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      width: 136,
      height: 44,
      padding: _isPressed ? const EdgeInsets.all(0) : const EdgeInsets.symmetric(vertical: 11),
      decoration: ShapeDecoration(
        color: _isPressed ? f_40 : pn_100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(42),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          if (!_isPressed) {
            HapticFeedback.lightImpact();
            final isSuccess =
                await notificationRequestRepository.postArtistNotification(widget.artist.artistId, context);
            if (isSuccess) {
              setState(() {
                _isPressed = true;
              });
              ToastManager.showToast(
                  toastBottom: 40,
                  title: '아티스트 알림이 설정되었어요',
                  content: '${widget.artist.name}의 새로운 티켓 소식을 가장 먼저 전해 드릴게요!',
                  context: context);
              if (!await NotificationPermissionManager.isNotificationEnabled()) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(
                          insetPadding: EdgeInsets.zero, child: NotificationDisabledPopupWidget());
                    });
              }
            }
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: ArtistNotificationCancelPopupWidget(
                        artist: widget.artist,
                        onConfirm: () async {
                          await notificationRequestRepository.deleteArtistNotification(widget.artist.artistId, context);
                          setState(() {
                            _isPressed = false;
                          });
                          Navigator.of(context).pop();
                          ToastManager.showToast(toastBottom: 40, title: '알림이 해제되었어요', content: null, context: context);
                        },
                      ));
                });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isPressed) ...[
              SvgPicture.asset('images/search/notification_null.svg', width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                "알림 받기",
                style: button2_14Semi(Colors.white),
              ),
            ] else ...[
              SvgPicture.asset('images/ticket/notification_on.svg', width: 20, height: 20),
              const SizedBox(width: 8),
              Text("알림 받는 중", style: button2_14Semi(Colors.white)),
            ]
          ],
        ),
      ),
    );
  }
}
