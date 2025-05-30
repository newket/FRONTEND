import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/artist/artist_request.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/view/common/toast_widget.dart';

class ArtistRequestScreen extends StatefulWidget {
  const ArtistRequestScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ArtistRequestScreen();
}

class _ArtistRequestScreen extends State<ArtistRequestScreen> {
  late ArtistRepository artistRepository;
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _artistInfoController = TextEditingController();
  Color nextColor = v1pt_30;
  final FocusNode _artistNode = FocusNode();
  final FocusNode _artistInfoNode = FocusNode();

  Future<void> _requestArtist(String artistName, String? artistInfo) async {
    //제출
    const storage = FlutterSecureStorage();
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");

    if (artistName.isNotEmpty) {
      await artistRepository
          .requestArtist(ArtistRequest(artistName: artistName, artistInfo: artistInfo, deviceToken: deviceToken!));
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: appBarBack(context, "아티스트 등록 요청하기"),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('아티스트 이름', style: s1_16Semi(f_100)),
                  const SizedBox(width: 8),
                  Text('필수', style: c4_12Reg(pn_100))
                ]),
                const SizedBox(height: 8),
                Container(
                    height: 44,
                    decoration: ShapeDecoration(
                        color: _artistNode.hasFocus ? pt_10 : Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: _artistNode.hasFocus ? pt_60 : pt_30),
                            borderRadius: BorderRadius.circular(12))),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextField(
                                  focusNode: _artistNode,
                                  decoration: InputDecoration(
                                      hintText: '등록되었으면 하는 아티스트의 이름 또는 예명을 입력해주세요.',
                                      border: InputBorder.none,
                                      // 입력 필드의 기본 테두리 제거
                                      isCollapsed: true,
                                      // 내부 패딩 제거
                                      contentPadding: EdgeInsets.zero,
                                      // 추가 패딩 제거
                                      hintStyle: c4_12Reg(f_50)),
                                  style: c4_12Reg(f_90),
                                  controller: _artistController,
                                  inputFormatters: [
                                LengthLimitingTextInputFormatter(50), // 최대 글자 수를 50자로 제한
                              ])),
                        ])),
                const SizedBox(height: 24),
                Text('아티스트 정보', style: s1_16Semi(f_100)),
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
                    padding: const EdgeInsets.all(12),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextField(
                                  focusNode: _artistInfoNode,
                                  decoration: InputDecoration(
                                      hintText: '해당 아티스트에 대한 추가적인 정보가 있다면 입력해주세요.',
                                      border: InputBorder.none,
                                      // 입력 필드의 기본 테두리 제거
                                      isCollapsed: true,
                                      // 내부 패딩 제거
                                      contentPadding: EdgeInsets.zero,
                                      // 추가 패딩 제거
                                      hintStyle: c4_12Reg(f_50)),
                                  style: c4_12Reg(f_90),
                                  controller: _artistInfoController,
                                  inputFormatters: [
                                LengthLimitingTextInputFormatter(50), // 최대 글자 수를 50자로 제한
                              ])),
                        ]))
              ])),
        ),
        bottomNavigationBar: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 40,
            height: 88 + MediaQuery.of(context).viewPadding.bottom,
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 20, top: 12, left: 20, right: 20),
            child: ElevatedButton(
              onPressed: () async {
                // 요청 전송
                if (_artistController.value.text.isNotEmpty) {
                  ToastManager.showToast(
                      toastBottom: 40,
                      title: '아티스트 등록 요청이 완료되었어요!',
                      content: '요청하신 아티스트를 빠른 시일 내로 등록해드릴게요.',
                      context: context);
                  Navigator.pop(context); //뒤로가기
                  await _requestArtist(_artistController.value.text, _artistInfoController.value.text);
                  _artistController.clear();
                  _artistInfoController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                // 그림자 제거
                backgroundColor: _artistController.value.text.isNotEmpty ? pn_100 : f_10,
                // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                // 상하 패딩
                shadowColor: Colors.transparent,
              ).copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text('요청 완료하기',
                  textAlign: TextAlign.center,
                  style: button1_16Semi(_artistController.value.text.isNotEmpty ? Colors.white : f_30)),
            )));
  }
}
