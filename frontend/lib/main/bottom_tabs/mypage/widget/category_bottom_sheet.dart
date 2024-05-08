import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/category_list.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({super.key});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late UserController userController;

  String selectedCategoryText = '';
  List<String> selectedCategories =
      []; // 이미 선택되어있는 카테고리 == userController.user.categories
  bool isSelected = false;

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

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
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
              children: List.generate(CategoryList.length - 2, (categoryIndex) {
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
                  List.generate(CategoryList.length ~/ 2, (categoryIndex) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: buildCategoryButton(categoryIndex + 3));
              }),
            ),
            const SizedBox(height: 15),
            Center(
                child: ElevatedButton(
              onPressed: () {
                _closeModalAndNavigateBack(context);
              },
              child: Text(
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
    return ElevatedButton(
      onPressed: () {
        setState(() {
          String categoryText = CategoryList[categoryIndex]['category'];
          if (selectedCategories.contains(categoryText)) {
            selectedCategories
                .remove(categoryText); // Deselect if already selected
          } else {
            selectedCategories.add(categoryText); // Select otherwise
          }
        });
      },
      style: getCategoryButtonStyle(
          selectedCategories.contains(CategoryList[categoryIndex]['category'])),
      child: Center(
        child: Column(
          children: [
            Container(
              child: CategoryList[categoryIndex]['icon'],
              width: 45,
              height: 45,
            ),
            const SizedBox(height: 10),
            Text(
              CategoryList[categoryIndex]['category'],
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: selectedCategories
                        .contains(CategoryList[categoryIndex]['category'])
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
