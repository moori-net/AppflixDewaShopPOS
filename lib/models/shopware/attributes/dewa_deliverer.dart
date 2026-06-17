import 'attributes.dart';

class DewaDeliverer extends Attributes {
  final String? mediaId;
  final String? shopId;
  final bool? active;
  final String? name;
  final String? trackingCode;
  final double? locationLat;
  final double? locationLon;
  final String? phoneNumber;

  const DewaDeliverer({
    this.mediaId,
    this.shopId,
    this.active = false,
    this.name,
    this.trackingCode,
    this.locationLat,
    this.locationLon,
    this.phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DewaDeliverer.fromJson(Map<String, dynamic> json) => DewaDeliverer(
        mediaId: json['mediaId'],
        shopId: json['shopId'],
        active: json['active'],
        name: json['name'],
        trackingCode: json['trackingCode'],
        locationLat: json['locationLat'],
        locationLon: json['locationLon'],
        phoneNumber: json['phoneNumber'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  @override
  Map<String, dynamic> toJson() => {
        'mediaId': mediaId,
        'shopId': shopId,
        'active': active,
        'name': name,
        'trackingCode': trackingCode,
        'locationLat': locationLat,
        'locationLon': locationLon,
        'phoneNumber': phoneNumber,
        ...super.toJson(),
      };

  @override
  String toString() => 'DewaDeliverer(${toJson()})';
}
