import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  final String name;
  final String? phoneNumber;
  final String email;
  final String? profileImg;
  final DateTime? joinDate;
  final DateTime? updateDate;

  UserModel({
    this.id,
    required this.name,
    this.phoneNumber,
    required this.email,
    this.profileImg,
    this.joinDate,
    this.updateDate,
  });

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Copy with method for immutability
  UserModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? profileImg,
    DateTime? joinDate,
    DateTime? updateDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profileImg: profileImg ?? this.profileImg,
      joinDate: joinDate ?? this.joinDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  // Auth related models
  static UserModel fromLoginResponse(Map<String, dynamic> json) {
    return UserModel.fromJson(json['user']);
  }

  static UserModel fromRegisterResponse(Map<String, dynamic> json) {
    return UserModel.fromJson(json['user']);
  }
}