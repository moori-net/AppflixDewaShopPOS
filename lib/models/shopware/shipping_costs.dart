import 'package:equatable/equatable.dart';

import 'calculated_tax.dart';
import 'tax_rule.dart';

class ShippingCosts extends Equatable {
  final List<CalculatedTax> calculatedTaxes;
  final List extensions;
  final num? listPrice;
  final int quantity;
  final num? referencePrice;
  final num? regulationPrice;
  final List<TaxRule> taxRules;
  final num totalPrice;
  final num unitPrice;

  const ShippingCosts({
    this.calculatedTaxes = const [],
    this.extensions = const [],
    this.listPrice,
    this.quantity = 1,
    this.referencePrice,
    this.regulationPrice,
    this.taxRules = const [],
    required this.totalPrice,
    required this.unitPrice,
  });

  factory ShippingCosts.fromJson(Map<String, dynamic> json) => ShippingCosts(
        calculatedTaxes: List<CalculatedTax>.from(
            json['calculatedTaxes'].map((x) => CalculatedTax.fromJson(x))),
        extensions: List<dynamic>.from(json['extensions'].map((x) => x)),
        listPrice: json['listPrice'],
        quantity: json['quantity'],
        referencePrice: json['referencePrice'],
        regulationPrice: json['regulationPrice'],
        taxRules: List<TaxRule>.from(
            json['taxRules'].map((x) => TaxRule.fromJson(x))),
        totalPrice: json['totalPrice'],
        unitPrice: json['unitPrice'],
      );

  @override
  List<Object?> get props => [
        calculatedTaxes,
        extensions,
        listPrice,
        quantity,
        referencePrice,
        regulationPrice,
        taxRules,
        totalPrice,
        unitPrice,
      ];

  Map<String, dynamic> toJson() => {
        'calculatedTaxes': calculatedTaxes.map((e) => e.toJson()).toList(),
        'extensions': extensions,
        'listPrice': listPrice,
        'quantity': quantity,
        'referencePrice': referencePrice,
        'regulationPrice': regulationPrice,
        'taxRules': taxRules.map((e) => e.toJson()).toList(),
        'totalPrice': totalPrice,
        'unitPrice': unitPrice,
      };
}
