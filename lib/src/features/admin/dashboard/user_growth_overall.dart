import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../services/helpers.dart';

List<Color> gradientColors = [
  Colors.deepOrange,
  Colors.deepOrange,
];

Widget userGrowthOverall({
  List<FlSpot>? spots,
}) =>
    AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 10,
          right: 20,
        ),
        child: LineChart(
          LineChartData(
            clipData: FlClipData.all(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: CustomColor.primary,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: CustomColor.primary,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.round().toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d)),
            ),
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
