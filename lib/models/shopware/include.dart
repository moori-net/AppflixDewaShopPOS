import 'package:equatable/equatable.dart';

import '/utils/json_util.dart';

import 'attributes/attributes.dart';
import 'links.dart';
import 'meta.dart';
import 'relationship.dart';

class Include<T extends Attributes> extends Equatable {
  final String id;
  final String type;
  final T? attributes;
  final Links links;
  final List<Relationship> relationships;
  final Meta? meta;

  const Include({
    required this.type,
    required this.id,
    required this.attributes,
    required this.links,
    this.relationships = const [],
    this.meta,
  });

  factory Include.fromJson(Map<String, dynamic> json) {
    final type = asString(json['type']);

    return Include(
      type: type,
      id: asString(json['id']),
      attributes: asMapOrNull(json['attributes']) == null
          ? null
          : Attributes.fromJson(
        type,
        asMap(json['attributes']),
      ) as T,
      links: Links.fromJson(json['links']),
      relationships: asMap(json['relationships'])
          .entries
          .map((e) => Relationship.fromJson(e.key, e.value))
          .toList(),
      meta: asMapOrNull(json['meta']) == null
          ? null
          : Meta.fromJson(json['meta']),
    );
  }

  @override
  List<Object?> get props => [type, id, attributes];

  Include<R> copyWith<R extends Attributes>({
    String? id,
    Meta? meta,
    String? type,
    R? attributes,
    Links? links,
    List<Relationship>? relationships,
  }) =>
      Include(
        id: id ?? this.id,
        meta: meta ?? this.meta,
        type: type ?? this.type,
        attributes: attributes ?? this.attributes as R,
        links: links ?? this.links,
        relationships: relationships ?? this.relationships,
      );

  Map<String, dynamic> toJson() => {
    'type': type,
    'id': id,
    'attributes': attributes?.toJson(),
    'links': links.toJson(),
    'relationships': Map.fromEntries(
      relationships.map<MapEntry<String, dynamic>>(
            (e) => MapEntry(e.name, e.toJson()),
      ),
    ),
    'meta': meta?.toJson(),
  };
}
