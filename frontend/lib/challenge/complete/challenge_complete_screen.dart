import 'package:flutter/material.dart';
import 'package:frontend/challenge/complete/widget/cerification_post_card.dart';
import 'package:frontend/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:frontend/model/data/post.dart';
import 'package:get/get.dart';
import 'dart:io';

class ChallengeCompleteScreen extends StatelessWidget {
  final Map<String, dynamic> postData;
  final List<dynamic> postDataList;

  ChallengeCompleteScreen({super.key, required this.challenge})
      : postData = {
          "id": 0,
          "title": "오늘도 챌린지 완료~!",
          "content": "This is an example article content.",
          "author": {
            "id": 123,
            "email": "author@example.com",
            "avatar": "avatar.jpg",
            "name": "챌린지왕",
            "point": 100
          },
          "image": "article_image.jpg",
          "createdDate": "2024-05-09T06:52:01.240Z",
          "comments": [
            {"id": 1, "author": "Alice", "content": "Great article!"},
            {"id": 2, "author": "Bob", "content": "Nice work!"}
          ]
        },
        postDataList = [] {
    // Initialize postDataList with postData
    for (int i = 0; i < 10; i++) {
      postDataList.add(postData);
    }
  }

  final Challenge challenge;

  TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'Pretender',
    fontSize: 15,
  );
  bool isSuccess = false;
  bool isEnded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close)),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isSuccess ? "챌린지를 성공했어요! 👍" : "챌린지를 실패했어요 😭",
                  style: titleStyle),
              const SizedBox(height: 10),
              const Text(
                "당신의 갓생을 루틴업이 응원합니다!",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretender',
                    fontSize: 11,
                    color: Palette.purPle200),
              ),
              const SizedBox(height: 25),
              challengeInform()
            ],
          ),
        )));
  }

  Widget challengeInform() {
    print(challenge.challengeImage1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (challenge.challengeImage1 != null)
              SizedBox(
                  width: 90,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: FileImage(challenge.challengeImage1!),
                      fit: BoxFit.cover,
                      // You can set other properties like width, height, etc. here
                    ),
                  ))
            else
              const Placeholder(
                // You can customize the placeholder widget as per your requirement
                fallbackHeight: 100, // Example height
                fallbackWidth: 100, // Example width
              ),
            Text(
              challenge.challengeName,
              style: const TextStyle(
                  fontSize: 11,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(height: 15),
        const Divider(
            indent: 20,
            endIndent: 20,
            height: 10,
            thickness: 1.5,
            color: Palette.grey50),
        const SizedBox(height: 10),
        CertificationMethod(challenge: challenge),
        const SizedBox(height: 10),
        Text("인증 게시글 모음 > ", style: titleStyle),
        const SizedBox(height: 10),
        certificationPostList()
      ],
    );
  }

  Widget certificationPostList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(10, (index) {
        Article article = Article.fromJson(postDataList[index]);
        return PostItemCard(article: article);
      })),
    );
  }

  Widget Result() {
    return Container();
  }
}
