import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/theme/colors.dart';

class ArtistRequestV2 extends StatefulWidget {
  const ArtistRequestV2({super.key});

  @override
  State<StatefulWidget> createState() => _ArtistRequestV2();
}

class _ArtistRequestV2 extends State<ArtistRequestV2> {
  late ArtistRepository artistRepository;
  String artist = '';
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _artistInfoController = TextEditingController();
  Color nextColor = v1pt_30;
  final FocusNode _artistNode = FocusNode();
  final FocusNode _artistInfoNode = FocusNode();


  void showToast(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 116.0, // Toast 위치 조정
        left: 20, // 화면의 가운데 정렬
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: b_800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.check,
                    color: p_500,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '아티스트 등록 요청이 성공적으로 보내졌어요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '등록이 완료되면 알려드릴게요',
                      style: TextStyle(
                        color: b_400,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // 5초 후에 Toast를 자동으로 제거
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  Future<void> _requestArtist(String artistName, String? artistInfo) async {
    //제출
    final deviceToken = await FirebaseMessaging.instance.getToken();

    if (artistName.isNotEmpty) {
      await artistRepository.requestArtist(ArtistRequest(
          artistName: artistName,
          artistInfo: artistInfo,
          deviceToken: deviceToken!
      ));
      setState(() {
        nextColor = v1pt_30;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    _artistNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경될 때마다 상태를 업데이트
    });
    _artistInfoNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경될 때마다 상태를 업데이트
    });
  }


  @override
  void dispose() {
    _artistController.dispose();
    _artistInfoController.dispose();
    _artistNode.dispose();
    _artistInfoNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,

        //앱바
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: f_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "아티스트 등록 요청하기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: f_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //내용
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Row(children: [
                  Text(
                    '아티스트 이름',
                    style: TextStyle(color: f_100, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '필수',
                    style:
                        TextStyle(color: pn_100, fontSize: 12, fontFamily: 'Pretendard', fontWeight: FontWeight.w400),
                  )
                ]),
                const SizedBox(height: 8),
                Container(
                    height: 44,
                    decoration: ShapeDecoration(
                      color: _artistNode.hasFocus ? pt_10 : Colors.white, // 내부 배경색
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: _artistNode.hasFocus ? pt_60 : pt_30), // 테두리 색상 및 두께
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextField(
                                focusNode: _artistNode,
                                  decoration: const InputDecoration(
                                    hintText: '등록되었으면 하는 아티스트의 이름 또는 예명을 입력해주세요.',
                                    border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                                    hintStyle: TextStyle(
                                      color: f_50, // 텍스트 색상
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: f_90,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: _artistController,
                                  inputFormatters: [
                                LengthLimitingTextInputFormatter(28), // 최대 글자 수를 30자로 제한
                              ])),
                        ])),
                const SizedBox(height: 24),
                const Text(
                  '아티스트 정보',
                  style: TextStyle(color: f_100, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                    height: 44,
                    decoration: ShapeDecoration(
                      color: _artistInfoNode.hasFocus ? pt_10 : Colors.white, // 내부 배경색
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: _artistInfoNode.hasFocus ? pt_60 : pt_30), // 테두리 색상 및 두께
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextField(
                                focusNode: _artistInfoNode,
                                  decoration: const InputDecoration(
                                    hintText: '해당 아티스트에 대한 추가적인 정보가 있다면 입력해주세요.',
                                    border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                                    hintStyle: TextStyle(
                                      color: f_50, // 텍스트 색상
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: f_90,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: _artistInfoController,
                                  inputFormatters: [
                                LengthLimitingTextInputFormatter(28), // 최대 글자 수를 30자로 제한
                              ])),

                        ]))
              ])),
        ),
        bottomNavigationBar: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 40,
            height: 122,
            padding: const EdgeInsets.only(bottom: 54, top: 12, left: 20, right: 20),
            child: ElevatedButton(
              onPressed: () async {
                // 요청 전송
                if (_artistController.value.text.isNotEmpty) {
                  _requestArtist(_artistController.value.text,_artistInfoController.value.text);
                  _artistController.clear();
                  _artistInfoController.clear();
                  //showToast(context);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0, // 그림자 제거
                backgroundColor: _artistController.value.text.isNotEmpty ? pn_100 : f_10, // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16), // 상하 패딩
                //fixedSize: Size(MediaQuery.of(context).size.width - 40, 56), // 고정 크기
              ),
              child: Text(
                '요청 완료하기',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: _artistController.value.text.isNotEmpty ? Colors.white : f_30),
              ),
            )));
  }
}
