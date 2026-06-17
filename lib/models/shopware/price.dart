import 'package:equatable/equatable.dart';

import 'calculated_tax.dart';
import 'tax_rule.dart';

class Price extends Equatable {
  final List<CalculatedTax> calculatedTaxes;
  final List extensions;
  final num? netPrice;
  final num? positionPrice;
  final num? rawTotal;
  final List<TaxRule> taxRules;
  final String? taxStatus;
  final num totalPrice;

  const Price({
    this.calculatedTaxes = const [],
    this.extensions = const [],
    this.netPrice,
    this.positionPrice,
    this.rawTotal,
    required this.taxRules,
    this.taxStatus,
    required this.totalPrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        calculatedTaxes: List<CalculatedTax>.from(
            json['calculatedTaxes'].map((x) => CalculatedTax.fromJson(x))),
        extensions: List<dynamic>.from(json['extensions'].map((x) => x)),
        netPrice: json['netPrice'] as num?,
        positionPrice: json['positionPrice'] as num?,
        rawTotal: json['rawTotal'] as num?,
        taxRules: List<TaxRule>.from(
            json['taxRules'].map((x) => TaxRule.fromJson(x))),
        taxStatus: json['taxStatus'] as String?,
        totalPrice: json['totalPrice'],
      );

  @override
  List<Object?> get props => [
        calculatedTaxes,
        extensions,
        netPrice,
        positionPrice,
        rawTotal,
        taxRules,
        taxStatus,
        totalPrice,
      ];

  Map<String, dynamic> toJson() => {
        'calculatedTaxes': calculatedTaxes.map((e) => e.toJson()).toList(),
        'extensions': extensions,
        'netPrice': netPrice,
        'positionPrice': positionPrice,
        'rawTotal': rawTotal,
        'taxRules': taxRules.map((e) => e.toJson()).toList(),
        'taxStatus': taxStatus,
        'totalPrice': totalPrice,
      };
}
