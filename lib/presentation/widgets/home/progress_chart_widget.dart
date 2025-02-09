import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../screens/statistics/statistics_screen.dart';

enum ChartPeriod { weekly, monthly, yearly }

class ProgressChartWidget extends StatefulWidget {
  const ProgressChartWidget({super.key});

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> {
  ChartPeriod _selectedPeriod = ChartPeriod.weekly;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '활동 현황',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsScreen(),
                    ),
                  );
                },
                child: const Text('자세히 보기'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        _getTimeText(value.toInt()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getData(),
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 6,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Theme.of(context).colorScheme.surface,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.primary,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} XP',
                          TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPeriodButton(ChartPeriod.weekly, '1주'),
                    _buildPeriodButton(ChartPeriod.monthly, '1개월'),
                    _buildPeriodButton(ChartPeriod.yearly, '1년'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatsSummary(context),
        ],
      ),
    );
  }

  // 새로운 메서드 추가
  Widget _buildPeriodButton(ChartPeriod period, String label) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getTimeText(int value) {
    switch (_selectedPeriod) {
      case ChartPeriod.weekly:
        final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
        return value >= 0 && value < weekdays.length ? weekdays[value] : '';
      case ChartPeriod.monthly:
        return '${value + 1}주';
      case ChartPeriod.yearly:
        return '${value + 1}월';
    }
  }

  List<FlSpot> _getData() {
    switch (_selectedPeriod) {
      case ChartPeriod.weekly:
        return [
          const FlSpot(0, 150),
          const FlSpot(1, 240),
          const FlSpot(2, 180),
          const FlSpot(3, 320),
          const FlSpot(4, 250),
          const FlSpot(5, 400),
          const FlSpot(6, 280),
        ];
      case ChartPeriod.monthly:
        return [
          const FlSpot(0, 600),
          const FlSpot(1, 850),
          const FlSpot(2, 720),
          const FlSpot(3, 940),
        ];
      case ChartPeriod.yearly:
        return [
          const FlSpot(0, 2400),
          const FlSpot(1, 3100),
          const FlSpot(2, 2800),
          const FlSpot(3, 3600),
          const FlSpot(4, 3200),
          const FlSpot(5, 3800),
          const FlSpot(6, 3500),
          const FlSpot(7, 4100),
          const FlSpot(8, 3900),
          const FlSpot(9, 4300),
          const FlSpot(10, 4000),
          const FlSpot(11, 4500),
        ];
    }
  }

  Widget _buildStatsSummary(BuildContext context) {
    String period = switch (_selectedPeriod) {
      ChartPeriod.weekly => '이번 주',
      ChartPeriod.monthly => '이번 달',
      ChartPeriod.yearly => '올해',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          '총 퀘스트',
          '${_getQuestCount()}개',
          Icons.assignment_turned_in,
        ),
        _buildStatItem(
          context,
          '획득 경험치',
          '${_getXpCount()} XP',
          Icons.star,
        ),
        _buildStatItem(
          context,
          '성장률',
          _getGrowthRate(),
          Icons.trending_up,
        ),
      ],
    );
  }

  int _getQuestCount() {
    return switch (_selectedPeriod) {
      ChartPeriod.weekly => 32,
      ChartPeriod.monthly => 128,
      ChartPeriod.yearly => 1560,
    };
  }

  String _getXpCount() {
    return switch (_selectedPeriod) {
      ChartPeriod.weekly => '1,820',
      ChartPeriod.monthly => '7,280',
      ChartPeriod.yearly => '87,360',
    };
  }

  String _getGrowthRate() {
    return switch (_selectedPeriod) {
      ChartPeriod.weekly => '+24%',
      ChartPeriod.monthly => '+32%',
      ChartPeriod.yearly => '+156%',
    };
  }

  Widget _buildStatItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}