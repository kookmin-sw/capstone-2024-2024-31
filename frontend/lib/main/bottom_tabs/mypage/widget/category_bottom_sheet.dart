import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/config/category_list.dart';
import 'dart:convert';
import '../../../../env.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({super.key});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final logger = Logger();
  late UserController userController;
  bool isLoading = false;
  List<ChallengeCategory> selectedCategories = [];

  TextStyle titleStyle = const TextStyle(
      fontFamily: 'Pretender',
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Palette.purPle400);

  TextStyle textStyle = const TextStyle(
      fontFamily: 'Pretender',
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: Palette.grey500);

  ButtonStyle getCategoryButtonStyle(bool isSelected) {
    return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(horizontal: 10),
      ),
      minimumSize: MaterialStateProperty.all<Size>(const Size(80, 100)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      backgroundColor: isSelected
          ? MaterialStateProperty.all<Color>(Palette.purPle400)
          : null,
    );
  }

  Future<Object> _saveCategoriesToServer(List<ChallengeCategory> categories) async {
    // JSON 문자열 배열로 변환
    List<String> jsonCategories = categories.map((category) => category.name).toList();

    // 서버가 기대하는 형식으로 JSON 객체 생성
    Map<String, dynamic> requestPayload = {
      'categories': jsonCategories,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.Dio dioInstance = dio.Dio();

    // 서버에 저장하기 위해 HTTP 요청 보내기
    dioInstance.options.contentType = 'application/json';
    dioInstance.options.headers['Authorization'] =
    'Bearer ${prefs.getString('access_token')}';

    Logger logger = Logger();
    logger.d("Request payload: $requestPayload"); // 디버깅용 로그

    try {
      final response = await dioInstance.post(
        '${Env.serverUrl}/users/category',
        data: jsonEncode(requestPayload), // JSON 문자열을 전달
      );

      // 서버 응답이 JSON 객체라고 가정하고 파싱
      if (response.statusCode == 200) {
        final responseData = response.data is String ? jsonDecode(response.data) : response.data;
        logger.d("responseData : $responseData");


        // UserController 업데이트
        userController.updateCategories(categories);


        return responseData['id']; // 적절한 키로 값을 추출하여 반환
      } else {
        throw Exception('Failed to post categories');
      }
    } on dio.DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.d('Response status code: ${e.response?.statusCode}');
        logger.d('Response data: ${e.response?.data}');
        logger.d('Request options: ${e.response?.requestOptions}');
      } else {
        logger.e('Error sending request: ${e.requestOptions}');
      }
      return Future.error(e.toString());
    } catch (err) {
      return Future.error(err.toString());
    }


  }

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    selectedCategories = [];
  }

  @override
  Widget build(BuildContext context) {
    double heightSize = MediaQuery.of(context).size.height;

    return Container(
        constraints: BoxConstraints(maxHeight: heightSize * 0.6),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("관심있는 카테고리 설정하기", style: titleStyle)),
            const Divider(thickness: 2, height: 20),
            const SizedBox(height: 10),
            Text("관심 있는 카테고리를 모두 선택하세요!", style: textStyle),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(categoryList.length - 2, (categoryIndex) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: buildCategoryButton(categoryIndex));
              }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(categoryList.length ~/ 2, (categoryIndex) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: buildCategoryButton(categoryIndex + 3));
              }),
            ),
            const SizedBox(height: 15),
            Center(
                child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _saveCategoriesToServer(selectedCategories).then((value) {
                  isLoading = false;
                  _closeModalAndNavigateBack(context);
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      '저장하기',
                      style: titleStyle,
                    ),
            ))
          ],
        ));
  }

  void _closeModalAndNavigateBack(BuildContext context) {
    Fluttertoast.showToast(
      msg: "카테고리를 저장했습니다.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 15.0,
    );
    Get.back(); // ReportReasonPage 닫기/ PostPage로 돌아가기
  }

  Widget buildCategoryButton(int categoryIndex) {
    ChallengeCategory category = categoryList[categoryIndex]['category'];
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (selectedCategories.contains(category)) {
            selectedCategories.remove(category); // 이미 선택된 경우 제거
          } else {
            selectedCategories.add(category); // 선택되지 않은 경우 추가
          }
        });
      },
      style: getCategoryButtonStyle(selectedCategories.contains(category)),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              child: categoryList[categoryIndex]['icon'],
              width: 45,
              height: 45,
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: selectedCategories.contains(category)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
