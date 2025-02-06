import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String email;
  final String name;
  @JsonKey(name: 'profile_img')
  final String? profileImageUrl;
  final String? nickname;
  final int level;
  @JsonKey(name: 'join_date')
  final DateTime joinDate;
  @JsonKey(name: 'update_date')
  final DateTime updateDate;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.nickname,
    this.level = 1,
    required this.joinDate,
    required this.updateDate,
  });

  // Factory constructor for creating UserModel from login response
  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImageUrl: json['profile_img'],
      nickname: json['nickname'] ?? json['name'],
      level: json['hero_level'] ?? 1,
      joinDate: DateTime.parse(json['join_date']),
      updateDate: DateTime.parse(json['update_date']),
    );
  }

  // Factory constructor for creating UserModel from register response
  factory UserModel.fromRegisterResponse(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImageUrl: json['profile_img'],
      nickname: json['nickname'] ?? json['name'],
      level: 1,
      joinDate: DateTime.parse(json['join_date']),
      updateDate: DateTime.parse(json['update_date']),
    );
  }

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Copy with method for creating new instance with some updated fields
  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? nickname,
    int? level,
    DateTime? joinDate,
    DateTime? updateDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      joinDate: joinDate ?? this.joinDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}