import 'package:json_annotation/json_annotation.dart';

part "quest_item_model.g.dart";

@JsonSerializable(explicitToJson: true)
class QuestItemModel {
  @JsonKey(fromJson: _fromDynamicToString)
  final String id;

  final String title;
  final String description;

  @JsonKey(name: 'deadline', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? deadline;

  @JsonKey(name: 'is_completed', defaultValue: false)
  final bool isCompleted;

  final String difficulty;

  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(name: 'is_hero', defaultValue: false)
  final bool isHero;

  @JsonKey(
    name: 'progress_time',
    fromJson: _durationFromSeconds,
    toJson: _durationToSeconds,
    defaultValue: Duration.zero,
    includeIfNull: false,
  )
  final Duration progressTime;

  @JsonKey(
    name: 'total_time',
    fromJson: _durationFromSeconds,
    toJson: _durationToSeconds,
    defaultValue: Duration.zero,
    includeIfNull: false,
  )
  final Duration totalTime;

  const QuestItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.isCompleted = false,
    required this.difficulty,
    required this.createdAt,
    this.isHero = false,
    this.progressTime = Duration.zero,
    this.totalTime = Duration.zero,
  });

  /// JSON → 객체 변환
  factory QuestItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestItemModelFromJson(json);

  /// 객체 → JSON 변환
  Map<String, dynamic> toJson() => _$QuestItemModelToJson(this);

  /// 객체 복사 메서드
  QuestItemModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    String? difficulty,
    DateTime? createdAt,
    bool? isHero,
    Duration? progressTime,
    Duration? totalTime,
  }) {
    return QuestItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      isHero: isHero ?? this.isHero,
      progressTime: progressTime ?? this.progressTime,
      totalTime: totalTime ?? this.totalTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is QuestItemModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              description == other.description &&
              deadline == other.deadline &&
              isCompleted == other.isCompleted &&
              difficulty == other.difficulty &&
              createdAt == other.createdAt &&
              isHero == other.isHero &&
              progressTime == other.progressTime &&
              totalTime == other.totalTime;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      deadline.hashCode ^
      isCompleted.hashCode ^
      difficulty.hashCode ^
      createdAt.hashCode ^
      isHero.hashCode ^
      progressTime.hashCode ^
      totalTime.hashCode;

  /// ✅ Duration ↔ int 변환 헬퍼
  static Duration _durationFromSeconds(int seconds) => Duration(seconds: seconds);
  static int _durationToSeconds(Duration duration) => duration.inSeconds;

  /// ✅ DateTime ↔ String 변환 헬퍼
  static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
  static String _dateTimeToJson(DateTime date) => date.toUtc().toIso8601String();

  /// int값 id를 string으로 전환
  static String _fromDynamicToString(dynamic value) => value.toString();
}