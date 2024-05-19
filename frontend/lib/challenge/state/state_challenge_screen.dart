import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/state/state_screen_widget.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../model/data/challenge/challenge.dart';
import '../../model/data/challenge/challenge_simple.dart';
import '../../model/data/challenge/challenge_status.dart';
import '../../model/data/challenge/ChallengeService.dart';

class ChallengeStateScreen extends StatefulWidget {
  final bool isFromJoinScreen;
  final Challenge? challenge;
  final ChallengeSimple? challengeSimple;

  const ChallengeStateScreen({
    super.key,
    required this.isFromJoinScreen,
    this.challenge,
    this.challengeSimple,
  });

  @override
  _ChallengeStateScreenState createState() => _ChallengeStateScreenState();
}

class _ChallengeStateScreenState extends State<ChallengeStateScreen> {
  final Logger logger = Logger();
  Challenge? thisChallenge;
  bool isLoading = true;
  late ChallengeStatus challengeStatus;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (await _fetchChallengeStatus() && await _fetchChallenge()) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _fetchChallenge() async {
    if (widget.challenge == null) {
      thisChallenge = await ChallengeService.fetchChallenge(
          widget.challengeSimple!.id, logger);
      return thisChallenge != null;
    } else {
      thisChallenge = widget.challenge!;
      return true;
    }
  }

  Future<bool> _fetchChallengeStatus() async {
    challengeStatus = (await ChallengeService.fetchChallengeStatus(
        widget.challengeSimple!.id, logger))!;
    return challengeStatus != null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (thisChallenge == null) {
      return const Scaffold(
        body: Center(
          child: Text('챌린지 데이터를 불러올 수 없습니다.'),
        ),
      );
    } else {
      return buildChallengeScreen(context, thisChallenge!);
    }
  }

  Widget buildChallengeScreen(BuildContext context, Challenge thisChallenge) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime startDate = thisChallenge.startDate;
    final int challengePeriod = thisChallenge.challengePeriod ?? 100;
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    initializeDateFormatting('ko_KR', 'en_US');

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ChallengeWidgets.buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ChallengeWidgets.photoes(screenHeight, thisChallenge),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ChallengeWidgets.informationChallenge(
                    startDate, endDate, thisChallenge, challengeStatus),
              ),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeWidgets.certificationState(
                  screenWidth, screenHeight,  challengeStatus),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeWidgets.entireCertificationStatus(
                  screenWidth, screenHeight, challengeStatus),
            ],
          ),
        ),
        bottomNavigationBar: ChallengeWidgets.buildBottomNavigationBar(),
      ),
    );
  }
}
