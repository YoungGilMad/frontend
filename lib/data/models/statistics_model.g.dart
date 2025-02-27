// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsSummary _$StatisticsSummaryFromJson(Map<String, dynamic> json) =>
    StatisticsSummary(
      totalQuests: (json['totalQuests'] as num).toInt(),
      completedQuests: (json['completedQuests'] as num).toInt(),
      totalXp: (json['totalXp'] as num).toInt(),
      avgDailyActivity: (json['avgDailyActivity'] as num).toDouble(),
      streakDays: (json['streakDays'] as num).toInt(),
      monthlyGoalPercentage: (json['monthlyGoalPercentage'] as num).toInt(),
      levelProgressPercentage: (json['levelProgressPercentage'] as num).toInt(),
    );

Map<String, dynamic> _$StatisticsSummaryToJson(StatisticsSummary instance) =>
    <String, dynamic>{
      'totalQuests': instance.totalQuests,
      'completedQuests': instance.completedQuests,
      'totalXp': instance.totalXp,
      'avgDailyActivity': instance.avgDailyActivity,
      'streakDays': instance.streakDays,
      'monthlyGoalPercentage': instance.monthlyGoalPercentage,
      'levelProgressPercentage': instance.levelProgressPercentage,
    };

CalendarItem _$CalendarItemFromJson(Map<String, dynamic> json) => CalendarItem(
      date: json['date'] as String,
      activityLevel: (json['activityLevel'] as num).toInt(),
      completedQuestIds: (json['completedQuestIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CalendarItemToJson(CalendarItem instance) =>
    <String, dynamic>{
      'date': instance.date,
      'activityLevel': instance.activityLevel,
      'completedQuestIds': instance.completedQuestIds,
    };

TagStatistic _$TagStatisticFromJson(Map<String, dynamic> json) => TagStatistic(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toInt(),
    );

Map<String, dynamic> _$TagStatisticToJson(TagStatistic instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
      'percentage': instance.percentage,
    };

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
      date: json['date'] as String,
      completedQuests: (json['completedQuests'] as num).toInt(),
      earnedXp: (json['earnedXp'] as num).toInt(),
      goalAchievement: (json['goalAchievement'] as num).toInt(),
    );

Map<String, dynamic> _$ActivityDataToJson(ActivityData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'completedQuests': instance.completedQuests,
      'earnedXp': instance.earnedXp,
      'goalAchievement': instance.goalAchievement,
    };

StatisticsModel _$StatisticsModelFromJson(Map<String, dynamic> json) =>
    StatisticsModel(
      summary:
          StatisticsSummary.fromJson(json['summary'] as Map<String, dynamic>),
      calendar: (json['calendar'] as List<dynamic>)
          .map((e) => CalendarItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => TagStatistic.fromJson(e as Map<String, dynamic>))
          .toList(),
      weekly: (json['weekly'] as List<dynamic>)
          .map((e) => ActivityData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatisticsModelToJson(StatisticsModel instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'calendar': instance.calendar,
      'tags': instance.tags,
      'weekly': instance.weekly,
    };
