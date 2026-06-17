import 'package:equatable/equatable.dart';

class Aggregation extends Equatable {
  final String name;
  final String type;
  final String field;

  const Aggregation(
      {required this.name, required this.type, required this.field});

  factory Aggregation.fromJson(Map<String, dynamic> json) {
    return Aggregation(
      name: json['name'],
      type: json['type'],
      field: json['field'],
    );
  }

  @override
  List<Object?> get props => [name, type, field];
}
