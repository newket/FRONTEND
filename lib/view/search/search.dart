import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/search/search_detail.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Search(),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => _Search();
}

class _Search extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //배경
        backgroundColor: b_950,

        //앱바
        appBar: AppBar(
          backgroundColor: b_950,
          title: const Text("검색",
              style: TextStyle(fontFamily: 'Pretendard', fontSize: 20, color: b_100, fontWeight: FontWeight.w700)),
        ),

        //내용
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Container(
                    width: 66,
                    height: 66,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: p_700,
                          blurRadius: 66,
                          offset: Offset(0, 11.79),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SvgPicture.asset("images/search/search_ticket.svg", height: 69, width: 67)),
              ),
              const Text("아티스트 또는 공연명으로\n티켓을 검색해 보세요!",
                  style: TextStyle(fontFamily: 'Pretendard', fontSize: 20, color: b_100, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: b_900, // 내부 배경색
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: pt_50), // 테두리 색상 및 두께
                    borderRadius: BorderRadius.circular(42),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 검색 아이콘
                    Image.asset('images/navigator/search_on.png', height: 20,width: 20),
                    const SizedBox(width: 12),
                    // 텍스트 필드 (예시 텍스트)
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                          hintText: '관심 있는 공연을 검색해보세요!',
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
                            // 검색어 제출 시 페이지 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchDetail(keyword: value),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
