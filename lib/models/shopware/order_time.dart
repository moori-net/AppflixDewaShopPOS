import 'desired_time.dart';

class OrderTime {
  final String id;
  final DesiredTime desiredTime;

  OrderTime({
    required this.id,
    required this.desiredTime,
  });

  factory OrderTime.fromJson(Map<String, dynamic> json) => OrderTime(
        id: json['id'],
        desiredTime: DesiredTime.fromJson(json['desiredTime']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'desiredTime': desiredTime.toJson(),
      };

  @override
  String toString() => 'OrderTime(${toJson()})';
}
