import '../item_rounding.dart';
import '../price.dart';
import '../shipping_costs.dart';
import 'attributes.dart';

class Order extends Attributes {
  final String? affiliateCode;
  final double? amountNet;
  final double? amountTotal;
  final int? autoIncrement;
  final String? billingAddressId;
  final String? billingAddressVersionId;
  final String? campaignCode;
  final String? createdById;
  final num? currencyFactor;
  final String? currencyId;
  final dynamic customFields;
  final String? customerComment;
  final String? deepLinkCode;
  final ItemRounding? itemRounding;
  final String? languageId;
  final DateTime orderDateTime;
  final String orderNumber;
  final num? positionPrice;
  final Price? price;
  final List<String> ruleIds;
  final String salesChannelId;
  final ShippingCosts? shippingCosts;
  final num? shippingTotal;
  final String stateId;
  final String? updatedById;
  final String? versionId;

  const Order({
    this.affiliateCode,
    this.amountNet,
    this.amountTotal,
    this.autoIncrement,
    this.billingAddressId,
    this.billingAddressVersionId,
    this.campaignCode,
    this.createdById,
    this.currencyFactor,
    this.currencyId,
    this.customFields,
    this.customerComment,
    this.deepLinkCode,
    this.itemRounding,
    this.languageId,
    required this.orderDateTime,
    required this.orderNumber,
    this.positionPrice,
    this.price,
    required this.ruleIds,
    required this.salesChannelId,
    this.shippingCosts,
    this.shippingTotal,
    required this.stateId,
    this.updatedById,
    this.versionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        affiliateCode: json['affiliateCode'],
        amountNet: json['amountNet'],
        amountTotal: json['amountTotal'],
        autoIncrement: json['autoIncrement'],
        billingAddressId: json['billingAddressId'],
        billingAddressVersionId: json['billingAddressVersionId'],
        campaignCode: json['campaignCode'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        createdById: json['createdById'],
        currencyFactor: json['currencyFactor'],
        currencyId: json['currencyId'],
        customFields: json['customFields'],
        customerComment: json['customerComment'],
        deepLinkCode: json['deepLinkCode'],
        itemRounding: json['itemRounding'] != null
            ? ItemRounding.fromJson(json['itemRounding'])
            : null,
        languageId: json['languageId'],
        orderDateTime:
            DateTime.tryParse(json['orderDateTime'] ?? '') ?? DateTime.now(),
        orderNumber: json['orderNumber'],
        positionPrice: json['positionPrice'],
        price: json['price'] != null ? Price.fromJson(json['price']) : null,
        ruleIds: json['ruleIds'] != null
            ? List<String>.from(json['ruleIds'].map((x) => x))
            : const [],
        salesChannelId: json['salesChannelId'],
        shippingCosts: json['shippingCosts'] != null
            ? ShippingCosts.fromJson(json['shippingCosts'])
            : null,
        shippingTotal: json['shippingTotal'],
        stateId: json['stateId'],
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
        updatedById: json['updatedById'],
        versionId: json['versionId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'affiliateCode': affiliateCode,
        'amountNet': amountNet,
        'amountTotal': amountTotal,
        'autoIncrement': autoIncrement,
        'billingAddressId': billingAddressId,
        'billingAddressVersionId': billingAddressVersionId,
        'campaignCode': campaignCode,
        'createdById': createdById,
        'currencyFactor': currencyFactor,
        'currencyId': currencyId,
        'customFields': customFields,
        'customerComment': customerComment,
        'deepLinkCode': deepLinkCode,
        'itemRounding': itemRounding?.toJson(),
        'languageId': languageId,
        'orderDateTime': orderDateTime.toIso8601String(),
        'orderNumber': orderNumber,
        'positionPrice': positionPrice,
        'price': price?.toJson(),
        'ruleIds': List<dynamic>.from(ruleIds.map((x) => x)),
        'salesChannelId': salesChannelId,
        'shippingCosts': shippingCosts?.toJson(),
        'shippingTotal': shippingTotal,
        'stateId': stateId,
        'updatedById': updatedById,
        'versionId': versionId,
        ...super.toJson(),
      };

  @override
  String toString() => 'Order(${toJson()})';
}
