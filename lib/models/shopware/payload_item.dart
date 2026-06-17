class PayloadItem {
  final String name;
  final List<dynamic> value;

  PayloadItem({required this.name, this.value = const []});

  factory PayloadItem.fromJson(Map json) => PayloadItem(
      name: json['name'],
      value: json['value'] is List ? json['value'] : [json['value']]);

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };

  @override
  String toString() => 'PayloadItem(${toJson()})';
}
