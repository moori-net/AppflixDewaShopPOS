import 'attributes.dart';

class DewaShopOrder extends Attributes {
  final String? comment;
  final String? delivererId;
  final DateTime? desiredTime;
  final double? distance;
  final double? locationLat;
  final double? locationLon;
  final String? orderId;
  final String? orderVersionId;
  final String? shopId;

  const DewaShopOrder({
    this.comment,
    this.delivererId,
    this.desiredTime,
    this.distance,
    this.locationLat,
    this.locationLon,
    this.orderId,
    this.orderVersionId,
    this.shopId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DewaShopOrder.fromJson(Map<String, dynamic> json) => DewaShopOrder(
        comment: json['comment'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        delivererId: json['delivererId'],
        desiredTime: DateTime.parse(json['desiredTime']),
        distance: json['distance'],
        locationLat: json['locationLat'],
        locationLon: json['locationLon'],
        orderId: json['orderId'],
        orderVersionId: json['orderVersionId'],
        shopId: json['shopId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'comment': comment,
        'delivererId': delivererId,
        'desiredTime': desiredTime?.toIso8601String(),
        'distance': distance,
        'locationLat': locationLat,
        'locationLon': locationLon,
        'orderId': orderId,
        'orderVersionId': orderVersionId,
        'shopId': shopId,
        ...super.toJson(),
      };

  @override
  String toString() => 'DewaShopOrder(${toJson()}';
}
