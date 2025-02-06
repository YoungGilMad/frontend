import 'package:json_annotation/json_annotation.dart';

part 'store_item_model.g.dart';

@JsonSerializable()
class StoreItemModel {
  final String id;
  final String name;
  final int price;
  @JsonKey(name: 'item_type')
  final String itemType;
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(defaultValue: false)
  final bool isOwned;
  @JsonKey(defaultValue: false)
  final bool isEquipped;

  const StoreItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.itemType,
    this.description,
    this.imageUrl,
    this.isOwned = false,
    this.isEquipped = false,
  });

  // JSON 직렬화/역직렬화를 위한 factory 메서드
  factory StoreItemModel.fromJson(Map<String, dynamic> json) => 
      _$StoreItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreItemModelToJson(this);

  // 아이템 타입 검증
  static bool isValidItemType(String type) {
    return ['avatar', 'background', 'effect'].contains(type.toLowerCase());
  }

  // 새로운 상태의 아이템 인스턴스 생성
  StoreItemModel copyWith({
    String? id,
    String? name,
    int? price,
    String? itemType,
    String? description,
    String? imageUrl,
    bool? isOwned,
    bool? isEquipped,
  }) {
    return StoreItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      itemType: itemType ?? this.itemType,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isOwned: isOwned ?? this.isOwned,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  // 아이템 가격 검증
  bool isAffordable(int userCoins) => userCoins >= price;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          itemType == other.itemType &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          isOwned == other.isOwned &&
          isEquipped == other.isEquipped;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      price.hashCode ^
      itemType.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      isOwned.hashCode ^
      isEquipped.hashCode;
}