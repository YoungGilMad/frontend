import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/app_bar_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '통계',
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '요약'),
            Tab(text: '캘린더'),
            Tab(text: '태그'),
            Tab(text: '주간'),
          ],
          isScrollable: false,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildCalendarTab(),
          _buildTagsTab(),
          _buildWeeklyTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            title: '총 활동 통계',
            child: Column(
              children: [
                _buildStatItem('총 완료 퀘스트', '324개'),
                _buildStatItem('획득한 경험치', '12,450 XP'),
                _buildStatItem('현재 레벨', 'Lv. 25'),
                _buildStatItem('평균 일일 활동', '4.2시간'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: '성과 달성',
            child: Column(
              children: [
                _buildAchievementItem(
                  '연속 달성',
                  '7일',
                  Icons.local_fire_department,
                  Colors.orange,
                  0.7,
                ),
                _buildAchievementItem(
                  '월간 목표',
                  '85%',
                  Icons.star,
                  Colors.amber,
                  0.85,
                ),
                _buildAchievementItem(
                  '레벨업 진행',
                  '60%',
                  Icons.trending_up,
                  Colors.green,
                  0.6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 31, // Example for a month
      itemBuilder: (context, index) {
        final activityLevel = index % 4; // Mock activity levels (0-3)
        return _buildCalendarDay(index + 1, activityLevel);
      },
    );
  }

  Widget _buildTagsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                sections: _getMockPieData(),
                centerSpaceRadius: 40,
                sectionsSpace: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildTagItem(
                  '태그 ${index + 1}',
                  '${(index + 1) * 15}회',
                  _getMockPieData()[index].color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                barGroups: _getMockBarData(),
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildWeeklySummaryCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String label,
    String value,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(int day, int activityLevel) {
    final colors = [
      Colors.grey[200],
      Colors.green[200],
      Colors.green[400],
      Colors.green[700],
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[activityLevel],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: activityLevel == 0 ? Colors.grey[600] : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTagItem(String tag, String count, Color color) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(tag),
      trailing: Text(
        count,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주간 활동 요약',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildWeeklySummaryItem(
              '완료한 퀘스트',
              '23개',
              Icons.check_circle_outline,
              Colors.green,
            ),
            _buildWeeklySummaryItem(
              '획득한 경험치',
              '2,450 XP',
              Icons.star_outline,
              Colors.amber,
            ),
            _buildWeeklySummaryItem(
              '달성한 목표',
              '5/7',
              Icons.flag_outlined,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getMockPieData() {
    return [
      PieChartSectionData(
        value: 30,
        color: Colors.blue,
        title: '30%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 25,
        color: Colors.green,
        title: '25%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 20,
        color: Colors.orange,
        title: '20%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 15,
        color: Colors.purple,
        title: '15%',
        radius: 50,
      ),
      PieChartSectionData(
        value: 10,
        color: Colors.red,
        title: '10%',
        radius: 50,
      ),
    ];
  }

  List<BarChartGroupData> _getMockBarData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 10.0,
            color: Theme.of(context).colorScheme.primary,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}