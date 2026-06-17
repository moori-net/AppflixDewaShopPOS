import '../translated.dart';
import 'attributes.dart';

class ShippingMethod extends Attributes {
  final String name;
  final bool active;
  final int? position;
  final dynamic customFields;
  final String? availabilityRuleId;
  final String? mediaId;
  final String? deliveryTimeId;
  final String? taxType;
  final String? taxId;
  final String? description;
  final String? trackingUrl;
  final Translated? translated;

  const ShippingMethod({
    required this.name,
    this.active = false,
    this.position,
    this.customFields,
    this.availabilityRuleId,
    this.mediaId,
    this.deliveryTimeId,
    this.taxType,
    this.taxId,
    this.description,
    this.trackingUrl,
    this.translated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        name: json['name'],
        active: json['active'],
        position: json['position'],
        customFields: json['customFields'],
        availabilityRuleId: json['availabilityRuleId'],
        mediaId: json['mediaId'],
        deliveryTimeId: json['deliveryTimeId'],
        taxType: json['taxType'],
        taxId: json['taxId'],
        description: json['description'],
        trackingUrl: json['trackingUrl'],
        translated: json['translated'] != null
            ? Translated.fromJson(json['translated'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );

  ShippingMethodType get type {
    if (name.toLowerCase().contains('selbstabholung')) {
      return ShippingMethodType.pickup;
    } else {
      return ShippingMethodType.delivery;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'active': active,
        'position': position,
        'customFields': customFields,
        'availabilityRuleId': availabilityRuleId,
        'mediaId': mediaId,
        'deliveryTimeId': deliveryTimeId,
        'taxType': taxType,
        'taxId': taxId,
        'description': description,
        'trackingUrl': trackingUrl,
        'translated': translated?.toJson(),
        ...super.toJson(),
      };

  @override
  String toString() => 'ShippingMethod(${toJson()}';
}

enum ShippingMethodType {
  delivery,
  pickup,
}
