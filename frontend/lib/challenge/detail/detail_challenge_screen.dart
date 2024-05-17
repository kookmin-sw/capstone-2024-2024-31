import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/detail/detail_image_detail_screen.dart';
import 'package:frontend/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/challenge/join/join_challenge_screen.dart';
import 'package:frontend/env.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final int challengeId;
  final bool isFromMainScreen;
  final bool isFromMypage;

  const ChallengeDetailScreen({
    super.key,
    required this.challengeId,
    this.isFromMainScreen = false,
    this.isFromMypage = false,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  final logger = Logger();
  Challenge? challenge;
  bool isLoading = true;

  Future<Challenge> _fetchChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      logger.d(widget.challengeId);
      final response = await dio.get(
          '${Env.serverUrl}/challenges/${widget.challengeId}',
      );
      if (response.statusCode == 200) {
        logger.d('챌린지 디테일 조회 성공');
        logger.d(response.data);
        final challenge = Challenge.fromJson(response.data);

        // Print each field to check for null values
        logger.d('Challenge Name: ${challenge.challengeName}');
        logger.d('Challenge Explanation: ${challenge.challengeExplanation}');
        logger.d('Challenge Image Paths: ${challenge.challengeImagePaths}');
        logger.d(
            'Successful Verification Image: ${challenge.successfulVerificationImage}');
        logger.d(
            'Failed Verification Image: ${challenge.failedVerificationImage}');
        // Add more fields as necessary

        return challenge;
      } else {
        return Future.error(
            "서버 응답 상태 코드: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      logger.e(e);
      return Future.error("챌린지 정보를 불러오는데 실패했습니다.");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChallenge().then((value) {
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
      bottomNavigationBar: widget.isFromMypage || !widget.isFromMainScreen
          ? null
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildChallengeDetailBottomNavigationBar(context, challenge ?? Challenge.getDummyData()),
    );
  }

  Widget buildChallengeDetailBody(BuildContext context, Challenge challenge) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          PhotoesWidget(
            screenHeight: screenSize.height,
            imageUrl: challenge.challengeImagePaths?.isNotEmpty ?? false
                ? challenge.challengeImagePaths![0]
                : '',
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InformationWidget(challenge: challenge)),
          divider(),
          challengeExplanation(challenge),
          imageGridView(screenSize, challenge),
          divider(),
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
          child: CustomButton(
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

  Widget divider() {
    return SvgPicture.asset(
      'assets/svgs/divider.svg',
      fit: BoxFit.contain,
    );
  }
}
