import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../services/helpers.dart';

List<Color> gradientColors = [
  Colors.blue,
  Colors.blue,
];

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
  );
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text('Jan', style: style);
      break;
    case 2:
      text = const Text('Feb', style: style);
      break;
    case 3:
      text = const Text('Mar', style: style);
      break;
    case 4:
      text = const Text('Apr', style: style);
      break;
    case 5:
      text = const Text('May', style: style);
      break;
    case 6:
      text = const Text('Jun', style: style);
      break;
    case 7:
      text = const Text('Jul', style: style);
      break;
    case 8:
      text = const Text('Aug', style: style);
      break;
    case 9:
      text = const Text('Sep', style: style);
      break;
    case 10:
      text = const Text('Oct', style: style);
      break;
    case 11:
      text = const Text('Nov', style: style);
      break;
    case 12:
      text = const Text('Dis', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget userGrowthYear({
  double janData = 0,
  double febData = 0,
  double marData = 0,
  double aprData = 0,
  double mayData = 0,
  double junData = 0,
  double julData = 0,
  double augData = 0,
  double sepData = 0,
  double octData = 0,
  double novData = 0,
  double disData = 0,
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
                  getTitlesWidget: bottomTitleWidgets,
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
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 0),
                  FlSpot(1, janData),
                  FlSpot(2, febData),
                  FlSpot(3, marData),
                  FlSpot(4, aprData),
                  FlSpot(5, mayData),
                  FlSpot(6, junData),
                  FlSpot(7, julData),
                  FlSpot(8, augData),
                  FlSpot(9, sepData),
                  FlSpot(10, octData),
                  FlSpot(11, novData),
                  FlSpot(12, disData),
                ],
                // isCurved: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: false,
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
