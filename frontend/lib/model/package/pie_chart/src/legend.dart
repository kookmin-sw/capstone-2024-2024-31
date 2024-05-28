import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Legend extends StatelessWidget {
  const Legend({
    required this.title,
    required this.inform,
    required this.color,
    required this.style,
    required this.valueStyle,
    required this.legendShape,
    required this.index,
    super.key,
  });

  final String title;
  final double? inform;
  final Color color;
  final TextStyle style;
  final TextStyle valueStyle;
  final BoxShape legendShape;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 2.0),
                      height: 20.0,
                      width: 18.0,
                      decoration: BoxDecoration(
                        shape: legendShape,
                        color: color,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      title,
                      style: style,
                      softWrap: true,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    (index != 2)
                        ? SvgPicture.asset(
                            "assets/svgs/pie_chart_rectangle.svg")
                        : const SizedBox(width: 2, height: 44,),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
                Text(
                  '${inform?.toInt().toString() ?? '0'}명',
                  style: valueStyle,
                  softWrap: true,
                ),
                const SizedBox(
                  width: 8.0,
                ),
              ],
            )
          ],
        );
  }
}
