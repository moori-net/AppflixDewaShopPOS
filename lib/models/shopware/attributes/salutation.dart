import '../translated.dart';
import 'attributes.dart';

class Salutation extends Attributes {
  final String? salutationKey;
  final String? displayName;
  final String? letterName;
  final dynamic customFields;
  final Translated? translated;

  const Salutation({
    this.salutationKey,
    this.displayName,
    this.letterName,
    this.customFields,
    this.translated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory Salutation.fromJson(Map<String, dynamic> json) => Salutation(
        salutationKey: json['salutationKey'],
        displayName: json['displayName'],
        letterName: json['letterName'],
        customFields: json['customFields'],
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
        'salutationKey': salutationKey,
        'displayName': displayName,
        'letterName': letterName,
        'customFields': customFields,
        'translated': translated?.toJson(),
        ...super.toJson(),
      };

  @override
  String toString() => 'Salutation(${toJson()}';
}
