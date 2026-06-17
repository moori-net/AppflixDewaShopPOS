import '/utils/json_util.dart';

import 'attributes/attributes.dart';
import 'links.dart';
import 'meta.dart';
import 'relationship.dart';

class Data<T extends Attributes> {
  final String id;
  final Meta? meta;
  final String type;
  final T? attributes;
  final Links? links;
  final List<Relationship> relationships;

  Data({
    required this.id,
    this.meta,
    required this.type,
    this.attributes,
    this.links,
    this.relationships = const [],
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final type = asString(json['type']);

    return Data(
      id: asString(json['id']),
      meta: asMapOrNull(json['meta']) == null
          ? null
          : Meta.fromJson(json['meta']),
      type: type,
      attributes: asMapOrNull(json['attributes']) == null
          ? null
          : Attributes.fromJson(
        type,
        asMap(json['attributes']),
      ) as T,
      links: asMapOrNull(json['links']) == null
          ? null
          : Links.fromJson(json['links']),
      relationships: asMap(json['relationships'])
          .entries
          .map((e) => Relationship.fromJson(e.key, e.value))
          .toList(),
    );
  }

  Data<R> copyWith<R extends Attributes>({
    String? id,
    Meta? meta,
    String? type,
    R? attributes,
    Links? links,
    List<Relationship>? relationships,
  }) =>
      Data(
        id: id ?? this.id,
        meta: meta ?? this.meta,
        type: type ?? this.type,
        attributes: attributes ?? this.attributes as R,
        links: links ?? this.links,
        relationships: relationships ?? this.relationships,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'meta': meta?.toJson(),
    'type': type,
    'attributes': attributes?.toJson(),
    'links': links?.toJson(),
    'relationships': Map.fromEntries(
      relationships.map<MapEntry<String, dynamic>>(
            (e) => MapEntry(e.name, e.toJson()),
      ),
    ),
  };

  @override
  String toString() => 'Data(${toJson()})';
}
