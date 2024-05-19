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
  final int challengeId;
  Challenge? challenge;

  ChallengeStateScreen(
      {super.key,
      required this.isFromJoinScreen,
      required this.challengeId,
      this.challenge});

  @override
  _ChallengeStateScreenState createState() => _ChallengeStateScreenState();
}

class _ChallengeStateScreenState extends State<ChallengeStateScreen> {
  final Logger logger = Logger();
  bool isLoading = true;
  late Challenge thisChallenge;
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
    if (widget.challenge != null) {
      setState(() {
        thisChallenge = widget.challenge!;
      });
      return true;
    }

    Challenge? tmpChallenge =
        await ChallengeService.fetchChallenge(widget.challengeId, logger);
    if (tmpChallenge != null) {
      setState(() {
        thisChallenge = tmpChallenge;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _fetchChallengeStatus() async {
    ChallengeStatus? tmpChallengeStatus =
        await ChallengeService.fetchChallengeStatus(widget.challengeId, logger);
    if (tmpChallengeStatus != null) {
      setState(() {
        challengeStatus = tmpChallengeStatus;
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return buildChallengeScreen(context, thisChallenge);
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
        appBar: ChallengeWidgets.buildAppBar(widget.isFromJoinScreen),
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
