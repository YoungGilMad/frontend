// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      profileImageUrl: json['profile_img'] as String?,
      nickname: json['nickname'] as String?,
      level: (json['level'] as num?)?.toInt() ?? 1,
      joinDate: DateTime.parse(json['join_date'] as String),
      updateDate: DateTime.parse(json['update_date'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profile_img': instance.profileImageUrl,
      'nickname': instance.nickname,
      'level': instance.level,
      'join_date': instance.joinDate.toIso8601String(),
      'update_date': instance.updateDate.toIso8601String(),
    };
