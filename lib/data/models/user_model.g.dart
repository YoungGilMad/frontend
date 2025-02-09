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
      level: (json['hero_level'] as num?)?.toInt() ?? 1,
      joinDate: UserModel._dateFromJson(json['join_date']),
      updateDate: UserModel._dateFromJson(json['update_date']),
      coin: (json['coin'] as num?)?.toInt() ?? 0,
      avatarId: (json['avatar_id'] as num?)?.toInt(),
      backgroundId: (json['background_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'profile_img': instance.profileImageUrl,
      'nickname': instance.nickname,
      'hero_level': instance.level,
      'join_date': UserModel._dateToJson(instance.joinDate),
      'update_date': UserModel._dateToJson(instance.updateDate),
      'coin': instance.coin,
      'avatar_id': instance.avatarId,
      'background_id': instance.backgroundId,
    };
