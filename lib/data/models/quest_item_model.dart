import 'package:json_annotation/json_annotation.dart';

part 'quest_item_model.g.dart';

@JsonSerializable()
class QuestItemModel {
  final String id;
  final String title;
  final String description;

  @JsonKey(name: 'deadline')
  final DateTime? deadline;

  @JsonKey(name: 'is_completed', defaultValue: false)
  final bool isCompleted;

  final String difficulty;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_hero', defaultValue: false)
  final bool isHero;

  @JsonKey(
    name: 'progress_time',
    fromJson: _durationFromSeconds,
    toJson: _durationToSeconds,
    defaultValue: Duration.zero,
  )
  final Duration progressTime; // ✅ 진행 시간 추가

  @JsonKey(
    name: 'total_time',
    fromJson: _durationFromSeconds,
    toJson: _durationToSeconds,
    defaultValue: Duration.zero,
  )
  final Duration totalTime; // ✅ 완료 시간 추가

  const QuestItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.isCompleted = false,
    required this.difficulty,
    required this.createdAt,
    this.isHero = false,
    this.progressTime = Duration.zero, // ✅ 기본값
    this.totalTime = Duration.zero,    // ✅ 기본값
  });

  /// JSON → 객체 변환
  factory QuestItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestItemModelFromJson(json);

  /// 객체 → JSON 변환
  Map<String, dynamic> toJson() => _$QuestItemModelToJson(this);

  /// 객체 복사 메서드 (변경할 값만 지정)
  QuestItemModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    String? difficulty,
    DateTime? createdAt,
    bool? isHero,
    Duration? progressTime, // ✅ 추가
    Duration? totalTime,    // ✅ 추가
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
      progressTime: progressTime ?? this.progressTime, // ✅ 추가
      totalTime: totalTime ?? this.totalTime,          // ✅ 추가
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
              progressTime == other.progressTime && // ✅ 비교 추가
              totalTime == other.totalTime;         // ✅ 비교 추가

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
      progressTime.hashCode ^ // ✅ 해시 추가
      totalTime.hashCode;     // ✅ 해시 추가

  /// ✅ Duration ↔ int 변환 헬퍼
  static Duration _durationFromSeconds(int seconds) => Duration(seconds: seconds);
  static int _durationToSeconds(Duration duration) => duration.inSeconds;
  /*
    아래와 같이 사용
      progressTime: Duration(hours: 1, minutes: 20, seconds: 11), // 진행시간
      totalTime: Duration(hours: 3),
   */
}