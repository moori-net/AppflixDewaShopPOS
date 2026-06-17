import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  final String type;
  final String? field;
  final String? value;
  final List<Filter>? queries;
  final String? operator;
  final Map<String, dynamic>? parameters;

  const Filter({
    this.type = 'equalsAny',
    this.field,
    this.value,
    this.queries,
    this.operator,
    this.parameters,
  });

  factory Filter.fromJson(Map<String, dynamic> map) => Filter(
    type: map['type'] as String? ?? 'equalsAny',
    field: map['field'] as String?,
    value: map['value']?.toString(),
    queries: (map['queries'] as List<dynamic>?)
        ?.map((query) => Filter.fromJson(query as Map<String, dynamic>))
        .toList(),
    operator: map['operator'] as String?,
    parameters: map['parameters'] as Map<String, dynamic>?,
  );

  @override
  List<Object?> get props => [
    type,
    field,
    value,
    parameters,
    queries,
    operator,
  ];

  Map<String, dynamic> toJson() => {
    'type': type,
    if (field != null) 'field': field,
    if (value != null) 'value': value,
    if (queries != null)
      'queries': queries!.map((query) => query.toJson()).toList(),
    if (parameters != null) 'parameters': parameters,
    if (operator != null) 'operator': operator,
  };

  @override
  String toString() => 'Filter(${toJson()})';
}

/// TODO: use enum for filter type
enum FilterType {
  equals,
  equalsAny,
  range,
  multi,
}

enum FilterOperator {
  or,
  and,
}
