import 'package:flutter/material.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/screens/challenge/complete/widget/cerification_post_card.dart';
import 'package:frontend/screens/challenge/complete/widget/reward_card.dart';
import 'package:frontend/screens/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/screens/community/community_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:frontend/service/post_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/model/data/post/post.dart';
import 'package:frontend/model/data/sms/sms.dart';

class ChallengeCompleteScreen extends StatefulWidget {
  const ChallengeCompleteScreen({super.key, required this.challenge});

  final Challenge challenge;

  @override
  State<ChallengeCompleteScreen> createState() =>
      _ChallengeCompleteScreenState();
}

class _ChallengeCompleteScreenState extends State<ChallengeCompleteScreen> {
  final Sms _sms = Sms(
    receiverNumber: '010-3333-9999',
    userName: '신혜은',
    challengeName: '조깅 3KM 진행하고 상금받자',
    relationship: '친구',
    receiverName: '김추환',
    letter: '이거 실패하면 공차 사줄게~',
  );
  final logger = Logger();
  final userController = Get.find<UserController>();

  final bool _isSuccess = false;

  late Challenge _challenge;

  TextStyle titleStyle(double fontSize) => TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Pretender',
        fontSize: fontSize,
      );

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: PostService.fetchMyPosts(
            _challenge.id, userController.user.id), // 비동기 작업을 수행하는 함수
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('인증 결과를 불러오지 못했어요.'));
          } else {
            List<Post>? posts = snapshot.data;
            if (posts == null || posts.isEmpty) {
              return const Center(child: Text('인증 결과를 불러오지 못했어요.'));
            } else {
              return buildBody(posts);
            }
          }
        },
      ),
    );
  }

  Widget buildBody(List<Post> posts) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSuccess ? "챌린지를 성공했어요! 👍" : "챌린지를 실패했어요 😭",
              style: titleStyle(21.0),
            ),
            const SizedBox(height: 10),
            const Text(
              "당신의 갓생을 루틴업이 응원합니다!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretender',
                fontSize: 11,
                color: Palette.purPle200,
              ),
            ),
            const SizedBox(height: 25),
            challengeInform(),
            const SizedBox(height: 15),
            const Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
              thickness: 1.5,
              color: Palette.grey50,
            ),
            const SizedBox(height: 10),
            CertificationMethod(challenge: _challenge),
            const SizedBox(height: 10),
            GestureDetector(
              child: Text("인증 게시글 모음 > ", style: titleStyle(15.0)),
              onTap: () => Get.to(() => {
                    CommunityScreen(
                      challenge: _challenge,
                    )
                  }),
            ),
            const SizedBox(height: 10),
            certificationPostList(posts),
            const SizedBox(height: 15),
            const Divider(
              indent: 20,
              endIndent: 20,
              height: 10,
              thickness: 1.5,
              color: Palette.grey50,
            ),
            const SizedBox(height: 15),
            RewardCard(isSuccess: _isSuccess, sms: _sms),
          ],
        ),
      ),
    );
  }

  Widget challengeInform() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (_challenge.challengeImagePaths.isNotEmpty)
              SizedBox(
                width: 100,
                height: 75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _challenge.challengeImagePaths[0],
                    fit: BoxFit.cover,
                    // You can set other properties like width, height, etc. here
                  ),
                ),
              )
            else
              const Placeholder(
                // You can customize the placeholder widget as per your requirement
                fallbackHeight: 100, // Example height
                fallbackWidth: 100, // Example width
              ),
            const SizedBox(width: 20),
            Text(
              _challenge.challengeName,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: "Pretender",
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget certificationPostList(List<Post> posts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          Post post = posts[index];
          return PostItemCard(post: post);
        }),
      ),
    );
  }
}
