import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/model/user_model.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/Colors.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<StatefulWidget> createState() => _Help();
}

class _Help extends State<Help> {
  late UserRepository userRepository;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _titleCharacters = 0;
  int _contentCharacters = 0;
  Color _titleBackgroundColor = b_900;
  Color _contentBackgroundColor = b_900;

  @override
  void initState() {
    super.initState();
    userRepository=UserRepository();
    _titleController.addListener(_updateCharacterCount);
    _contentController.addListener(_updateCharacterCount); // 글자 수 변동 리스너 추가
  }

  void _updateCharacterCount() {
    setState(() {
      _titleCharacters = _titleController.text.length;
      _contentCharacters = _contentController.text.length; // 남은 글자 수 계산
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateCharacterCount);
    _contentController.removeListener(_updateCharacterCount); // 리스너 제거
    _contentController.dispose();
    super.dispose();
  }

  void showToast(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 103.0, // Toast 위치 조정
        left: 20, // 화면의 가운데 정렬
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                SvgPicture.asset('images/mypage/checkbox.svg',height:24,width: 24),
                const SizedBox(width: 12),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문의가 완료되었어요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '더 나은 뉴켓을 위해 소중한 의견 주셔서 감사합니다 :)',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
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
            "문의하기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: b_950,
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                        color: Colors.transparent, //페이지 전체 탭하면 키보드 닫히도록
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    '문의 제목',
                                    style: TextStyle(
                                      color: b_100,
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '필수',
                                    style: TextStyle(
                                      color: p_500,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '$_titleCharacters/20자',
                                style: const TextStyle(
                                  color: b_500,
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                          ]),
                          const SizedBox(height: 8),
                        Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _titleBackgroundColor = hasFocus ? pt_20 : b_900;
                              });
                            },
                            child:
                          Container(
                              height: 44,
                              decoration: ShapeDecoration(
                                color: _titleBackgroundColor, // 내부 배경색
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
                                              hintText: '문의하고자 하는 사항의 제목을 입력해주세요.',
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
                                            onChanged: (value) {
                                              _updateCharacterCount();
                                            },
                                            controller: _titleController,
                                            inputFormatters: [
                                          LengthLimitingTextInputFormatter(20), // 최대 글자 수를 20자로 제한
                                        ])),
                                  ]))),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    '문의 내용',
                                    style: TextStyle(
                                      color: b_100,
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '필수',
                                    style: TextStyle(
                                      color: p_500,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '$_contentCharacters/300자',
                                style: const TextStyle(
                                  color: b_500,
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                        Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _contentBackgroundColor = hasFocus ? pt_20 : b_900;
                              });
                            },
                            child:
                          Container(
                              height: 303,
                              decoration: ShapeDecoration(
                                color: _contentBackgroundColor, // 내부 배경색
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: pt_50), // 테두리 색상 및 두께
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: TextField(
                                            decoration: const InputDecoration(
                                              hintText: '자세한 내용을 입력해주세요.\n\n\n\n\n\n\n\n\n\n\n\n\n\n',
                                              border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                                              hintStyle: TextStyle(
                                                color: b_500, // 텍스트 색상
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            maxLines: null, // 줄바꿈 허용
                                            keyboardType: TextInputType.multiline, // 여러 줄 입력 가능
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            onChanged: (value) {
                                              _updateCharacterCount();
                                            },
                                            controller: _contentController,
                                            inputFormatters: [
                                          LengthLimitingTextInputFormatter(300), // 최대 글자 수를 300자로 제한
                                        ]))
                                  ])))
                        ]))),
                Positioned(
                    bottom: 44,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '뉴켓의 발전을 위한 소중한 의견 감사합니다!\n뉴켓 팀이 최대한 빠르게 검토하고 반영하도록 하겠습니다',
                          style: TextStyle(
                            color: b_400,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_titleController.value.text.isNotEmpty && _contentController.value.text.isNotEmpty)
                          ElevatedButton(
                            onPressed: () async {
                              await userRepository.createHelp(context, HelpRequest(_titleController.value.text, _contentController.value.text));
                              _titleController.clear();
                              _contentController.clear();
                              showToast(context);
                              Navigator.pop(context); //뒤로가기
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: p_700, // 버튼 색상
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 48), // 버튼 높이 조정
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '문의 완료하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pt_30, // 버튼 색상
                              padding: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(0, 48), // 버튼 높이 조정
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '문의 완료하기',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ))
              ],
            )));
  }
}
