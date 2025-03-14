import 'package:json_annotation/json_annotation.dart';

part 'statistics_model.g.dart';

/// 사용자의 통계 요약 정보를 담는 모델
@JsonSerializable()
class StatisticsSummary {
  final int totalQuests;
  final int completedQuests;
  final int totalXp;
  final double avgDailyActivity;
  final int streakDays;
  final int monthlyGoalPercentage;
  final int levelProgressPercentage;

  const StatisticsSummary({
    required this.totalQuests,
    required this.completedQuests,
    required this.totalXp,
    required this.avgDailyActivity,
    required this.streakDays,
    required this.monthlyGoalPercentage,
    required this.levelProgressPercentage,
  });

  factory StatisticsSummary.fromJson(Map<String, dynamic> json) =>
      _$StatisticsSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsSummaryToJson(this);
}

/// 캘린더 데이터 항목을 담는 모델
@JsonSerializable()
class CalendarItem {
  final String date;
  final int activityLevel;
  final List<String> completedQuestIds;

  const CalendarItem({
    required this.date,
    required this.activityLevel,
    required this.completedQuestIds,
  });

  factory CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarItemToJson(this);
}

/// 태그 통계를 담는 모델
@JsonSerializable()
class TagStatistic {
  final String name;
  final int count;
  final int percentage;

  const TagStatistic({
    required this.name,
    required this.count,
    required this.percentage,
  });

  factory TagStatistic.fromJson(Map<String, dynamic> json) =>
      _$TagStatisticFromJson(json);

  Map<String, dynamic> toJson() => _$TagStatisticToJson(this);
}

/// 일간/주간/월간 활동 데이터를 담는 모델
@JsonSerializable()
class ActivityData {
  final String date;
  final int completedQuests;
  final int earnedXp;
  final int goalAchievement;

  const ActivityData({
    required this.date,
    required this.completedQuests,
    required this.earnedXp,
    required this.goalAchievement,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) =>
      _$ActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDataToJson(this);
}

/// 전체 통계 데이터를 담는 모델
@JsonSerializable()
class StatisticsModel {
  final StatisticsSummary summary;
  final List<CalendarItem> calendar;
  final List<TagStatistic> tags;
  final List<ActivityData> weekly;

  const StatisticsModel({
    required this.summary,
    required this.calendar,
    required this.tags,
    required this.weekly,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsModelToJson(this);
}