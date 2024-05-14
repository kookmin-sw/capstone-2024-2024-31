import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/search/challenge_search_screen.dart';
import 'package:frontend/env.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeItemList extends StatefulWidget {
  const ChallengeItemList({super.key});

  @override
  State<ChallengeItemList> createState() => _ChallengeItemListState();
}

class _ChallengeItemListState extends State<ChallengeItemList> {
  final logger = Logger();

  Future<List<ChallengeSimple>> getChallengeList() async {
    Dio dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final responseIsprivateFalse = await dio.get('${Env.serverUrl}/challenges/list',
          data: ChallengeFilter(isPrivate: false).toJson(),
          queryParameters: {
            'size': 2,
          });
      final responseIsprivateTrue = await dio.get('${Env.serverUrl}/challenges/list',
          data: ChallengeFilter(isPrivate: true).toJson(),
          queryParameters: {
            'size': 2,
          });

      if ((responseIsprivateFalse.statusCode == 200) &&(responseIsprivateTrue.statusCode == 200)) {
        final List<dynamic> combinedData = [...responseIsprivateFalse.data as List, ...responseIsprivateTrue.data as List];
        logger.d(combinedData);

        return combinedData.map((c) => ChallengeSimple.fromJson(c)).toList();
      }
      throw Exception("Failed to load challenges");
    } catch (e) {
      logger.e(e.toString());
      throw Exception("챌린지 목록을 불러오는데 실패했습니다.");
    }
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
                        fontSize: 15),
                  )),
              const SizedBox(height: 13),
              FutureBuilder<List<ChallengeSimple>>(
                future: getChallengeList(),
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
                              children:
                                  List.generate(snapshot.data!.length, (index) {
                                return ChallengeItemCard(
                                    data: snapshot.data![index]);
                              }),
                            ))
                        : SvgPicture.asset("assets/svgs/no_challenge_box.svg"); //"snapshot.data 가 [] 일 경우 진행중인 챌린지 없음 안내
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 10),
            ]));
  }
}
