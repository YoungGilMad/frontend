import 'package:json_annotation/json_annotation.dart';

part 'quest_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestItemModel {
  @JsonKey(fromJson: _fromDynamicToString)
  final String id;

  final String title;
  final String description;

  final String? tag;
  final int? days;

  @JsonKey(name: 'progress_time', fromJson: _durationFromSeconds, toJson: _durationToSeconds)
  final Duration progressTime;

  @JsonKey(name: 'complete_time', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? completeTime;

  @JsonKey(name: 'finish')
  final bool isCompleted;

  @JsonKey(name: 'quest_type')
  final String questType;

  @JsonKey(name: 'start_time', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? startTime;

  @JsonKey(name: 'stop_time', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? stopTime;

  @JsonKey(name: 'finish_time', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? finishTime;

  @JsonKey(name: 'deadline', fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? deadline;

  // 👇 프론트 전용 필드
  @JsonKey(ignore: true)
  final String difficulty;

  @JsonKey(ignore: true)
  final Duration totalTime;

  const QuestItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.tag,
    this.days,
    this.progressTime = Duration.zero,
    this.completeTime,
    this.isCompleted = false,
    required this.questType,
    this.startTime,
    this.stopTime,
    this.finishTime,
    this.deadline,
    // 프론트 전용 초기값
    this.difficulty = 'normal',
    this.totalTime = const Duration(),
  });

  factory QuestItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestItemModelToJson(this);

  static Duration _durationFromSeconds(int seconds) => Duration(seconds: seconds);
  static int _durationToSeconds(Duration duration) => duration.inSeconds;

  static String _fromDynamicToString(dynamic value) => value.toString();

  static DateTime? _nullableDateTimeFromJson(dynamic value) =>
      value == null ? null : DateTime.parse(value);
  static String? _nullableDateTimeToJson(DateTime? date) =>
      date?.toUtc().toIso8601String();
}

/**
 * 만약 difficulty, totalTime 같은 필드는 프론트에서만 사용 -> 데이터 직렬화(JSON) X
 * finish가 isCompleted로 맵핑됨 (0 or 1이므로 FastAPI에서 bool로 바꾸는 로직 필요할 수도 있음).
 */