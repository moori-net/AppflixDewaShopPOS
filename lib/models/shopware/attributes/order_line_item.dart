import '../payload.dart';
import '../price.dart';
import 'attributes.dart';

class OrderLineItem extends Attributes {
  final String? versionId;
  final String orderId;
  final String? orderVersionId;
  final String? productId;
  final String? productVersionId;
  final String? promotionId;
  final String? parentId;
  final String? parentVersionId;
  final String? coverId;
  final String? identifier;
  final String? referencedId;
  final int quantity;
  final String label;
  final Payload? payload;
  final bool good;
  final bool removable;
  final bool stackable;
  final int? position;
  final Price? price;
  final dynamic priceDefinition;
  final num? unitPrice;
  final num? totalPrice;
  final String? description;
  final String? type;
  final dynamic customFields;

  OrderLineItem({
    this.versionId,
    required this.orderId,
    this.orderVersionId,
    this.productId,
    this.productVersionId,
    this.promotionId,
    this.parentId,
    this.parentVersionId,
    this.coverId,
    this.identifier,
    this.referencedId,
    this.quantity = 1,
    required this.label,
    this.payload,
    this.good = false,
    this.removable = false,
    this.stackable = false,
    this.position,
    this.price,
    this.priceDefinition,
    this.unitPrice,
    this.totalPrice,
    this.description,
    this.type,
    this.customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory OrderLineItem.fromJson(Map json) => OrderLineItem(
        versionId: json['versionId'],
        orderId: json['orderId'],
        orderVersionId: json['orderVersionId'],
        productVersionId: json['productVersionId'],
        parentVersionId: json['parentVersionId'],
        coverId: json['coverId'],
        identifier: json['identifier'],
        referencedId: json['referencedId'],
        quantity: json['quantity'],
        label: json['label'],
        payload:
            json['payload'] != null ? Payload.fromJson(json['payload']) : null,
        good: json['good'],
        removable: json['removable'],
        stackable: json['stackable'],
        position: json['position'],
        price: json['price'] != null ? Price.fromJson(json['price']) : null,
        unitPrice: json['unitPrice'],
        totalPrice: json['totalPrice'],
        type: json['type'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
        description: json['description'],
        parentId: json['parentId'],
        priceDefinition: json['priceDefinition'],
        productId: json['productId'],
        promotionId: json['promotionId'],
        customFields: json['customFields'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'versionId': versionId,
        'orderId': orderId,
        'orderVersionId': orderVersionId,
        'productId': productId,
        'productVersionId': productVersionId,
        'promotionId': promotionId,
        'parentId': parentId,
        'parentVersionId': parentVersionId,
        'coverId': coverId,
        'identifier': identifier,
        'referencedId': referencedId,
        'quantity': quantity,
        'label': label,
        'payload': payload?.toJson(),
        'good': good,
        'removable': removable,
        'stackable': stackable,
        'position': position,
        'price': price?.toJson(),
        'priceDefinition': priceDefinition,
        'unitPrice': unitPrice,
        'totalPrice': totalPrice,
        'description': description,
        'type': type,
        'customFields': customFields,
        ...super.toJson(),
      };
}
