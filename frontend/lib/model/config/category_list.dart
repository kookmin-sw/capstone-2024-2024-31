import 'package:flutter_svg/flutter_svg.dart';

List<Map<String, dynamic>> CategoryList = [
  {
    'category': '식습관',
    'icon': SvgPicture.asset(
      'assets/icons/category_icons/eating.svg',
    )
  },
  {
    'category': '운동',
    'icon': SvgPicture.asset('assets/icons/category_icons/exercise.svg')
  },
  {
    'category': '취미',
    'icon': SvgPicture.asset('assets/icons/category_icons/hobby.svg')
  },
  {
    'category': '환경',
    'icon': SvgPicture.asset('assets/icons/category_icons/nature.svg')
  },
  {
    'category': '공부',
    'icon': SvgPicture.asset('assets/icons/category_icons/study.svg')
  }
];
