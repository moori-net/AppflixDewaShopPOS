import '../translated.dart';
import 'attributes.dart';

enum OrderState {
  open,
  inProgress,
  shipped,
  paid,
  completed,
  cancelled,
  unconfirmed,
}

class StateMachineState extends Attributes {
  final String technicalName;
  final String? name;
  final String stateMachineId;
  final dynamic customFields;
  final Translated? translated;

  const StateMachineState({
    required this.technicalName,
    this.name,
    required this.stateMachineId,
    this.customFields,
    this.translated,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory StateMachineState.fromJson(Map<String, dynamic> json) =>
      StateMachineState(
        technicalName: json['technicalName'],
        name: json['name'],
        stateMachineId: json['stateMachineId'],
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

  OrderState get state => _getState(technicalName);

  @override
  Map<String, dynamic> toJson() => {
        'technicalName': technicalName,
        'name': name,
        'stateMachineId': stateMachineId,
        'customFields': customFields,
        'translated': translated?.toJson(),
        ...super.toJson(),
      };

  @override
  String toString() => 'StateMachineState(${toJson()}';

  static OrderState _getState(String technicalName) {
    switch (technicalName) {
      case 'open':
        return OrderState.open;
      case 'in_progress':
        return OrderState.inProgress;
      case 'shipped':
        return OrderState.shipped;
      case 'paid':
        return OrderState.paid;
      case 'completed':
        return OrderState.completed;
      case 'cancelled':
        return OrderState.cancelled;
      case 'unconfirmed':
        return OrderState.unconfirmed;
      default:
        throw Exception('Unknown state: $technicalName');
    }
  }
}
