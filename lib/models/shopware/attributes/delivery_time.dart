import '../translated.dart';
import 'attributes.dart';

class DeliveryTime extends Attributes {
  final String? name;
  final num? min;
  final num? max;
  final Translated? translated;
  final String? unit;

  const DeliveryTime({
    this.name,
    this.min,
    this.max,
    this.translated,
    this.unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
        name: json['name'] ?? '',
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        min: json['min'],
        max: json['max'],
        translated: json['translated'] != null
            ? Translated.fromJson(json['translated'])
            : null,
        unit: json['unit'],
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'min': min,
        'max': max,
        'translated': translated?.toJson(),
        'unit': unit,
        ...super.toJson(),
      };

  @override
  String toString() => 'DeliveryTime(${toJson()}';
}
