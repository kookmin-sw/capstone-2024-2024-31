import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/mypage/widget/category_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> CategoryButtonPress(BuildContext context) async {
  double heightSize = MediaQuery.of(context).size.height;
  double widthSize = MediaQuery.of(context).size.width;

  await showMaterialModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: CategoryBottomSheet()));
    },
  );
}
