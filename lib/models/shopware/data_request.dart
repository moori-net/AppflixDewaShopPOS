import 'association.dart';

class DataRequest {
  final String? ids;
  final int page;
  final int limit;
  final List<Association> associations;
  final int totalCountMode;

  DataRequest({
    this.ids,
    this.page = 1,
    this.limit = 25,
    this.associations = const [],
    this.totalCountMode = 1,
  });

  factory DataRequest.fromJson(Map<String, dynamic> map) => DataRequest(
        ids: map['ids'],
        page: map['page'],
        limit: map['limit'],
        associations: List<Association>.from(
            map['associations']?.map((x) => Association.fromJson(x))),
        totalCountMode: map['total-count-mode'],
      );

  Map<String, dynamic> toJson() => {
        if (ids != null) 'ids': ids,
        'page': page,
        'limit': limit,
        'associations': Map.fromEntries(
            associations.map<MapEntry<String, dynamic>>(
                (e) => MapEntry(e.name, e.toJson()))),
        'total-count-mode': totalCountMode,
      };

  @override
  String toString() => 'DataRequest(${toJson()})';
}
