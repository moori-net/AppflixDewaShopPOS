import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  final int totalCountMode;
  final int total;

  const Meta({
    this.totalCountMode = 0,
    this.total = 0,
  });

  factory Meta.empty() => const Meta();

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalCountMode: json['totalCountMode'],
        total: json['total'],
      );

  @override
  List<Object?> get props => [totalCountMode, total];

  Map<String, dynamic> toJson() => {
        'totalCountMode': totalCountMode,
        'total': total,
      };

  @override
  String toString() => 'Meta(${toJson()})';
}
