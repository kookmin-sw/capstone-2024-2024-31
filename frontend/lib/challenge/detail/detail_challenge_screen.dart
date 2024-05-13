import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/challenge/detail/detail_imageDetail_screen.dart';
import 'package:frontend/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/env.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final int challengeId;

  const ChallengeDetailScreen({super.key, required this.challengeId});

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
      final response =
          await dio.get('${Env.serverUrl}/challenges/${widget.challengeId}');
      if (response.statusCode == 200) {
        logger.d('챌린지 디테일 조회 성공');
        logger.d(response.data);
        return Challenge.fromJson(response.data);
      }
    } catch (e) {
      logger.e(e);
    }

    return Future.error("챌린지 정보를 불러오는데 실패했습니다.");
  }

  @override
  void initState() {
    super.initState();
    _fetchChallenge()
        .then((value) => {
              setState(() {
                challenge = value;
                isLoading = false;
              })
            })
        .catchError((err) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Palette.grey300,
              ),
              onPressed: () {
                Get.back();
              }),
          title: const Text("챌린지 자세히 보기",
              style: TextStyle(
                  color: Palette.grey300,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "Pretender")),
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
            : buildChallengeDetailBody(context, challenge!),
        bottomNavigationBar: isLoading
            ? const SizedBox()
            : buildChallengeDetailBottomNavigationBar(context, challenge!));
  }

  Widget buildChallengeDetailBody(BuildContext context, Challenge challenge) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          PhotoesWidget(
            screenHeight: screenSize.height,
            imageUrl: challenge.challengeImageUrls[0],
          ),
          // screenHeight를 전달합니다.
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InformationWidget(challenge: challenge)),
          SvgPicture.asset(
            'assets/svgs/divider.svg',
            fit: BoxFit.contain,
          ),
          challengeExplanation(challenge),
          imageGridView(screenSize, challenge),
          SvgPicture.asset(
            'assets/svgs/divider.svg',
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text("인증 방식",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CertificationMethod(challenge: challenge)),
          certificationExplainPicture(screenSize, challenge)
        ],
      ),
    );
  }

  Widget buildChallengeDetailBottomNavigationBar(
      BuildContext context, Challenge challenge) {
    return Stack(children: <Widget>[
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          height: 80,
          color: Colors.transparent,
          width: double.infinity,
          child: CustomButton(
            onPressed: () => {},
            text: "참가하기",
          )),
      Positioned(
          top: 5,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Palette.purPle700,
              // 배경색 설정
              borderRadius: BorderRadius.circular(4),
              // 테두리를 둥글게 설정
            ),
            child: Text(
              " ${challenge.certificationFrequency} | ${challenge.challengePeriod}주 ",
              style: const TextStyle(
                  fontSize: 11,
                  fontFamily: "Pretendard",
                  color: Palette.white,
                  fontWeight: FontWeight.normal),
            ),
          ))
    ]);
  }

  Widget imageGridView(Size screenSize, Challenge challenge) {
    final imagePaths = challenge.challengeImageUrls;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: screenSize.height * 0.15 * 3.3,
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          physics: const NeverScrollableScrollPhysics(),
          // 스크롤 불가능하게 설정
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
                  height: screenSize.height * 0.15,
                  // 이미지 높이 고정
                  width: screenSize.width * 0.4,
                  // 이미지 너비 고정                  imagePaths[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ));
  }

  Widget challengeExplanation(Challenge challenge) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
            challenge.challengeExplanation,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(challenge.certificationExplanation,
                style: const TextStyle(
                    fontSize: 10,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500))),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImageContainer(
                path: challenge.successfulVerificationImageUrl,
                color: Palette.green,
                isSuccess: true,
                screenSize: screenSize),
            const SizedBox(width: 10),
            BuildImageContainer(
                path: challenge.failedVerificationImageUrl,
                color: Palette.red,
                isSuccess: false,
                screenSize: screenSize),
          ],
        ),
      ],
    );
  }
}
