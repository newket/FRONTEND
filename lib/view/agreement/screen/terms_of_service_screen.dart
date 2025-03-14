import 'package:flutter/material.dart';
import 'package:newket/view/common/app_bar_back.dart';
import 'package:newket/constant/colors.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<StatefulWidget> createState() => _TermsOfService();
}

class _TermsOfService extends State<TermsOfService> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle title = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14,
      color: f_100,
      fontWeight: FontWeight.w500,
    );
    TextStyle content = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      color: f_100,
      fontWeight: FontWeight.w400,
    );
    return Scaffold(
        //배경
        backgroundColor: Colors.white,

        //앱바
        appBar: appBarBack(context, "서비스 이용약관"),

        //내용
        body: SingleChildScrollView(
            //스크롤 가능
            child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(
                    children: [
                      Text(
                        "서비스 이용약관",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 20,
                          color: f_100,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 16),
                  //제 1조
                  Text(
                    "제1조(목적)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "본 약관은 뉴켓가 운영하는 플랫폼에서 제공하는 서비스(이하 '서비스'라 합니다)를 이용함에 있어 당사자의 권리 의무 및 책임사항을 규정하는 것을 목적으로 합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 본 약관을 준용합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 2조
                  Text(
                    "제2조(정의)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'라 함은, '뉴켓'가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화등을 거래할 수 있도록 설정한 가상의 영업장을 운영하는 사업자를 말합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'이용자'라 함은, '사이트'에 접속하여 본 약관에 따라 '회사'가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회원'이라 함은, '회사'에 개인정보를 제공하고 회원으로 등록한 자로서, '회사'의 서비스를 계속하여 이용할 수 있는 자를 말합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "4. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'비회원'이라 함은, 회원으로 등록하지 않고, '회사'가 제공하는 서비스를 이용하는 자를 말합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "5. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'상품'이라 함은 '사이트'를 통하여 제공되는 재화 또는 용역을 말합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "6. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'구매자'라 함은 '회사'가 제공하는 '상품'에 대한 구매서비스의 이용을 청약한 '회원' 및 '비회원'을 말합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 3조
                  Text(
                    "제3조(약관 외 준칙)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "본 약관에서 정하지 아니한 사항은 법령 또는 회사가 정한 서비스의 개별 약관, 운영정책 및 규칙(이하 '세부지침'이라 합니다)의 규정에 따릅니다. 또한 본 약관과 세부지침이 충돌할 경우에는 세부지침이 우선합니다.",
                    style: content,
                  ),
                  const SizedBox(height: 16),
                  //제 4조
                  Text(
                    "제4조(약관의 명시 및 개정)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'는 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지, 전화번호, 모사전송번호(FAX), 전자우편주소, 사업자등록번호, 통신판매업신고번호 등을 이용자가 쉽게 알 수 있도록 '회사' 홈페이지의 초기 서비스화면에 게시합니다. 다만 본 약관의 내용은 '이용자'가 연결화면을 통하여 확인할 수 있도록 할 수 있습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'는 '이용자'가 약관에 동의하기에 앞서 약관에 정해진 내용 중 청약철회, 배송책임, 환불조건 등과 같은 내용을 '이용자'가 이해할 수 있도록 별도의 연결화면 또는 팝업화면 등을 통하여 '이용자'의 확인을 구합니다. ",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'는 ‘전자상거래 등에서의 소비자보호에 관한 법률(이하 '전자상거래법'이라 함)', '약관의 규제에 관한 법률(이하 '약관규제법'이라 함)', '전자문서 및 전자거래 기본법(이하 '전자문서법'이라 함)', ‘전자금융거래법 ‘, '정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 '정보통신망법'이라 함)', '소비자기본법' 등 관계 법령(이하 '관계법령' 이라 함)에 위배되지 않는 범위 내에서 본 약관을 개정할 수 있습니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "4. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'가 본 약관을 개정하고자 할 경우, 적용일자 및 개정사유를 명시하여 현행약관과 함께 온라인 쇼핑몰의 초기화면에 그 적용일자 7일전부터 적용일자 전날까지 공지합니다. 다만, '이용자'에게 불리한 내용으로 약관을 변경하는 경우 최소 30일 이상 유예기간을 두고 공지합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "5. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'가 본 약관을 개정한 경우, 개정약관은 적용일자 이후 체결되는 계약에만 적용되며 적용일자 이전 체결된 계약에 대해서는 개정 전 약관이 적용됩니다. 다만, 이미 계약을 체결한 '이용자'가 개정약관의 내용을 적용받고자 하는 뜻을 '회사'에 전달하고 '회사'가 여기에 동의한 경우 개정약관을 적용합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "6. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "본 약관에서 정하지 아니한 사항 및 본 약관의 해석에 관하여는 관계법령 및 건전한 상관례에 따릅니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "7. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "티켓에 대한 예매일 정보 제공",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "8. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "기타 '회사'가 정하는 업무",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 5조
                  Text(
                    "제5조(서비스의 중단 등)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'가 제공하는 서비스는 연중무휴, 1일 24시간 제공을 원칙으로 합니다. 다만 '회사' 시스템의 유지 · 보수를 위한 점검, 통신장비의 교체 등 특별한 사유가 있는 경우 서비스의 전부 또는 일부에 대하여 일시적인 제공 중단이 발생할 수 있습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'는 전시, 사변, 천재지변 또는 이에 준하는 국가비상사태가 발생하거나 발생할 우려가 있는 경우, 전기통신사업법에 의한 기간통신사업자가 전기통신서비스를 중지하는 등 부득이한 사유가 발생한 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "3. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'플랫폼'은 재화 또는 용역이 품절되거나 상세 내용이 변경되는 경우 장차 체결되는 계약에 따라 제공할 재화나 용역의 내용을 변경할 수 있습니다. 이 경우 변경된 재화 또는 용역의 내용 및 제공일자를 명시하여 즉시 공지합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "4. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'가 서비스를 정지하거나 이용을 제한하는 경우 그 사유 및 기간, 복구 예정 일시 등을 지체 없이 '이용자'에게 알립니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  //제 6조
                  Text(
                    "제6조(회원가입)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'가 정한 양식에 따라 '이용자'가 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "'회사'는 전항에 따라 회원가입을 신청한 '이용자' 중 다음 각호의 사유가 없는 한 '회원'으로 등록합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "가입신청자가 본 약관에 따라 회원자격을 상실한 적이 있는 경우. 다만, '회사'의 재가입 승낙을 얻은 경우에는 예외로 합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "회원정보에 허위, 기재누락, 오기 등 불완전한 부분이 있는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "기타 회원으로 등록하는 것이 '회사'의 운영에 현저한 지장을 초래하는 것으로 인정되는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "회원가입 시기는 '회사'의 가입승낙 안내가 '회원'에게 도달한 시점으로 합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 7조
                  Text(
                    "제7조(회원탈퇴 및 자격상실 등)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회원'은 '회사'에 언제든지 탈퇴를 요청할 수 있으며, '회사'는 지체없이 회원탈퇴 요청을 처리합니다. 다만 이미 체결된 거래계약을 이행할 필요가 있는 경우에는 본약관이 계속 적용됩니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "'플랫폼'은 다음 각호의 사유가 발생한 경우 '회사'의 자격을 제한 또는 정지시킬 수 있습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "회원가입 시 허위정보를 기재한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "다른 이용자의 정상적인 이용을 방해하는 경우 ",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "관계법령 또는 본 약관에서 금지하는 행위를 한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "d. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "공서양속에 어긋나는 행위를 한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "e. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "기타 '회원'으로 등록하는 것이 적절하지 않은 것으로 판단되는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  const SizedBox(height: 16),
                  //제 8조
                  Text(
                    "제8조(회원에 대한 통지)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'는 '회원' 회원가입 시 기재한 전자우편, 이동전화번호, 주소 등을 이용하여 '회원'에게 통지 할 수 있습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'가 불특정 다수 '회원'에게 통지하고자 하는 경우 1주일 이상 '사이트'의 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다. 다만 '회원'이 서비스를 이용함에 있어 중요한 사항에 대하여는 개별 통지합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 9조
                  Text(
                    "제9조(계약의 성립)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "1. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "'회사'는 다음 각호의 사유가 있는 경우 본 약관의 '구매신청' 조항에 따른 구매신청을 승낙하지 않을 수 있습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "신청 내용에 허위, 누락, 오기가 있는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "회원자격이 제한 또는 정지된 고객이 구매를 신청한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "재판매, 기타 부정한 방법이나 목적으로 구매를 신청하였음이 인정되는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "d. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "기타 구매신청을 승낙하는 것이 '회사'의 기술상 현저한 지장을 초래하는 것으로 인정되는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'의 승낙이 본 약관의 '수신확인통지' 형태로 이용자에게 도달한 시점에 계약이 성립한 것으로 봅니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'가 승낙의 의사표시를 하는 경우 이용자의 구매신청에 대한 확인 및 판매가능여부, 구매신청의 정정 및 취소 등에 관한 정보가 포함되어야 합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 10조
                  Text(
                    "제10조(수신확인통지, 구매신청 변경 및 취소)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'는 '구매자'가 구매신청을 한 경우 '구매자'에게 수신확인통지를 합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "수신확인통지를 받은 '구매자'는 의사표시의 불일치가 있는 경우 수신확인통지를 받은 후 즉시 구매신청 내용의 변경 또는 취소를 요청할 수 있고, '회사'는 배송 준비 전 '구매자'의 요청이 있는 경우 지체없이 그 요청에 따라 변경 또는 취소처리 하여야 합니다. 다만 이미 대금을 지불한 경우 본 약관의 '청약철회 등'에서 정한 바에 따릅니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 11조
                  Text(
                    "제11조(개인정보보호)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "1. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "'회사'는 '구매자'의 정보수집시 다음의 필수사항 등 구매계약 이행에 필요한 최소한의 정보만을 수집합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "성명",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "주민등록번호 또는 외국인등록번호",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "주소",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "d. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "전화번호(또는 이동전화번호)",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "e. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "아이디(ID)",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "f. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "비밀번호",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "g. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "전자우편(e-mail)주소",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'가 개인정보보호법 상의 고유식별정보 및 민감정보를 수집하는 때에는 반드시 대상자의 동의를 받습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          "'회사'는 제공된 개인정보를 '구매자'의 동의 없이 목적외 이용, 또는 제3자 제공할 수 없으며 이에 대한 모든 책임은 '회사'가 부담합니다. 다만 다음의 경우에는 예외로 합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "배송업무상 배송업체에게 배송에 필요한 최소한의 정보(성명, 주소, 전화번호)를 제공하는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "재화 등의 거래에 따른 대금정산을 위하여 필요한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "d. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "도용방지를 위하여 본인 확인이 필요한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "e. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "관계법령의 규정에 따른 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "4. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "본 약관에 기재된 사항 이외의 개인정보보호에 관항 사항은 '회사'의 '개인정보처리방침'에 따릅니다. ",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 12조
                  Text(
                    "제12조('회사'의 의무)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'는 관계법령, 본 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 약관이 정하는 바에 따라 지속적 · 안정적으로 재화 및 용역을 제공하는데 최선을 다하여야 합니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'는 '이용자'가 안전하게 인터넷 서비스를 이용할 수 있도록 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'가 상품에 대하여 '표시 · 광고의 공정화에 관한 법률' 제3조 소정의 부당한 표시 · 광고행위를 하여 '이용자'가 손해를 입은 때에는 이를 배상할 책임을 집니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "4. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'는 '이용자'의 수신동의 없이 영리목적으로 광고성 전자우편, 휴대전화 메시지, 전화, 우편 등을 발송하지 않습니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 13조
                  Text(
                    "제13조(이용자 및 회원의 의무)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'이용자'는 회원가입 신청 시 사실에 근거하여 신청서를 작성해야 합니다. 허위, 또는 타인의 정보를 등록한 경우 '회사'에 대하여 일체의 권리를 주장할 수 없으며, '회사'는 이로 인하여 발생한 손해에 대하여 책임을 부담하지 않습니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'이용자'는 본 약관에서 규정하는 사항과 기타 '회사'가 정한 제반 규정 및 공지사항을 준수하여야 합니다. 또한 '이용자'는 '회사'의 업무를 방해하는 행위 및 '회사'의 명예를 훼손하는 행위를 하여서는 안 됩니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'이용자'는 주소, 연락처, 전자우편 주소 등 회원정보가 변경된 경우 즉시 이를 수정해야 합니다. 변경된 정보를 수정하지 않거나 수정을 게을리하여 발생하는 책임은 '이용자'가 부담합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "4. ",
                      style: content,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "'이용자'는 다음의 행위를 하여서는 안됩니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "a. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "'회사'에 게시된 정보의 변경",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "b. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "'회사'가 정한 정보 외의 다른 정보의 송신 또는 게시",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "c. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "'회사' 및 제3자의 저작권 등 지식재산권에 대한 침해",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "d. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "'회사' 및 제3자의 명예를 훼손하거나 업무를 방해하는 행위",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            "e. ",
                            style: content,
                          ),
                          Expanded(
                              child: Text(
                            "외설 또는 폭력적인 메시지, 화상, 음성 기타 관계법령 및 공서양속에 반하는 정보를 '회사'의 '사이트'에 공개 또는 게시하는 행위",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                        ]),
                      ],
                    ))
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "5. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회원'은 부여된 아이디(ID)와 비밀번호를 직접 관리해야 합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "6. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회원'이 자신의 아이디(ID) 및 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 '회사'에 통보하고 안내에 따라야 합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 14조
                  Text(
                    "제14조(저작권의 귀속 및 이용)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'플랫폼'이 제공하는 서비스 및 이와 관련된 모든 지식재산권은 '회사'에 귀속됩니다",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'이용자'는 ''에게 지식재산권이 있는 정보를 사전 승낙없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나, 제3자가 이용하게 하여서는 안됩니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'이용자'가 서비스 내에 게시한 게시물, 이용후기 등 콘텐츠(이하 '콘텐츠')의 저작권은 해당 '콘텐츠'의 저작자에게 귀속됩니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 16),
                  //제 15조
                  Text(
                    "제15조(분쟁의 해결)",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "'회사'는 '이용자'가 제기하는 불만사항 및 의견을 지체없이 처리하기 위하여 노력합니다. 다만 신속한 처리가 곤란한 경우 '이용자'에게 그 사유와 처리일정을 즉시 통보해 드립니다.",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible, // 넘치는 텍스트 처리
                        ),
                      )
                    ],
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "2. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'와 '이용자'간 전자상거래에 관한 분쟁이 발생한 경우, '이용자'는 한국소비자원, 전자문서 · 전자거래분쟁조정위원회 등 분쟁조정기관에 조정을 신청할 수 있습니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "3. ",
                      style: content,
                    ),
                    Expanded(
                        child: Text(
                      "'회사'와 '이용자'간 발생한 분쟁에 관한 소송은 민사소송법에 따른 관할법원에 제기하며, 준거법은 대한민국의 법령을 적용합니다.",
                      style: content,
                      softWrap: true, // 줄바꿈 허용
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                  const SizedBox(height: 32),
                  //부칙
                  Text(
                    "부칙",
                    style: title,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "제1조 본 방침은 2024.09.25.부터 시행됩니다.",
                    style: content,
                  ),
                  const SizedBox(height: 100)
                ]))));
  }
}
