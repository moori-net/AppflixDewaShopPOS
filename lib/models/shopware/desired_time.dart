class DesiredTime {
  final DateTime date;
  final String timezone;
  final int timezoneType;

  DesiredTime({
    required this.date,
    this.timezone = 'UTC',
    required this.timezoneType,
  });

  factory DesiredTime.fromJson(Map<String, dynamic> json) => DesiredTime(
        date: DateTime.parse(
            json['timezone'] == 'UTC' ? '${json['date']}Z' : json['date']),
        timezone: json['timezone'],
        timezoneType: json['timezone_type'],
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'timezone': timezone,
        'timezone_type': timezoneType,
      };

  @override
  String toString() => 'DesiredTime(${toJson()})';
}
