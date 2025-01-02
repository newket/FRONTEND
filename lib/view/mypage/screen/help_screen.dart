import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/user_model.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/toast_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HelpScreen();
}

class _HelpScreen extends State<HelpScreen> {
  late UserRepository userRepository;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int _titleCharacters = 0;
  int _contentCharacters = 0;
  Color _titleBackgroundColor = Colors.white;
  Color _contentBackgroundColor = Colors.white;
  Color _emailBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //키보드가 올라 오지 않도록
      appBar: appBarBack(context, "문의하기"),
      backgroundColor: Colors.white,
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
          child: Container(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              color: Colors.transparent, //페이지 전체 탭하면 키보드 닫히도록
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Row(
                    children: [
                      Text(
                        '문의 제목',
                        style: TextStyle(
                            color: f_100, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '필수',
                        style: TextStyle(
                            color: pn_100, fontSize: 12, fontFamily: 'Pretendard', fontWeight: FontWeight.w400),
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
                        _titleBackgroundColor = hasFocus ? pt_10 : Colors.white;
                      });
                    },
                    child: Container(
                        height: 44,
                        decoration: ShapeDecoration(
                          color: _titleBackgroundColor, // 내부 배경색
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: v1pt_50), // 테두리 색상 및 두께
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
                              color: f_100, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '필수',
                          style: TextStyle(
                              color: pn_100, fontSize: 12, fontFamily: 'Pretendard', fontWeight: FontWeight.w400),
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
                        _contentBackgroundColor = hasFocus ? pt_10 : Colors.white;
                      });
                    },
                    child: Container(
                        height: 303,
                        decoration: ShapeDecoration(
                          color: _contentBackgroundColor, // 내부 배경색
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: v1pt_50), // 테두리 색상 및 두께
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
                                      maxLines: null,
                                      // 줄바꿈 허용
                                      keyboardType: TextInputType.multiline,
                                      // 여러 줄 입력 가능
                                      onChanged: (value) {
                                        _updateCharacterCount();
                                      },
                                      controller: _contentController,
                                      inputFormatters: [
                                    LengthLimitingTextInputFormatter(300), // 최대 글자 수를 300자로 제한
                                  ]))
                            ]))),
                const SizedBox(height: 20),
                const Text(
                  '답변 받을 이메일',
                  style: TextStyle(color: f_100, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _emailBackgroundColor = hasFocus ? pt_10 : Colors.white;
                      });
                    },
                    child: Container(
                        height: 44,
                        decoration: ShapeDecoration(
                          color: _emailBackgroundColor, // 내부 배경색
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: v1pt_50), // 테두리 색상 및 두께
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 10, bottom:12, right: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: '문의에 대한 답변을 원하신다면 전달 받으실 이메일을 입력해주세요.',
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
                                      onChanged: (value) {
                                        _updateCharacterCount();
                                      },
                                      controller: _emailController,
                                      maxLines: 1, // 한 줄로 제한
                                      scrollPhysics: const BouncingScrollPhysics(),
                                      inputFormatters: [
                                    LengthLimitingTextInputFormatter(50), // 최대 글자 수를 50자로 제한
                                  ]
                                  )),
                            ])))
              ]))),
      bottomNavigationBar: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width - 40,
          height: 122,
          padding: const EdgeInsets.only(bottom: 54, top: 12, left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () async {
              // 요청 전송
              if (_titleController.value.text.isNotEmpty && _contentController.value.text.isNotEmpty) {
                await userRepository.createHelp(
                    context, HelpRequest(_titleController.value.text, _contentController.value.text, _emailController.value.text));
                _titleController.clear();
                _contentController.clear();
                showToast(74, '문의가 완료되었어요!', '더 나은 뉴켓을 위해 소중한 의견 주셔서 감사합니다.', context);
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0, // 그림자 제거
              backgroundColor: (_titleController.value.text.isNotEmpty && _contentController.value.text.isNotEmpty)
                  ? pn_100
                  : f_10, // 버튼 배경색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16), // 상하 패딩
              //fixedSize: Size(MediaQuery.of(context).size.width - 40, 56), // 고정 크기
            ),
            child: Text(
              '문의 완료하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  color: (_titleController.value.text.isNotEmpty && _contentController.value.text.isNotEmpty)
                      ? Colors.white
                      : f_30),
            ),
          )),
    );
  }
}
