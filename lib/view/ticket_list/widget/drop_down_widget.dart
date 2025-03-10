import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';

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
      width: 131,
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
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 131, maxWidth: 131),
        //팝업 가로 길이 고정
        offset: const Offset(13, 25),
        // 팝업 위치 조정
        elevation: 0,
        // 그림자 제거
        itemBuilder: (BuildContext context) {
          return widget.options.map((String option) {
            return PopupMenuItem<String>(
              value: option,
              padding: EdgeInsets.zero,
              height: 33,
              child: Container(
                height: 33,
                width: 131,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Text(option, style: c4_12Reg(f_70)),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(selectedOption, style: c3_12Med(f_70)),
            SvgPicture.asset('images/ticket/arrow-down.svg', height: 12, width: 12),
          ],
        ),
      ),
    );
  }
}
