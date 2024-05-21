import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/challenge/state/state_screen_widget.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../model/controller/user_controller.dart';
import '../../../model/data/challenge/challenge.dart';
import '../../../model/data/challenge/challenge_status.dart';
import '../../../service/post_service.dart';

class ChallengeStateScreen extends StatefulWidget {
  final bool isFromJoinScreen;
  final int? challengeId;
  final ChallengeStatus? challengeStatus;
  bool? isPossibleCertification;
  Challenge? challenge;

  ChallengeStateScreen(
      {super.key,
      required this.isFromJoinScreen,
      this.challengeId,
      this.challengeStatus,
      this.isPossibleCertification,
      this.challenge});

  @override
  State<ChallengeStateScreen> createState() => _ChallengeStateScreenState();
}
class _ChallengeStateScreenState extends State<ChallengeStateScreen> {
  final Logger logger = Logger();
  bool isLoading = true;
  late Challenge _challenge;
  late int _challengeId;
  late ChallengeStatus _challengeStatus;
  final _userController = Get.find<UserController>();
  bool _isPossibleCertification = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _challengeId = widget.challengeId ?? widget.challenge!.id;

      if (widget.isPossibleCertification == null) {
        _isPossibleCertification = await PostService.checkPossibleCertification(
            _challengeId, _userController.user.id);
      } else {
        _isPossibleCertification = widget.isPossibleCertification!;
      }

      if (widget.challenge == null) {
        _challenge = await ChallengeService.fetchChallenge(_challengeId, null);
      } else {
        _challenge = widget.challenge!;
      }

      if (widget.challengeStatus == null) {
        _challengeStatus = await ChallengeService.fetchChallengeStatus(_challengeId);
      } else {
        _challengeStatus = widget.challengeStatus!;
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      logger.e('Initialization error: $error');
      setState(() {
        isLoading = false;
      });
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
      return buildChallengeStateScreen(context);
    }
  }

  Widget buildChallengeStateScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime startDate = DateTime.parse(_challenge.startDate);
    final int challengePeriod = _challenge.challengePeriod;
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    initializeDateFormatting('ko_KR', 'en_US');

    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: ChallengeStateScreenWidgets.buildAppBar(
            widget.isFromJoinScreen, _challenge),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ChallengeStateScreenWidgets.photoes(screenHeight, _challenge),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ChallengeStateScreenWidgets.informationChallenge(
                    startDate, endDate, _challenge, _challengeStatus),
              ),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeStateScreenWidgets.certificationState(
                  screenWidth, screenHeight, _challengeStatus),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              ChallengeStateScreenWidgets.entireCertificationStatus(
                  screenWidth, screenHeight, _challengeStatus),
            ],
          ),
        ),
        bottomNavigationBar:
            ChallengeStateScreenWidgets.buildBottomNavigationBar(
                _challenge, _isPossibleCertification),
      ),
    );
  }
}
