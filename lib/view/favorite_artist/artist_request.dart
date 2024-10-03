import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/theme/colors.dart';

class ArtistRequest extends StatefulWidget {
  const ArtistRequest({super.key});

  @override
  State<StatefulWidget> createState() => _ArtistRequest();
}

class _ArtistRequest extends State<ArtistRequest> {
  late ArtistRepository artistRepository;
  String artist = '';
  final TextEditingController _searchController = TextEditingController();
  Color nextColor = pt_30;

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
                  decoration: BoxDecoration(),
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

  Future<void> _requestArtist(String keyword) async {
    //제출
    if (keyword.isNotEmpty) {
      await artistRepository.requestArtist(keyword);
      setState(() {
        nextColor = pt_30;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        //배경
        backgroundColor: b_950,

        //앱바
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: b_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: const Text(
            "아티스트 등록 요청하기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //내용
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
            child: Stack(children: [
              Positioned.fill(
                  child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [b_950, Color(0xFF090C2B), Color(0xFF201D65)],
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 24),
                          child: Column(children: [
                            const SizedBox(height: 24),
                            const Text(
                              '등록을 원하시는\n아티스트를 입력해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: b_100,
                                fontSize: 20,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('요청하고자 하는 아티스트의 공식적인 활동명을 입력해주세요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: b_400,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(height: 48),
                            //검색
                            Container(
                                height: 44,
                                decoration: ShapeDecoration(
                                  color: isKeyboardVisible ? pt_20 : b_900, // 내부 배경색
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: pt_50), // 테두리 색상 및 두께
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
                                              decoration: const InputDecoration(
                                                hintText: '관심있는 아티스트를 입력해주세요!',
                                                border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                                                hintStyle: TextStyle(
                                                  color: b_500, // 텍스트 색상
                                                  fontSize: 12,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              onSubmitted: (value) {
                                                if (value.isNotEmpty) {
                                                  _requestArtist(value);
                                                  _searchController.clear();
                                                  showToast(context);
                                                }
                                              },
                                              controller: _searchController,
                                              inputFormatters: [
                                            LengthLimitingTextInputFormatter(30), // 최대 글자 수를 30자로 제한
                                          ])),
                                    ]))
                          ])))),
              Positioned(
                  bottom: 44, // 검색 창 바로 아래에 위치
                  left: 32,
                  right: 32,
                  child: GestureDetector(
                      onTap: () async {
                        //요청 전송
                        if (_searchController.value.text.isNotEmpty) {
                          _requestArtist(_searchController.value.text);
                          _searchController.clear();
                          showToast(context);
                        }
                      },
                      child: Column(
                        children: [
                          if (_searchController.value.text.isNotEmpty)
                            Container(
                                padding: const EdgeInsets.all(12),
                                height: 48,
                                decoration: ShapeDecoration(
                                  color: p_700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '뉴켓 팀에게 요청 보내기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ))
                          else
                            Container(
                                padding: const EdgeInsets.all(12),
                                height: 48,
                                decoration: ShapeDecoration(
                                  color: pt_30,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '뉴켓 팀에게 요청 보내기',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.3),
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ))
                        ],
                      )))
            ])));
  }
}
