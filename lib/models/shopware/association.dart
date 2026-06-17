import 'package:equatable/equatable.dart';

import 'filter.dart';

class Association extends Equatable {
  final String name;
  final List<Association> associations;
  final List<Filter> filter;
  final int totalCountMode;

  const Association({
    required this.name,
    this.associations = const [],
    this.filter = const [],
    this.totalCountMode = 1,
  });

  factory Association.fromJson(Map<String, dynamic> map) => Association(
        name: map['name'],
        associations: List<Association>.from(
            map['associations']?.map((x) => Association.fromJson(x))),
        filter:
            List<Filter>.from(map['filter']?.map((x) => Filter.fromJson(x))),
        totalCountMode: map['total-count-mode'],
      );

  @override
  List<Object?> get props => [name, associations, filter, totalCountMode];

  Map<String, dynamic> toJson() => {
        //'name': name,
        if (associations.isNotEmpty)
          'associations': Map.fromEntries(
              associations.map<MapEntry<String, dynamic>>(
                  (e) => MapEntry(e.name, e.toJson()))),
        if (filter.isNotEmpty)
          'filter': List<dynamic>.from(filter.map((x) => x.toJson())),
        'total-count-mode': totalCountMode,
      };
}
