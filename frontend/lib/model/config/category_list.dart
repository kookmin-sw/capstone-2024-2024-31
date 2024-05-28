import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';

List<Map<String, dynamic>> categoryList = [
  {
    'category':  ChallengeCategory.eating,
    'icon': SvgPicture.asset(
      'assets/icons/category_icons/eating.svg',
    )
  },
  {
    'category':  ChallengeCategory.exercise,
    'icon': SvgPicture.asset('assets/icons/category_icons/exercise.svg')
  },
  {
    'category':  ChallengeCategory.hobby,
    'icon': SvgPicture.asset('assets/icons/category_icons/hobby.svg')
  },
  {
    'category':  ChallengeCategory.nature,
    'icon': SvgPicture.asset('assets/icons/category_icons/nature.svg')
  },
  {
    'category':  ChallengeCategory.study,
    'icon': SvgPicture.asset('assets/icons/category_icons/study.svg')
  }
];
