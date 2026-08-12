// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductReview _$ProductReviewFromJson(Map<String, dynamic> json) =>
    _ProductReview(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productType: $enumDecode(_$ReviewProductTypeEnumMap, json['productType']),
      productName: json['productName'] as String,
      orderId: json['orderId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductReviewToJson(_ProductReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productType': _$ReviewProductTypeEnumMap[instance.productType]!,
      'productName': instance.productName,
      'orderId': instance.orderId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ReviewProductTypeEnumMap = {
  ReviewProductType.menu: 'menu',
  ReviewProductType.bean: 'bean',
};

_ProductStats _$ProductStatsFromJson(Map<String, dynamic> json) =>
    _ProductStats(
      productId: json['productId'] as String,
      ratingSum: (json['ratingSum'] as num?)?.toInt() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      salesCount: (json['salesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductStatsToJson(_ProductStats instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'ratingSum': instance.ratingSum,
      'ratingCount': instance.ratingCount,
      'salesCount': instance.salesCount,
    };
