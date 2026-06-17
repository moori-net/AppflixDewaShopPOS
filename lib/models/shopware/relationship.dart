import 'package:equatable/equatable.dart';

import '/utils/json_util.dart';

import 'data.dart';
import 'links.dart';

class Relationship extends Equatable {
  final String name;
  final List<Data> data;
  final Links? links;

  const Relationship({
    required this.name,
    this.data = const [],
    this.links,
  });

  factory Relationship.fromJson(String name, dynamic json) {
    final map = asMap(json);
    final rawData = map['data'];

    return Relationship(
      name: name,
      data: _parseData(rawData),
      links: Links.fromJson(map['links']),
    );
  }

  static List<Data> _parseData(dynamic value) {
    if (value is List) {
      return value
          .map((item) => asMapOrNull(item))
          .whereType<Map<String, dynamic>>()
          .map((item) => Data.fromJson(item))
          .toList();
    }

    final map = asMapOrNull(value);

    if (map != null) {
      return [
        Data.fromJson(map),
      ];
    }

    return const [];
  }

  @override
  List<Object?> get props => [name, data, links];

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'links': links?.toJson(),
  };

  @override
  String toString() => 'Relationship(${toJson()})';
}
