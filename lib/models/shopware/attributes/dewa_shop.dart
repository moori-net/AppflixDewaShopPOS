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

  factory DewaShop.fromJson(Map<String, dynamic> map) => DewaShop(
    active: map['active'] ?? false,
    autoLocation: map['autoLocation'] ?? false,
    city: map['city'],
    collectActive: map['collectActive'] ?? false,
    countryId: map['countryId'],
    deliveryActive: map['deliveryActive'] ?? false,
    deliveryHours: map['deliveryHours'] is List
        ? List<Hours>.from(
      map['deliveryHours'].map((x) => Hours.fromJson(x)),
    )
        : const [],
    deliveryPrice: map['deliveryPrice'],
    deliveryTime: map['deliveryTime'],
    deliveryType: map['deliveryType'],
    email: map['email'],
    executiveDirector: map['executiveDirector'],
    isDefault: map['isDefault'] ?? false,
    isLimit: map['isLimit'] ?? false,
    isOpen: map['isOpen'] ?? false,
    limitAmount: map['limitAmount'],
    limitInterval: map['limitInterval'],
    limitRule: map['limitRule'],
    limitedAt: map['limitedAt'] != null &&
        map['limitedAt'].toString().isNotEmpty
        ? DateTime.parse(map['limitedAt'])
        : null,
    locationLat: map['locationLat'] != null
        ? (map['locationLat'] as num).toDouble()
        : null,
    locationLon: map['locationLon'] != null
        ? (map['locationLon'] as num).toDouble()
        : null,
    maxRadius: map['maxRadius'],
    mediaId: map['mediaId'],
    minOrderValue: map['minOrderValue'],
    name: map['name'] ?? '',
    openingHours: map['openingHours'] is List
        ? List<Hours>.from(
      map['openingHours'].map((x) => Hours.fromJson(x)),
    )
        : const [],
    phoneNumber: map['phoneNumber'],
    preparationTime: map['preparationTime'],
    searchPortalActive: map['searchPortalActive'] ?? false,
    shopCategories: map['shopCategories'] is List
        ? List<String>.from(map['shopCategories'].map((e) => e.toString()))
        : const [],
    street: map['street'],
    streetNumber: map['streetNumber'],
    timeZone: map['timeZone'],
    zipCode: map['zipCode'] ?? map['zipcode'],
    createdAt: map['createdAt'] != null
        ? DateTime.parse(map['createdAt'])
        : null,
    updatedAt: map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'])
        : null,
  );

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
        //'deliveryHours': List<Hours>.from(deliveryHours.map((x) => x.toJson())),
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
        //'openingHours': List<Hours>.from(openingHours.map((x) => x.toJson())),
        'phoneNumber': phoneNumber,
        'preparationTime': preparationTime,
        'searchPortalActive': searchPortalActive,
        'shopCategories': List<String>.from(shopCategories),
        'street': street,
        'streetNumber': streetNumber,
        'timeZone': timeZone,
        'zipCode': zipCode,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => 'DewaShop(${toJson()})';
}
