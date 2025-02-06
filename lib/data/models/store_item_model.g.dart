// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreItemModel _$StoreItemModelFromJson(Map<String, dynamic> json) =>
    StoreItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      itemType: json['item_type'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isOwned: json['isOwned'] as bool? ?? false,
      isEquipped: json['isEquipped'] as bool? ?? false,
    );

Map<String, dynamic> _$StoreItemModelToJson(StoreItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'item_type': instance.itemType,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'isOwned': instance.isOwned,
      'isEquipped': instance.isEquipped,
    };
