import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';

class DropDownWidget extends StatefulWidget {
  final String selectedOption;
  final Function(String) updateItemList;
  final List<String> options;

  const DropDownWidget({
    super.key,
    required this.selectedOption,
    required this.updateItemList,
    required this.options,
  });

  @override
  State<StatefulWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late String selectedOption;
  Color backgroundColor = Colors.white;
  Color strokeColor = f_15;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: ShapeDecoration(
        color: backgroundColor, // 배경색 변경
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: strokeColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String newValue) {
          setState(() {
            FocusManager.instance.primaryFocus?.unfocus();
            selectedOption = newValue;
            widget.updateItemList(newValue); // 리스트 업데이트
            backgroundColor = Colors.white;
            strokeColor = f_15;
          });
        },
        onCanceled: () {
          setState(() {
            FocusManager.instance.primaryFocus?.unfocus();
            backgroundColor = Colors.white;
            strokeColor = f_15;
          });
        },
        onOpened: () {
          setState(() {
            backgroundColor = pn_10;
            strokeColor = pn_50;
          });
        },
        padding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(
          minWidth: 150,
          maxWidth: 150,
        ),
        //팝업 가로 길이 고정
        offset: const Offset(13, 25),
        // 팝업 위치 조정
        elevation: 0,
        // 그림자 제거
        itemBuilder: (BuildContext context) {
          return widget.options.map((String option) {
            return PopupMenuItem<String>(
              value: option,
              padding: const EdgeInsets.only(left: 12),
              child: Container(
                height: 38,
                alignment: Alignment.centerLeft,
                child: Text(
                  option,
                  style: const TextStyle(
                    color: f_70,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.42,
                  ),
                ),
              ),
            );
          }).toList();
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: pn_50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedOption,
              style: const TextStyle(
                color: f_70,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.42,
              ),
            ),
            SvgPicture.asset('images/opening_notice/arrow-down.svg', height: 16, width: 16),
          ],
        ),
      ),
    );
  }
}
