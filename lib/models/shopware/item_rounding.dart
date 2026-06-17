import 'package:equatable/equatable.dart';

class ItemRounding extends Equatable {
  final int decimals;
  final double interval;
  final bool roundForNet;
  final List extensions;

  const ItemRounding({
    required this.decimals,
    required this.interval,
    this.roundForNet = false,
    this.extensions = const [],
  });

  factory ItemRounding.fromJson(Map<String, dynamic> json) => ItemRounding(
        decimals: json['decimals'],
        interval: json['interval'].toDouble(),
        roundForNet: json['roundForNet'],
        extensions: json['extensions'],
      );

  @override
  List<Object?> get props => [decimals, interval, roundForNet, extensions];

  Map<String, dynamic> toJson() => {
        'decimals': decimals,
        'interval': interval,
        'roundForNet': roundForNet,
        'extensions': extensions,
      };

  @override
  String toString() => 'ItemRounding(${toJson()})';
}
