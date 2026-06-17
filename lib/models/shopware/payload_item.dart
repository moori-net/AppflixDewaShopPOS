import '/utils/json_util.dart';

class PayloadItem {
  final String name;
  final List<dynamic> value;

  PayloadItem({
    required this.name,
    this.value = const [],
  });

  factory PayloadItem.fromJson(dynamic json) {
    final map = asMap(json);
    final rawValue = map['value'];

    return PayloadItem(
      name: asString(map['name'], fallback: 'Unbekannt'),
      value: rawValue is List
          ? rawValue
          : rawValue == null
          ? const []
          : [rawValue],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'value': value,
  };

  @override
  String toString() => 'PayloadItem(${toJson()})';
}
