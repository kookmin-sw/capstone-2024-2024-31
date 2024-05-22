import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/main/bottom_tabs/myRoutineUp/widget/my_routine_up_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';

class ChallengeWidget extends StatefulWidget {
  final bool isIng;
  final bool isStarted;
  final List<ChallengeSimple> challenges;

  const ChallengeWidget(
      {super.key,
      required this.isIng,
      required this.isStarted,
      required this.challenges});

  @override
  State<ChallengeWidget> createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  late List<ChallengeSimple> challenges;
  late String status;
  int viewChallengeLength = 3;
  int additionalChallengesToShow = 3;

  @override
  void initState() {
    super.initState();
    challenges = widget.challenges;
    viewChallengeLength = challenges.length < 3 ? challenges.length : 3;
    if (widget.isStarted) {
      status = widget.isIng ? "진행중" : "완료";
    } else {
      status = "진행 전";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$status ${challenges.length}",
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            color: Palette.grey500,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: challenges.isEmpty
              ? Container(
                  // If there are no challenges to display, show a placeholder.
                  child: widget.isStarted
                      ? widget.isIng
                          ? SvgPicture.asset(
                              "assets/svgs/no_challenge_state_card.svg")
                          : SvgPicture.asset(
                              "assets/svgs/no_complete_challenge_card.svg",
                            )
                      : SvgPicture.asset(
                          "assets/svgs/no_plan_challenge_card.svg"))
              : ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    viewChallengeLength,
                    (index) {
                      return MyRoutineUpCard(
                        isIng: widget.isIng,
                        isStarted: widget.isStarted,
                        challengeSimple: challenges[index],
                      );
                    },
                  ),
                ),
        ),
        if (viewChallengeLength < challenges.length)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.transparent,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (viewChallengeLength + additionalChallengesToShow <=
                      challenges.length) {
                    viewChallengeLength += additionalChallengesToShow;
                  } else {
                    viewChallengeLength = challenges.length;
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/svgs/more_view_btn.svg',
              ),
            ),
          ),
      ],
    );
  }
}
