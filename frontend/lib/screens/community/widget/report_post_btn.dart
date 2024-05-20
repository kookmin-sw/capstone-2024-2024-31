import 'package:flutter/material.dart';
import 'package:frontend/screens/community/post_report_bottomScreen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> repostPostButtonPress(
    BuildContext context, int postID, int userID) async {
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
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: PostReportBottomSheet(
                postId: postID,
                userId: userID,
              )));
    },
  );
}
