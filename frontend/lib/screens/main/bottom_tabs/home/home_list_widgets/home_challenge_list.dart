import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/screens/challenge/search/challenge_search_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_list_widgets/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChallengeItemList extends StatefulWidget {
  const ChallengeItemList({super.key});

  @override
  State<ChallengeItemList> createState() => _ChallengeItemListState();
}

class _ChallengeItemListState extends State<ChallengeItemList> {
  final logger = Logger();

  void sortCombinedDataByStartDate(List<dynamic> data) {
    data.sort((a, b) {
      // 'startDate' 문자열을 DateTime 객체로 변환하여 비교
      DateTime startDateA = DateTime.parse(a['startDate']);
      DateTime startDateB = DateTime.parse(b['startDate']);

      // 최신순으로 정렬하기 위해 startDateB와 startDateA를 비교
      return startDateB.compareTo(startDateA);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ChallengeSearchScreen());
            },
            child: const Text(
              "챌린지 모아보기 >",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Palette.grey500,
                fontFamily: 'Pretendard',
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 13),
          FutureBuilder<List<ChallengeSimple>>(
            future: ChallengeService.fetchChallengeSimples(0, 6,
                ChallengeFilter(name: "", category: null, isPrivate: null)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? SizedBox(
                        height: screenSize.height * 0.3,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children:
                              List.generate(snapshot.data!.length, (index) {
                            return ChallengeItemCard(
                                challengeSimple: snapshot.data![index]);
                          }),
                        ),
                      )
                    : SvgPicture.asset(
                        "assets/svgs/no_challenge_box.svg"); // "snapshot.data 가 [] 일 경우 진행중인 챌린지 없음 안내
              } else {
                return Container();
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
