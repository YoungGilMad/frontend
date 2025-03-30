// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestItemModel _$QuestItemModelFromJson(Map<String, dynamic> json) =>
    QuestItemModel(
      id: QuestItemModel._fromDynamicToString(json['id']),
      title: json['title'] as String,
      description: json['description'] as String,
      tag: json['tag'] as String?,
      days: (json['days'] as num?)?.toInt(),
      progressTime: json['progress_time'] == null
          ? Duration.zero
          : QuestItemModel._durationFromSeconds(
              (json['progress_time'] as num).toInt()),
      completeTime:
          QuestItemModel._nullableDateTimeFromJson(json['complete_time']),
      isCompleted: json['finish'] as bool? ?? false,
      questType: json['quest_type'] as String,
      startTime: QuestItemModel._nullableDateTimeFromJson(json['start_time']),
      stopTime: QuestItemModel._nullableDateTimeFromJson(json['stop_time']),
      finishTime: QuestItemModel._nullableDateTimeFromJson(json['finish_time']),
      deadline: QuestItemModel._nullableDateTimeFromJson(json['deadline']),
    );

Map<String, dynamic> _$QuestItemModelToJson(QuestItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'tag': instance.tag,
      'days': instance.days,
      'progress_time': QuestItemModel._durationToSeconds(instance.progressTime),
      'complete_time':
          QuestItemModel._nullableDateTimeToJson(instance.completeTime),
      'finish': instance.isCompleted,
      'quest_type': instance.questType,
      'start_time': QuestItemModel._nullableDateTimeToJson(instance.startTime),
      'stop_time': QuestItemModel._nullableDateTimeToJson(instance.stopTime),
      'finish_time':
          QuestItemModel._nullableDateTimeToJson(instance.finishTime),
      'deadline': QuestItemModel._nullableDateTimeToJson(instance.deadline),
    };
