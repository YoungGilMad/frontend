// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestItemModel _$QuestItemModelFromJson(Map<String, dynamic> json) =>
    QuestItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
      difficulty: json['difficulty'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$QuestItemModelToJson(QuestItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline?.toIso8601String(),
      'is_completed': instance.isCompleted,
      'difficulty': instance.difficulty,
      'created_at': instance.createdAt.toIso8601String(),
    };
