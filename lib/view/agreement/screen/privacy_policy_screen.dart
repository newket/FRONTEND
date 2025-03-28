import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/common/app_bar_back.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyScreen();
}

class _PrivacyPolicyScreen extends State<PrivacyPolicyScreen> {
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
        appBar: appBarBack(context, "개인정보처리 방침"),

        //내용
        body: SingleChildScrollView(
          //스크롤 가능
            child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "개인정보처리 방침",
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
                    Text(
                      "뉴켓(이하 '회사'라고 함)는 회사가 제공하고자 하는 서비스(이하 ‘회사 서비스’)를 이용하는 개인(이하 ‘이용자’ 또는 ‘개인’)의 정보(이하 ‘개인정보’)를 보호하기 위해, 개인정보보호법, 정보통신망이용촉진 및 정보보호 등에 관한 법률(이하 '정보통신망법') 등 관련 법령을 준수하고, 서비스 이용자의 개인정보 보호 관련한 고충을신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침(이하 ‘본 방침’)을 수립합니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 2조
                    Text(
                      "제2조(개인정보 처리의 원칙)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "개인정보 관련 법령 및 본 방침에 따라 회사는 이용자의 개인정보를 수집할 수 있으며 수집된 개인정보는 개인의 동의가 있는 경우에 한해 제3자에게 제공될 수 있습니다. 단, 법령의 규정 등에 의해 적법하게 강제되는 경우 회사는 수집한 이용자의 개인정보를 사전에 개인의 동의 없이 제3자에게 제공할 수도 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 3조
                    Text(
                      "제3조(본 방침의 공개)",
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
                            "회사는 이용자가 언제든지 쉽게 본 방침을 확인할 수 있도록 회사 홈페이지 첫 화면 또는 첫 화면과의 연결화면을 통해 본 방침을 공개하고 있습니다.",
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
                            "회사는 제1항에 따라 본 방침을 공개하는 경우 글자 크기, 색상 등을 활용하여 이용자가 본 방침을 쉽게 확인할 수 있도록 합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 4조
                    Text(
                      "제4조(본 방침의 변경)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "본 방침은 개인정보 관련 법령, 지침, 고시 또는 정부나 회사 서비스의 정책이나 내용의 변경에 따라 개정될 수 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                "회사는 제1항에 따라 본 방침을 개정하는 경우 다음 각 호 하나 이상의 방법으로 공지합니다.",
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
                                      "회사가 운영하는 인터넷 홈페이지의 첫 화면의 공지사항란 또는 별도의 창을 통하여 공지하는 방법",
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
                                      "서면·모사전송·전자우편 또는 이와 비슷한 방법으로 이용자에게 공지하는 방법",
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
                            "회사는 제2항의 공지는 본 방침 개정의 시행일로부터 최소 7일 이전에 공지합니다. 다만, 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 공지합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 5조
                    Text(
                      "제5조(회원 가입을 위한 정보)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 이용자의 회사 서비스에 대한 회원가입을 위하여 다음과 같은 정보를 수집합니다. \n필수 수집 정보:이메일 주소, 닉네임\n선택 수집 정보: 생일",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 6조
                    Text(
                      "제6조(개인정보 수집 방법)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 다음과 같은 방법으로 이용자의 개인정보를 수집합니다.",
                      style: content,
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자가 회사의 홈페이지에 자신의 개인정보를 입력하는 방식",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "어플리케이션 등 회사가 제공하는 홈페이지 외의 서비스를 통해 이용자가 자신의 개인정보를 입력하는 방식",
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
                            "외부 SNS api를 통해 입력 받는 방식",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 7조
                    Text(
                      "제7조(개인정보의 이용)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 개인정보를 다음 각 호의 경우에 이용합니다.",
                      style: content,
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "공지사항의 전달 등 회사운영에 필요한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용문의에 대한 회신, 불만의 처리 등 이용자에 대한 서비스 개선을 위한 경우",
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
                            "회사의 서비스를 제공하기 위한 경우",
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
                            "법령 및 회사 약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제재를 위한 경우",
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
                            "이벤트 및 행사 안내 등 마케팅을 위한 경우",
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
                            "인구통계학적 분석, 서비스 방문 및 이용기록의 분석을 위한 경우",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 8조
                    Text(
                      "제8조(개인정보의 처리 위탁)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 원활한 서비스 제공과 효과적인 업무를 처리하기 위하여 다음 각 호와 같이 개인정보를 처리 위탁하고 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 9조
                    Text(
                      "제9조(개인정보의 보유 및 이용기간)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 이용자의 개인정보에 대해 개인정보의 수집·이용 목적 달성을 위한 기간 동안 개인정보를 보유 및 이용합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                        child: Text(
                          "전항에도 불구하고 회사는 내부 방침에 의해 서비스 부정이용기록은 부정 가입 및 이용 방지를 위하여 회원 탈퇴 시점으로부터 최대 1년간 보관합니다",
                          style: content,
                          softWrap: true, // 줄바꿈 허용
                          overflow: TextOverflow.visible,
                        ),
                      )
                    ]),
                    const SizedBox(height: 16),
                    //제 10조
                    Text(
                      "제10조(법령에 따른 개인정보의 보유 및 이용기간)",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "회사는 관계법령에 따라 다음과 같이 개인정보를 보유 및 이용합니다.",
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "전자상거래 등에서의 소비자보호에 관한 법률에 따른 보유정보 및 보유기간",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "i. 계약 또는 청약철회 등에 관한 기록 : 5년",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "전자상거래 등에서의 소비자보호에 관한 법률에 따른 보유정보 및 보유기간",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "ii. 대금결제 및 재화 등의 공급에 관한 기록 : 5년",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "iii. 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "iv. 표시•광고에 관한 기록 : 6개월",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ))
                              ]),
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "b. ",
                                  style: content,
                                ),
                                Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        "통신비밀보호법에 따른 보유정보 및 보유기간",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        "i. 계약 또는 청약철회 등에 관한 기록 : 5년",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                    ]))
                              ]),
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "c. ",
                                  style: content,
                                ),
                                Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        "통신비밀보호법에 따른 보유정보 및 보유기간",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        "i. 전자금융거래에 관한 기록 : 5년",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                    ]))
                              ]),
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "d. ",
                                  style: content,
                                ),
                                Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(
                                        "위치정보의 보호 및 이용 등에 관한 법률",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        "i. 개인위치정보에 관한 기록 : 6개월",
                                        style: content,
                                        softWrap: true, // 줄바꿈 허용
                                        overflow: TextOverflow.visible,
                                      ),
                                    ]))
                              ]),
                            ],
                          ))
                    ]),
                    const SizedBox(height: 16),
                    //제 11조
                    Text(
                      "제11조(개인정보의 파기원칙)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 원칙적으로 이용자의 개인정보 처리 목적의 달성, 보유·이용기간의 경과 등 개인정보가 필요하지 않을 경우에는 해당 정보를 지체 없이 파기합니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 12조
                    Text(
                      "제12조(개인정보파기절차)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자가 회원가입 등을 위해 입력한 정보는 개인정보 처리 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기 되어집니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 파기 사유가 발생한 개인정보를 개인정보보호 책임자의 승인절차를 거쳐 파기합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 13조
                    Text(
                      "제13조(개인정보파기방법)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제하며, 종이로 출력된 개인정보는 분쇄기로 분쇄하거나 소각 등을 통하여 파기합니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 14조
                    Text(
                      "제14조(광고성 정보의 전송 조치)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 이용자의 명시적인 사전동의를 받습니다. 다만, 다음 각호 어느 하나에 해당하는 경우에는 사전 동의를 받지 않습니다",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사가 재화 등의 거래관계를 통하여 수신자로부터 직접 연락처를 수집한 경우, 거래가 종료된 날로부터 6개월 이내에 회사가 처리하고 수신자와 거래한 것과 동종의 재화 등에 대한 영리목적의 광고성 정보를 전송하려는 경우",
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
                            "「방문판매 등에 관한 법률」에 따른 전화권유판매자가 육성으로 수신자에게 개인정보의 수집출처를 고지하고 전화권유를 하는 경우",
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
                            "회사는 전항에도 불구하고 수신자가 수신거부의사를 표시하거나 사전 동의를 철회한 경우에는 영리목적의 광고성 정보를 전송하지 않으며 수신거부 및 수신동의 철회에 대한 처리 결과를 알립니다.",
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
                            "회사는 오후 9시부터 그다음 날 오전 8시까지의 시간에 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우에는 제1항에도 불구하고 그 수신자로부터 별도의 사전 동의를 받습니다.",
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
                            "회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 다음의 사항 등을 광고성 정보에 구체적으로 밝힙니다.",
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
                            "회사명 및 연락처",
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
                            "수신 거부 또는 수신 동의의 철회 의사표시에 관한 사항의 표시",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "9. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 전자적 전송매체를 이용하여 영리목적의 광고성 정보를 전송하는 경우 다음 각 호의 어느 하나에 해당하는 조치를 하지 않습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "10. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "광고성 정보 수신자의 수신거부 또는 수신동의의 철회를 회피·방해하는 조치",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "11. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "숫자·부호 또는 문자를 조합하여 전화번호·전자우편주소 등 수신자의 연락처를 자동으로 만들어 내는 조치",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "12. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "영리목적의 광고성 정보를 전송할 목적으로 전화번호 또는 전자우편주소를 자동으로 등록하는 조치",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "13. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "광고성 정보 전송자의 신원이나 광고 전송 출처를 감추기 위한 각종 조치",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "14. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "영리목적의 광고성 정보를 전송할 목적으로 수신자를 기망하여 회신을 유도하는 각종 조치",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 15조
                    Text(
                      "제15조(개인정보 조회 및 수집동의 철회)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자 및 법정 대리인은 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 개인정보수집 동의 철회를 요청할 수 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자 및 법정 대리인은 자신의 가입정보 수집 등에 대한 동의를 철회하기 위해서는 개인정보보호책임자 또는 담당자에게 서면, 전화 또는 전자우편주소로 연락하시면 회사는 지체 없이 조치하겠습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 16조
                    Text(
                      "제16조(개인정보 정보변경 등)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자는 회사에게 전조의 방법을 통해 개인정보의 오류에 대한 정정을 요청할 수 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 전항의 경우에 개인정보의 정정을 완료하기 전까지 개인정보를 이용 또는 제공하지 않으며 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 17조
                    Text(
                      "제17조(이용자의 의무)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "이용자는 자신의 개인정보를 최신의 상태로 유지해야 하며, 이용자의 부정확한 정보 입력으로 발생하는 문제의 책임은 이용자 자신에게 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "타인의 개인정보를 도용한 회원가입의 경우 이용자 자격을 상실하거나 관련 개인정보보호 법령에 의해 처벌받을 수 있습니다.",
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
                            "이용자는 전자우편주소, 비밀번호 등에 대한 보안을 유지할 책임이 있으며 제3자에게 이를 양도하거나 대여할 수 없습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 18조
                    Text(
                      "제18조(회사의 개인정보 관리)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 이용자의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 유출, 변조, 훼손 등이 되지 아니하도록 안전성을 확보하기 위하여 필요한 기술적·관리적 보호대책을 강구하고 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 19조
                    Text(
                      "제19조(삭제된 정보의 처리)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 이용자 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 회사가 수집하는 '개인정보의 보유 및 이용기간'에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 20조
                    Text(
                      "제20조(비밀번호의 암호화)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "이용자의 비밀번호는 일방향 암호화하여 저장 및 관리되고 있으며, 개인정보의 확인, 변경은 비밀번호를 알고 있는 본인에 의해서만 가능합니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 21조
                    Text(
                      "제21조(해킹 등에 대비한 대책)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 해킹, 컴퓨터 바이러스 등 정보통신망 침입에 의해 이용자의 개인정보가 유출되거나 훼손되는 것을 막기 위해 최선을 다하고 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 최신 백신프로그램을 이용하여 이용자들의 개인정보나 자료가 유출 또는 손상되지 않도록 방지하고 있습니다.",
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
                            "회사는 만일의 사태에 대비하여 침입차단 시스템을 이용하여 보안에 최선을 다하고 있습니다.",
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
                            "회사는 민감한 개인정보(를 수집 및 보유하고 있는 경우)를 암호화 통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 22조
                    Text(
                      "제22조(개인정보 처리 최소화 및 교육)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 개인정보 관련 처리 담당자를 최소한으로 제한하며, 개인정보 처리자에 대한 교육 등 관리적 조치를 통해 법령 및 내부방침 등의 준수를 강조하고 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 23조
                    Text(
                      "제23조(개인정보 유출 등에 대한 조치)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 개인정보의 분실·도난·유출(이하 '유출 등'이라 한다) 사실을 안 때에는 지체 없이 다음 각 호의 모든 사항을 해당 이용자에게 알리고 방송통신위원회 또는 한국인터넷진흥원에 신고합니다.",
                      style: content,
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "유출 등이 된 개인정보 항목",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "유출 등이 발생한 시점",
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
                            "이용자가 취할 수 있는 조치",
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
                            "정보통신서비스 제공자 등의 대응 조치",
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
                            "이용자가 상담 등을 접수할 수 있는 부서 및 연락처",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 24조
                    Text(
                      "제24조(개인정보 유출 등에 대한 조치의 예외)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "회사는 전조에도 불구하고 이용자의 연락처를 알 수 없는 등 정당한 사유가 있는 경우에는 회사의 홈페이지에 30일 이상 게시하는 방법으로 전조의 통지를 갈음하는 조치를 취할 수 있습니다.",
                      style: content,
                    ),
                    const SizedBox(height: 16),
                    //제 25조
                    Text(
                      "제25조(국외 이전 개인정보의 보호)",
                      style: title,
                    ),
                    const SizedBox(height: 4),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "1. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 이용자의 개인정보에 관하여 개인정보보호법 등 관계 법규를 위반하는 사항을 내용으로 하는 국제계약을 체결하지 않습니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 이용자의 개인정보를 국외에 제공(조회되는 경우를 포함)ㆍ처리위탁ㆍ보관(이하 '이전'이라 함)하려면 이용자의 동의를 받습니다. 다만, 본조 제3항 각 호의 사항 모두를 개인정보보호법 등 관계 법규에 따라 공개하거나 전자우편 등 대통령령으로 정하는 방법에 따라 이용자에게 알린 경우에는 개인정보 처리위탁ㆍ보관에 따른 동의절차를 거치지 아니할 수 있습니다.",
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
                            "회사는 본조 제2항 본문에 따른 동의를 받으려면 미리 다음 각 호의 사항 모두를 이용자에게 고지합니다.",
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
                            "이전되는 개인정보 항목",
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
                            "개인정보가 이전되는 국가, 이전일시 및 이전방법",
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
                            "개인정보를 이전받는 자의 성명(법인인 경우 그 명칭 및 정보관리 책임자의 연락처를 말한다)",
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
                            "개인정보를 이전받는 자의 개인정보 이용목적 및 보유ㆍ이용 기간",
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
                            "회사는 본조 제2항 본문에 따른 동의를 받아 개인정보를 국외로 이전하는 경우 개인정보보호법 대통령령 등 관계법규에서 정하는 바에 따라 보호조치를 합니다.",
                            style: content,
                            softWrap: true, // 줄바꿈 허용
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                    const SizedBox(height: 16),
                    //제 26조
                    Text(
                      "제26조(권익침해에 대한 구제방법)",
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
                                "정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.",
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "개인정보분쟁조정위원회 : (국번없이) 1833-6972",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "(www.kopico.go.kr)",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ))
                              ]),
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "b. ",
                                  style: content,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "개인정보침해신고센터 : (국번없이) 118",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          "(privacy.kisa.or.kr)",
                                          style: content,
                                          softWrap: true, // 줄바꿈 허용
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    )),
                              ]),
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  "c. ",
                                  style: content,
                                ),
                                Expanded(
                                    child: Text(
                                      "대검찰청 : (국번없이) 1301 (www.spo.go.kr)",
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
                                      "경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)",
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
                        "2. ",
                        style: content,
                      ),
                      Expanded(
                          child: Text(
                            "회사는 정보주체의 개인정보자기결정권을 보장하고, 개인정보침해로 인한 상담 및 피해 구제를 위해 노력하고 있으며, 신고나 상담이 필요한 경우 제1항의 담당부서로 연락해주시기 바랍니다.",
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
                          child: Column(children: [
                            Text(
                              "개인정보 보호법 제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.",
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
                                  "중앙행정심판위원회 : (국번없이) 110 (www.simpan.go.kr)",
                                  style: content,
                                  softWrap: true, // 줄바꿈 허용
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ]),
                          ])),
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
                    const SizedBox(height: 100),
                  ],
                ))));
  }
}
