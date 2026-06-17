import 'package:equatable/equatable.dart';

import '/utils/json_util.dart';

class Links extends Equatable {
  final String? self;
  final String? related;

  const Links({
    this.self,
    this.related,
  });

  factory Links.fromJson(dynamic json) {
    final map = asMap(json);

    return Links(
      self: asStringOrNull(map['self']),
      related: asStringOrNull(map['related']),
    );
  }

  @override
  List<Object?> get props => [self, related];

  Map<String, dynamic> toJson() => {
    'self': self,
    'related': related,
  };

  @override
  String toString() => 'Links(${toJson()})';
}
