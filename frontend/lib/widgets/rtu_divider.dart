import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RtuDivider extends StatelessWidget {
  const RtuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SvgPicture.asset(
          'assets/svgs/divider.svg',
          fit: BoxFit.contain,
        ));
  }
}
