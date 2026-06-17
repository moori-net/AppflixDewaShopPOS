import '../item_rounding.dart';
import '../translated.dart';
import 'attributes.dart';

class Currency extends Attributes {
  final double? factor;
  final String? symbol;
  final String? isoCode;
  final String? shortName;
  final String? name;
  final int? position;
  final bool? isSystemDefault;
  final dynamic customFields;
  final ItemRounding? itemRounding;
  final ItemRounding? totalRounding;
  final num? taxFreeFrom;
  final Translated? translated;

  const Currency({
    this.factor,
    this.symbol,
    this.isoCode,
    this.shortName,
    this.name,
    this.position,
    this.isSystemDefault = false,
    this.customFields,
    this.itemRounding,
    this.totalRounding,
    this.taxFreeFrom,
    this.translated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        factor: json['factor'],
        symbol: json['symbol'],
        isoCode: json['isoCode'],
        shortName: json['shortName'],
        name: json['name'],
        position: json['position'],
        isSystemDefault: json['isSystemDefault'],
        customFields: json['customFields'] ?? {},
        itemRounding: json['itemRounding'] != null
            ? ItemRounding.fromJson(
                json['itemRounding'] as Map<String, dynamic>)
            : null,
        totalRounding: json['totalRounding'] != null
            ? ItemRounding.fromJson(
                json['totalRounding'] as Map<String, dynamic>)
            : null,
        taxFreeFrom: json['taxFreeFrom'],
        translated: json['translated'] != null
            ? Translated.fromJson(json['translated'] as Map<String, dynamic>)
            : null,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  @override
  Map<String, dynamic> toJson() => {
        'factor': factor,
        'symbol': symbol,
        'isoCode': isoCode,
        'shortName': shortName,
        'name': name,
        'position': position,
        'isSystemDefault': isSystemDefault,
        'customFields': customFields,
        'itemRounding': itemRounding?.toJson(),
        'totalRounding': totalRounding?.toJson(),
        'taxFreeFrom': taxFreeFrom,
        'translated': translated?.toJson(),
        ...super.toJson(),
      };

  @override
  String toString() => 'Currency(${toJson()}';
}
