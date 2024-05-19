import 'package:flutter/material.dart';
import 'package:frontend/challenge/detail/detail_image_detail_screen.dart';
import 'package:frontend/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/challenge/join/join_challenge_screen.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/model/service/challenge_service.dart';
import 'package:frontend/widgets/rtu_button.dart';
import 'package:frontend/widgets/rtu_divider.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/controller/user_controller.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final int challengeId;
  final bool isFromMainScreen;
  final bool isFromMypage;
  final bool isFromPrivateCodeDialog;
  final Map<String, dynamic>? challengeData;

  const ChallengeDetailScreen(
      {super.key,
      required this.challengeId,
      this.challengeData,
      this.isFromMainScreen = false,
      this.isFromMypage = false,
      this.isFromPrivateCodeDialog = false});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final logger = Logger();
  Challenge? challenge;
  bool isLoading = true;
  late UserController userController;
  late bool _isMyChallenge;

  void isMyChallenges() {
    userController = Get.find<UserController>();
    logger.d("controller.myChallenges : ${userController.myChallenges}");
    _isMyChallenge = userController.myChallenges
        .any((challenge) => challenge.id == widget.challengeId);
  }

  @override
  void initState() {
    super.initState();
    isMyChallenges(); //이미 챌린지 참여 중이면 참가하기 버튼 없애기

    if (widget.isFromPrivateCodeDialog) {
      logger.d("detail_screen 89번 라인 ) ${widget.isFromPrivateCodeDialog}");
      logger.d("detail_screen 89번 라인 ) ${widget.challengeData!}");

      challenge = Challenge.fromJson(widget.challengeData!);
      setState(() {
        isLoading = false;
      });
    }
    //공개 챌린지 첫 입장시,
    else {
      ChallengeService.fetchChallenge(widget.challengeId).then((value) {
        logger.d("detail_screen initState() : $value");

        setState(() {
          challenge = value;
          isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          "오류",
          err.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.isFromMainScreen || widget.isFromMypage
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Palette.grey300,
                ),
                onPressed: () {
                  Get.back();
                })
            : IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Palette.grey300,
                ),
                onPressed: () {
                  Get.offAll(() => MainScreen());
                }),
        title: const Text(
          "챌린지 자세히 보기",
          style: TextStyle(
            color: Palette.grey300,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Pretendard",
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.ios_share,
                color: Palette.grey300,
              )),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : challenge != null
              ? buildChallengeDetailBody(context, challenge!)
              : const Center(child: Text('챌린지 정보를 불러오지 못했습니다.')),
      bottomNavigationBar: _isMyChallenge
          ? null
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildChallengeDetailBottomNavigationBar(
                  context, challenge ?? Challenge.getDummyData()),
    );
  }

  Widget buildChallengeDetailBody(BuildContext context, Challenge challenge) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          PhotoesWidget(
            screenHeight: screenSize.height,
            imageUrl: challenge.challengeImagePaths.isNotEmpty ?? false
                ? challenge.challengeImagePaths[0]
                : '',
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InformationWidget(challenge: challenge)),
          const RtuDivider(),
          challengeExplanation(challenge),
          imageGridView(screenSize, challenge),
          const RtuDivider(),
          const SizedBox(height: 10),
          certificationExplainPicture(screenSize, challenge),
        ],
      ),
    );
  }

  Widget buildChallengeDetailBottomNavigationBar(
    BuildContext context,
    Challenge challenge,
  ) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          height: 80,
          color: Colors.transparent,
          width: double.infinity,
          child: RtuButton(
            onPressed: () {
              Get.to(() => JoinChallengeScreen(challenge: challenge));
            },
            text: "참가하기",
          ),
        ),
        Positioned(
          top: 5,
          left: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Palette.purPle700,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              " ${challenge.certificationFrequency} | ${challenge.challengePeriod ?? 0}주 ",
              style: const TextStyle(
                fontSize: 11,
                fontFamily: "Pretendard",
                color: Palette.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageGridView(Size screenSize, Challenge challenge) {
    final imagePaths = challenge.challengeImagePaths ?? [];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      height: screenSize.width * 0.5 * (imagePaths.length ~/ 1.5) + 10,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImageDetailPage(imagePath: imagePaths[index]),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget challengeExplanation(Challenge challenge) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("챌린지 소개",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Text(
            challenge.challengeExplanation ?? "",
            style: const TextStyle(
                fontSize: 10,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget certificationExplainPicture(Size screenSize, Challenge challenge) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("인증 방식",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              CertificationMethod(challenge: challenge),
              Text(
                challenge.certificationExplanation ?? "",
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImageContainer(
              path: challenge.successfulVerificationImage ?? "",
              color: Palette.green,
              isSuccess: true,
              screenSize: screenSize,
            ),
            const SizedBox(width: 10),
            BuildImageContainer(
              path: challenge.failedVerificationImage ?? "",
              color: Palette.red,
              isSuccess: false,
              screenSize: screenSize,
            ),
          ],
        ),
      ],
    );
  }
}
