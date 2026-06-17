import 'payload_item.dart';

class Payload {
  final List<PayloadItem> dewaShop;
  final List<PayloadItem> dewa;
  final num? stockUnit;
  final String? productNumber;
  final dynamic customFields;

  Payload({
    this.dewaShop = const [],
    this.dewa = const [],
    this.stockUnit,
    this.productNumber,
    this.customFields = const {},
  });

  factory Payload.fromJson(Map json) => Payload(
        dewaShop: (json['dewa_shop'] as List? ?? [])
            .map((e) => PayloadItem.fromJson(e))
            .toList(),
        dewa: (json['dewa'] as List? ?? [])
            .map((e) => PayloadItem.fromJson(e))
            .toList(),
        stockUnit: json['stockUnit'] as num?,
        productNumber: json['productNumber'],
        customFields: json['customFields'] ?? const {},
      );

  Map<String, dynamic> toJson() => {
        'dewa_shop': dewaShop.map((e) => e.toJson()),
        'dewa': dewa.map((e) => e.toJson()),
        'stockUnit': stockUnit,
        'productNumber': productNumber,
        'customFields': customFields,
      };

  @override
  String toString() => 'Payload(${toJson()})';
}
