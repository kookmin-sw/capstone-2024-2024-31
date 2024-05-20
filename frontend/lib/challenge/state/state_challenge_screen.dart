import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/state/state_screen_widget.dart';
import 'package:frontend/model/service/challenge_service.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../model/data/challenge/challenge.dart';
import '../../model/data/challenge/challenge_status.dart';

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
  late Challenge _challenge;
  late ChallengeStatus _challengeStatus;

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
        _challenge = widget.challenge!;
      });
      return true;
    }

    Challenge? tmpChallenge =
        await ChallengeService.fetchChallenge(widget.challengeId);
    if (tmpChallenge != null) {
      setState(() {
        _challenge = tmpChallenge;
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _fetchChallengeStatus() async {
    ChallengeStatus? tmpChallengeStatus =
        await ChallengeService.fetchChallengeStatus(widget.challengeId);
    if (tmpChallengeStatus != null) {
      setState(() {
        _challengeStatus = tmpChallengeStatus;
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
      return buildChallengeScreen(context);
    }
  }

  Widget buildChallengeScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime startDate = DateTime.parse(_challenge.startDate);
    final int challengePeriod = _challenge.challengePeriod ?? 100;
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    initializeDateFormatting('ko_KR', 'en_US');

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ChallengeWidgets.buildAppBar(widget.isFromJoinScreen),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ChallengeWidgets.photoes(screenHeight, _challenge),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ChallengeWidgets.informationChallenge(
                    startDate, endDate, _challenge, _challengeStatus),
              ),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeWidgets.certificationState(
                  screenWidth, screenHeight, _challengeStatus),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeWidgets.entireCertificationStatus(
                  screenWidth, screenHeight, _challengeStatus),
            ],
          ),
        ),
        bottomNavigationBar: ChallengeWidgets.buildBottomNavigationBar(_challenge.id, _challenge.isGalleryPossible),
      ),
    );
  }
}
