import 'package:equatable/equatable.dart';

/// TODO: use enum instead of string for sort type
enum Order {
  asc,
  desc,
}

class Sort extends Equatable {
  final String field;
  final bool naturalSorting;
  final String? order;

  const Sort({
    required this.field,
    this.naturalSorting = false,
    this.order = 'ASC',
  });

  factory Sort.fromJson(Map<String, dynamic> map) => Sort(
        field: map['field'],
        naturalSorting: map['naturalSorting'],
        order: map['order'],
      );

  @override
  List<Object?> get props => [field, naturalSorting, order];

  Map<String, dynamic> toJson() => {
        'field': field,
        'naturalSorting': naturalSorting,
        'order': order,
      };

  @override
  String toString() => 'Sort(${toJson()})';
}
