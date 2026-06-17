import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  final String type;
  final String? field;
  final String? value;
  final List<Filter>? queries;
  final String? operator;
  final Map? parameters;

  Filter({
    this.type = 'equalsAny',
    this.field,
    this.value,
    this.queries,
    this.operator,
    this.parameters,
  }) {
    assert(type != null);
  }

  factory Filter.fromJson(Map<String, dynamic> map) => Filter(
        type: map['type'],
        field: map['field'],
        value: map['value'],
        queries: map['queries'],
        operator: map['operator'],
        parameters: map['parameters'],
      );

  @override
  List<Object?> get props => [type, field, value, parameters, queries, operator];

  Map<String, dynamic> toJson() => {
        'type': type,
        if (field != null) 'field': field,
        if (value != null) 'value': value,
        if (queries != null) 'queries': queries,
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
