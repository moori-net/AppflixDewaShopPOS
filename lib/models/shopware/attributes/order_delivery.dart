import '../shipping_costs.dart';
import 'attributes.dart';
import 'order_address.dart';

class OrderDelivery extends Attributes {
  final String? versionId;
  final String? orderId;
  final String? orderVersionId;
  final String? shippingOrderAddressId;
  final String? shippingOrderAddressVersionId;
  final String? shippingMethodId;
  final String? stateId;
  final List trackingCodes;
  final DateTime? shippingDateEarliest;
  final DateTime? shippingDateLatest;
  final ShippingCosts? shippingCosts;
  final OrderAddress? shippingOrderAddress;
  final dynamic customFields;

  OrderDelivery({
    this.versionId,
    this.orderId,
    this.orderVersionId,
    this.shippingOrderAddressId,
    this.shippingOrderAddressVersionId,
    this.shippingMethodId,
    this.stateId,
    this.trackingCodes = const [],
    this.shippingDateEarliest,
    this.shippingDateLatest,
    this.shippingCosts,
    this.shippingOrderAddress,
    this.customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory OrderDelivery.fromJson(Map json) => OrderDelivery(
    versionId: json['versionId'],
    orderId: json['orderId'],
    orderVersionId: json['orderVersionId'],
    shippingOrderAddressId: json['shippingOrderAddressId'],
    shippingOrderAddressVersionId: json['shippingOrderAddressVersionId'],
    shippingMethodId: json['shippingMethodId'],
    stateId: json['stateId'],
    trackingCodes: json['trackingCodes'],
    shippingDateEarliest: DateTime.parse(json['shippingDateEarliest'] ?? ''),
    shippingDateLatest: DateTime.parse(json['shippingDateLatest'] ?? ''),
    shippingCosts: json['shippingCost'],
    shippingOrderAddress: json['shippingOrderAddress'],
    customFields: json['customFields'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
  );

  @override
  Map<String, dynamic> toJson() => {
    'versionId': versionId,
    'orderId': orderId,
    'orderVersionId': orderVersionId,
    'shippingOrderAddressId': shippingOrderAddressId,
    'shippingOrderAddressVersionId': shippingOrderAddressVersionId,
    'shippingMethodId': shippingMethodId,
    'stateId': stateId,
    'trackingCodes': trackingCodes,
    'shippingDateEarliest': shippingDateEarliest?.toIso8601String(),
    'shippingDateLatest': shippingDateLatest,
    'shippingCosts': shippingCosts?.toJson(),
    'shippingOrderAddress': shippingOrderAddress?.toJson(),
    'customFields': customFields,
    ...super.toJson(),
  };

  @override
  String toString() => 'OrderDelivery(${toJson()})';
}
