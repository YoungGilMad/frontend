import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class UserModel {
  final int id;
  final String email;
  final String name;
  @JsonKey(name: 'profile_img')
  final String? profileImageUrl;
  final String? nickname;
  @JsonKey(name: 'hero_level', defaultValue: 1)
  final int level;
  @JsonKey(
    name: 'join_date',
    fromJson: _dateFromJson,
    toJson: _dateToJson,
  )
  final DateTime joinDate;
  @JsonKey(
    name: 'update_date',
    fromJson: _dateFromJson,
    toJson: _dateToJson,
  )
  final DateTime updateDate;
  @JsonKey(defaultValue: 0)
  final int coin;
  @JsonKey(name: 'avatar_id')
  final int? avatarId;
  @JsonKey(name: 'background_id')
  final int? backgroundId;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.nickname,
    this.level = 1,
    required this.joinDate,
    required this.updateDate,
    this.coin = 0,
    this.avatarId,
    this.backgroundId,
  });

  // DateTime JSON 변환 헬퍼 메서드들
  static DateTime _dateFromJson(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        print('Error parsing date: $e');
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static String _dateToJson(DateTime date) {
    return date.toIso8601String();
  }

  // Factory constructor for creating UserModel from login response
  factory UserModel.fromLoginResponse(Map<String, dynamic> json) {
    try {
      // 만약 json에 user 필드가 포함되어 있다면 해당 필드 사용
      final userData = json.containsKey('user') ? json['user'] : json;
      
      return UserModel(
        id: userData['id'] as int? ?? 0,
        email: userData['email'] as String? ?? '',
        name: userData['name'] as String? ?? '',
        profileImageUrl: userData['profile_img'] as String?,
        nickname: userData['nickname'] as String? ?? userData['name'] as String? ?? '',
        level: userData['hero_level'] as int? ?? 1,
        joinDate: _dateFromJson(userData['join_date']),
        updateDate: _dateFromJson(userData['update_date']),
        coin: userData['coin'] as int? ?? 0,
        avatarId: userData['avatar_id'] as int?,
        backgroundId: userData['background_id'] as int?,
      );
    } catch (e) {
      print('Error creating UserModel from login response: $e');
      print('Received JSON: $json');
      rethrow;
    }
  }
  // Factory constructor for creating UserModel from register response
  factory UserModel.fromRegisterResponse(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'] as int? ?? 0,
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        profileImageUrl: json['profile_img'] as String?,
        nickname: json['nickname'] as String? ?? json['name'] as String? ?? '',
        level: 1,
        joinDate: _dateFromJson(json['join_date']),
        updateDate: _dateFromJson(json['update_date']),
        coin: 0,
        avatarId: null,
        backgroundId: null,
      );
    } catch (e) {
      print('Error creating UserModel from register response: $e');
      print('Received JSON: $json');
      rethrow;
    }
  }

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Copy with method
  UserModel copyWith({
    int? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? nickname,
    int? level,
    DateTime? joinDate,
    DateTime? updateDate,
    int? coin,
    int? avatarId,
    int? backgroundId,
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
      coin: coin ?? this.coin,
      avatarId: avatarId ?? this.avatarId,
      backgroundId: backgroundId ?? this.backgroundId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          profileImageUrl == other.profileImageUrl &&
          nickname == other.nickname &&
          level == other.level &&
          joinDate == other.joinDate &&
          updateDate == other.updateDate &&
          coin == other.coin &&
          avatarId == other.avatarId &&
          backgroundId == other.backgroundId;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      profileImageUrl.hashCode ^
      nickname.hashCode ^
      level.hashCode ^
      joinDate.hashCode ^
      updateDate.hashCode ^
      coin.hashCode ^
      avatarId.hashCode ^
      backgroundId.hashCode;

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'email: $email, '
        'name: $name, '
        'profileImageUrl: $profileImageUrl, '
        'nickname: $nickname, '
        'level: $level, '
        'joinDate: $joinDate, '
        'updateDate: $updateDate, '
        'coin: $coin, '
        'avatarId: $avatarId, '
        'backgroundId: $backgroundId)';
  }
}