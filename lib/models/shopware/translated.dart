import 'package:equatable/equatable.dart';

class Translated extends Equatable {
  final String? name;
  final String? distinguishableName;
  final String? description;
  final dynamic customFields;

  const Translated({
    this.name,
    this.customFields = const [],
    this.distinguishableName,
    this.description,
  });

  factory Translated.fromJson(Map<String, dynamic> json) => Translated(
        name: json['name'] as String?,
        customFields: (json['customFields']) ?? const [],
        description: json['description'],
        distinguishableName: json['distinguishableName'],
      );

  @override
  List<Object?> get props => [name, customFields];

  Map<String, dynamic> toJson() => {
        'name': name,
        'customFields': customFields,
        'description': description,
        'distinguishableName': distinguishableName
      };

  @override
  String toString() => 'Translated(${toJson()})';
}
