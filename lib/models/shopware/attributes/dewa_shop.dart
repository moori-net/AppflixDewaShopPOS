import '/utils/json_util.dart';

import '../hours.dart';
import 'attributes.dart';

class DewaShop extends Attributes {
  final bool active;
  final bool? autoLocation;
  final String? city;
  final bool collectActive;
  final String? countryId;
  final bool deliveryActive;
  final List<Hours> deliveryHours;
  final num? deliveryPrice;
  final num? deliveryTime;
  final String? deliveryType;
  final String? email;
  final String? executiveDirector;
  final bool? isDefault;
  final bool? isLimit;
  final bool isOpen;
  final num? limitAmount;
  final String? limitInterval;
  final String? limitRule;
  final DateTime? limitedAt;
  final double? locationLat;
  final double? locationLon;
  final num? maxRadius;
  final String? mediaId;
  final num? minOrderValue;
  final String name;
  final List<Hours> openingHours;
  final String? phoneNumber;
  final num? preparationTime;
  final bool? searchPortalActive;
  final List<String> shopCategories;
  final String? street;
  final String? streetNumber;
  final String? timeZone;
  final String? zipCode;

  DewaShop({
    this.active = false,
    this.autoLocation = false,
    this.city,
    this.collectActive = false,
    this.countryId,
    this.deliveryActive = false,
    this.deliveryHours = const [],
    this.deliveryPrice,
    this.deliveryTime,
    this.deliveryType,
    this.email,
    this.executiveDirector,
    this.isDefault = false,
    this.isLimit = false,
    this.isOpen = false,
    this.limitAmount,
    this.limitInterval,
    this.limitRule,
    this.limitedAt,
    this.locationLat,
    this.locationLon,
    this.maxRadius,
    this.mediaId,
    this.minOrderValue,
    required this.name,
    this.openingHours = const [],
    this.phoneNumber,
    this.preparationTime,
    this.searchPortalActive = false,
    this.shopCategories = const [],
    this.street,
    this.streetNumber,
    this.timeZone,
    this.zipCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DewaShop.fromJson(dynamic json) {
    final map = asMap(json);

    return DewaShop(
      active: asBool(map['active']),
      autoLocation: asBool(map['autoLocation']),
      city: asStringOrNull(map['city']),
      collectActive: asBool(map['collectActive']),
      countryId: asStringOrNull(map['countryId']),
      deliveryActive: asBool(map['deliveryActive']),
      deliveryHours: asTypedList(
        map['deliveryHours'],
            (item) => Hours.fromJson(asMap(item)),
      ),
      deliveryPrice: asNumOrNull(map['deliveryPrice']),
      deliveryTime: asNumOrNull(map['deliveryTime']),
      deliveryType: asStringOrNull(map['deliveryType']),
      email: asStringOrNull(map['email']),
      executiveDirector: asStringOrNull(map['executiveDirector']),
      isDefault: asBool(map['isDefault']),
      isLimit: asBool(map['isLimit']),
      isOpen: asBool(map['isOpen']),
      limitAmount: asNumOrNull(map['limitAmount']),
      limitInterval: asStringOrNull(map['limitInterval']),
      limitRule: asStringOrNull(map['limitRule']),
      limitedAt: asDateTimeOrNull(map['limitedAt']),
      locationLat: asDoubleOrNull(map['locationLat']),
      locationLon: asDoubleOrNull(map['locationLon']),
      maxRadius: asNumOrNull(map['maxRadius']),
      mediaId: asStringOrNull(map['mediaId']),
      minOrderValue: asNumOrNull(map['minOrderValue']),
      name: asString(map['name']),
      openingHours: asTypedList(
        map['openingHours'],
            (item) => Hours.fromJson(asMap(item)),
      ),
      phoneNumber: asStringOrNull(map['phoneNumber']),
      preparationTime: asNumOrNull(map['preparationTime']),
      searchPortalActive: asBool(map['searchPortalActive']),
      shopCategories: asTypedList(
        map['shopCategories'],
            (item) => item.toString(),
      ),
      street: asStringOrNull(map['street']),
      streetNumber: asStringOrNull(map['streetNumber']),
      timeZone: asStringOrNull(map['timeZone']),
      zipCode: asStringOrNull(map['zipCode'] ?? map['zipcode']),
      createdAt: asDateTimeOrNull(map['createdAt']),
      updatedAt: asDateTimeOrNull(map['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'isOpen': isOpen,
    'active': active,
    'deliveryActive': deliveryActive,
    'collectActive': collectActive,
    'isDefault': isDefault,
    'autoLocation': autoLocation,
    'city': city,
    'countryId': countryId,
    'deliveryHours': deliveryHours.map((x) => x.toJson()).toList(),
    'deliveryPrice': deliveryPrice,
    'deliveryTime': deliveryTime,
    'deliveryType': deliveryType,
    'email': email,
    'executiveDirector': executiveDirector,
    'isLimit': isLimit,
    'limitAmount': limitAmount,
    'limitInterval': limitInterval,
    'limitRule': limitRule,
    'limitedAt': limitedAt?.toIso8601String(),
    'locationLat': locationLat,
    'locationLon': locationLon,
    'maxRadius': maxRadius,
    'mediaId': mediaId,
    'minOrderValue': minOrderValue,
    'openingHours': openingHours.map((x) => x.toJson()).toList(),
    'phoneNumber': phoneNumber,
    'preparationTime': preparationTime,
    'searchPortalActive': searchPortalActive,
    'shopCategories': List<String>.from(shopCategories),
    'street': street,
    'streetNumber': streetNumber,
    'timeZone': timeZone,
    'zipcode': zipCode,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  @override
  String toString() => 'DewaShop(${toJson()})';
}
