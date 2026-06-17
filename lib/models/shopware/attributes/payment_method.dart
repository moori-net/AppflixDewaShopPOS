import '/utils/json_util.dart';

import '../translated.dart';
import 'attributes.dart';

class PaymentMethod extends Attributes {
  final String? pluginId;
  final String? handlerIdentifier;
  final String? name;
  final String distinguishableName;
  final String? description;
  final int? position;
  final bool active;
  final bool afterOrderEnabled;
  final dynamic customFields;
  final String? availabilityRuleId;
  final String? mediaId;
  final String? formattedHandlerIdentifier;
  final bool synchronous;
  final bool asynchronous;
  final bool prepared;
  final bool refundable;
  final Translated? translated;

  PaymentMethod({
    this.pluginId,
    this.handlerIdentifier,
    this.name,
    required this.distinguishableName,
    this.description,
    this.position,
    this.active = false,
    this.afterOrderEnabled = false,
    this.customFields,
    this.availabilityRuleId,
    this.mediaId,
    this.formattedHandlerIdentifier,
    this.synchronous = false,
    this.asynchronous = false,
    this.prepared = false,
    this.refundable = false,
    this.translated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory PaymentMethod.fromJson(dynamic json) {
    final map = asMap(json);

    return PaymentMethod(
      pluginId: asStringOrNull(map['pluginId']),
      handlerIdentifier: asStringOrNull(map['handlerIdentifier']),
      name: asStringOrNull(map['name']),
      distinguishableName: asString(
        map['distinguishableName'],
        fallback: asString(map['name']),
      ),
      description: asStringOrNull(map['description']),
      position: map['position'] == null ? null : asInt(map['position']),
      active: asBool(map['active']),
      afterOrderEnabled: asBool(map['afterOrderEnabled']),
      customFields: map['customFields'],
      availabilityRuleId: asStringOrNull(map['availabilityRuleId']),
      mediaId: asStringOrNull(map['mediaId']),
      formattedHandlerIdentifier:
      asStringOrNull(map['formattedHandlerIdentifier']),
      synchronous: asBool(map['synchronous']),
      asynchronous: asBool(map['asynchronous']),
      prepared: asBool(map['prepared']),
      refundable: asBool(map['refundable']),
      translated: asMapOrNull(map['translated']) == null
          ? null
          : Translated.fromJson(asMap(map['translated'])),
      createdAt: asDateTimeOrNull(map['createdAt']),
      updatedAt: asDateTimeOrNull(map['updatedAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'pluginId': pluginId,
    'handlerIdentifier': handlerIdentifier,
    'name': name,
    'distinguishableName': distinguishableName,
    'description': description,
    'position': position,
    'active': active,
    'afterOrderEnabled': afterOrderEnabled,
    'customFields': customFields,
    'availabilityRuleId': availabilityRuleId,
    'mediaId': mediaId,
    'formattedHandlerIdentifier': formattedHandlerIdentifier,
    'synchronous': synchronous,
    'asynchronous': asynchronous,
    'prepared': prepared,
    'refundable': refundable,
    'translated': translated?.toJson(),
    ...super.toJson(),
  };

  @override
  String toString() => 'PaymentMethod(${toJson()})';
}
