import 'package:equatable/equatable.dart';

class TaxRule extends Equatable {
  final num? taxRate;
  final num? percentage;
  final List extensions;

  const TaxRule({
    this.taxRate,
    this.percentage,
    this.extensions = const [],
  });

  factory TaxRule.fromJson(Map<String, dynamic> json) => TaxRule(
        taxRate: json['taxRate'],
        percentage: json['percentage'],
        extensions: json['extensions'],
      );

  @override
  List<Object?> get props => [taxRate, percentage, extensions];

  Map<String, dynamic> toJson() => {
        'taxRate': taxRate,
        'percentage': percentage,
        'extensions': extensions,
      };

  @override
  String toString() => 'TaxRule(${toJson()})';
}
