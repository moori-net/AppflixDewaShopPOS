class TimeInterval {
  final String? from;
  final String? until;

  TimeInterval({
    this.from,
    this.until,
  });

  factory TimeInterval.fromJson(Map<String, dynamic> map) => TimeInterval(
        from: map['from'],
        until: map['until'],
      );

  Map<String, dynamic> toJson() => {
        'from': from,
        'until': until,
      };

  @override
  String toString() => 'TimeInterval(${toJson()})';
}
