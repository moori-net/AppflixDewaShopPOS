import 'time_interval.dart';

class Hours {
  final String? day;
  final String? info;
  final List<TimeInterval> times;

  Hours({
    this.day,
    this.info,
    this.times = const [],
  });

  factory Hours.fromJson(Map<String, dynamic> map) => Hours(
        day: map['day'],
        info: map['info'],
        times: List<TimeInterval>.from(
            map['times']?.map((x) => TimeInterval.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'day': day,
        if (info != null) 'info': info,
        'times': List<dynamic>.from(times.map((x) => x.toJson())),
      };

  @override
  String toString() => 'Hours(${toJson()})';
}
