import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/challenge/state/state_screen_widget.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../model/data/challenge/challenge.dart';
import '../../../model/data/challenge/challenge_status.dart';

class ChallengeStateScreen extends StatefulWidget {
  final bool isFromJoinScreen;
  final Challenge challenge;

  const ChallengeStateScreen(
      {super.key, required this.isFromJoinScreen, required this.challenge});

  @override
  State<ChallengeStateScreen> createState() => _ChallengeStateScreenState();
}

class _ChallengeStateScreenState extends State<ChallengeStateScreen> {
  final Logger logger = Logger();
  bool isLoading = true;
  late Challenge _challenge;
  late ChallengeStatus _challengeStatus;

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;
    ChallengeService.fetchChallengeStatus(_challenge.id).then((value) {
      setState(() {
        _challengeStatus = value;
      });
    }).whenComplete(() => isLoading = false);
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
    final int challengePeriod = _challenge.challengePeriod;
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
        bottomNavigationBar:
            ChallengeWidgets.buildBottomNavigationBar(_challenge),
      ),
    );
  }
}
