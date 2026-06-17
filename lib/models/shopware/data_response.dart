import '/utils/json_util.dart';

import 'data.dart';
import 'include.dart';
import 'links.dart';
import 'meta.dart';

class DataResponse {
  final List<Data> data;
  final List<Include> included;
  final Links links;
  final Meta meta;
  final List<String> aggregations;

  DataResponse({
    required this.data,
    required this.included,
    required this.links,
    required this.meta,
    required this.aggregations,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
    data: asTypedList(
      json['data'],
          (item) => Data.fromJson(asMap(item)),
    ),
    included: asTypedList(
      json['included'],
          (item) => Include.fromJson(asMap(item)),
    ),
    links: Links.fromJson(json['links']),
    meta: Meta.fromJson(json['meta']),
    aggregations: _parseAggregations(json['aggregations']),
  );

  static List<String> _parseAggregations(dynamic value) {
    if (value is List) {
      return value.map((x) => x.toString()).toList();
    }

    if (value is Map) {
      return value.keys.map((x) => x.toString()).toList();
    }

    return <String>[];
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'included': included.map((e) => e.toJson()).toList(),
    'links': links.toJson(),
    'meta': meta.toJson(),
    'aggregations': List<dynamic>.from(aggregations.map((x) => x)),
  };

  @override
  String toString() => 'DataResponse(${toJson()})';
}
