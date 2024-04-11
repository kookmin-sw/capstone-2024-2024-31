import 'package:flutter/material.dart';
import 'package:frontend/model/edit_package/pie_chart/pie_chart.dart';

class LegendOptions {
  final bool showLegends;
  final bool showLegendsInRow;
  final TextStyle legendTextStyle;
  final TextStyle legendValueTextStyle;
  final BoxShape legendShape;
  final LegendPosition legendPosition;
  final Map<String,String> legendLabels;

  const LegendOptions({
    this.showLegends = true,
    this.showLegendsInRow = false,
    this.legendTextStyle = defaultLegendStyle,
    this.legendValueTextStyle = defaultLegendStyle,
    this.legendShape = BoxShape.circle,
    this.legendPosition = LegendPosition.right,
    this.legendLabels = const {},
  });
}