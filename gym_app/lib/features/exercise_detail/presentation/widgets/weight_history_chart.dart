import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/app/theme/app_colors.dart';

class WeightHistoryChart extends StatelessWidget {
  const WeightHistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = [
      const FlSpot(0, 35),
      const FlSpot(1, 37.5),
      const FlSpot(2, 37.5),
      const FlSpot(3, 40),
      const FlSpot(4, 42.5),
      const FlSpot(5, 45),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weight history',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final labels = ['D1', 'D2', 'D3', 'D4', 'D5', 'D6'];
                        final int index = value.toInt();

                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        return Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    color: AppColors.accent,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withValues(alpha: 0.10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
