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

  const QuestItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.isCompleted = false,
    required this.difficulty,
    required this.createdAt,
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
  }) {
    return QuestItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
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
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      deadline.hashCode ^
      isCompleted.hashCode ^
      difficulty.hashCode ^
      createdAt.hashCode;
}