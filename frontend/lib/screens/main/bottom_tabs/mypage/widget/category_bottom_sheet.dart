import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/service/user_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/config/category_list.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({super.key});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final logger = Logger();
  final UserController userController = Get.find();

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
      padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
        const EdgeInsets.symmetric(horizontal: 10),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(80, 100)),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      backgroundColor:
          isSelected ? WidgetStateProperty.all<Color>(Palette.purPle400) : null,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedCategories = userController.user.categories.toList();
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
                await UserService.updateMyCategory(selectedCategories)
                    .then((value) {
                  _closeModalAndNavigateBack(context);
                }).catchError((err) {
                  logger.e("유저 관심 카테고리 업데이트 실패: $err");
                  Get.snackbar('유저 관심 카테고리 업데이트 실패', '다시 시도해주세요');
                }).whenComplete(() {
                  setState(() {
                    isLoading = false;
                  });
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
            selectedCategories.remove(category);
          } else {
            selectedCategories.add(category);
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
