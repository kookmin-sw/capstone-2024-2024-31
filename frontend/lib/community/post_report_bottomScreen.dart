import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PostReportBottomSheet extends StatefulWidget {
  final int postId;
  final int userId;

  const PostReportBottomSheet(
      {super.key, required this.postId, required this.userId});

  @override
  State<PostReportBottomSheet> createState() => _PostReportBottomSheetState();
}

class _PostReportBottomSheetState extends State<PostReportBottomSheet> {
  TextStyle titleStyle = const TextStyle(
      fontFamily: 'Pretender', fontWeight: FontWeight.bold, fontSize: 15);
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Pretender',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Palette.grey500);
  List<String> reportTextList = <String>[
    '선택하기',
    '인증사진으로 적합하지 않음',
    '혐오 발언 또는 상징',
    '폭력 또는 위험한 단체',
    '거짓 정보',
    '스팸',
    '나체 이미지 또는 성적 행위',
    '기타',
  ];
  String dropdownValue = '선택하기';

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;

    return Container(
        constraints: BoxConstraints(maxHeight: heightSize * 0.5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("신고", style: titleStyle)),
            const Divider(thickness: 2, height: 20),
            const SizedBox(height: 10),
            Text("이 게시글을 신고하는 이유", style: textStyle),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              DropdownButton<String>(
                // isExpanded: true,
                value: dropdownValue,
                icon: const Icon(Icons.expand_more),
                elevation: 16,
                style: const TextStyle(
                  color: Palette.mainPurple,
                ),
                underline: Container(
                  height: 2,
                  color: Palette.purPle300,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: reportTextList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: value == dropdownValue
                            ? FontWeight.w600
                            : FontWeight.w300,
                        color: value == dropdownValue
                            ? Palette.purPle400
                            : Palette.grey300,
                      ),
                    ),
                  );
                }).toList(),
              )
            ]),
            const SizedBox(height: 10),
            if (dropdownValue != reportTextList[0])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Palette.grey500,
                      fontFamily: 'Pretender'),
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: '상세 사유를 입력 하세요',
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(),
                    counterStyle: TextStyle(
                        fontSize: 10, // 최대 길이 카운터의 글자 크기
                        color: Palette.grey200,
                        fontFamily: 'Pretender' // 최대 길이 카운터의 색상
                        ),
                  ),
                  onChanged: (value) {},
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                ),
              ),
            const SizedBox(height: 10),
            Center(
                child: ElevatedButton(
              onPressed: () {
                _closeModalAndNavigateBack(context);
              },
              child: Text(
                '신고하기',
                style: titleStyle,
              ),
            ))
          ],
        ));
  }

  void _closeModalAndNavigateBack(BuildContext context) {
    Fluttertoast.showToast(
      msg: "신고가 완료됐습니다.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 15.0,
    );
    Get.back(); // ReportReasonPage 닫기/ PostPage로 돌아가기
  }
}
