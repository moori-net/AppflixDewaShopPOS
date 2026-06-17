import 'calculated_tax.dart';
import 'tax_rule.dart';

class Amount {
  final num unitPrice;
  final int quantity;
  final num totalPrice;
  final List<CalculatedTax> calculatedTaxes;
  final List<TaxRule> taxRules;
  final num? referencePrice;
  final num? listPrice;
  final num? regulationPrice;
  final List<dynamic> extensions;

  Amount({
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.calculatedTaxes = const [],
    this.taxRules = const [],
    this.referencePrice,
    this.listPrice,
    this.regulationPrice,
    this.extensions = const [],
  });

  factory Amount.fromJson(Map json) => Amount(
        unitPrice: json['unitPrice'],
        quantity: json['quantity'],
        totalPrice: json['totalPrice'],
        calculatedTaxes: List<CalculatedTax>.from(
            json['calculatedTaxes'].map((e) => CalculatedTax.fromJson(e))),
        taxRules: List<TaxRule>.from(
            json['calculatedTaxes'].map((e) => TaxRule.fromJson(e))),
        referencePrice: json['referencePrice'] as num?,
        listPrice: json['listPrice'] as num?,
        regulationPrice: json['regulationPrice'] as num?,
        extensions: json['extensions'] as List? ?? [],
      );

  Map<String, dynamic> toJson() => {
        'unitPrice': unitPrice,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'calculatedTaxes': calculatedTaxes.map((e) => e.toJson()),
        'taxRules': taxRules.map((e) => e.toJson()),
        'referencePrice': referencePrice,
        'listPrice': listPrice,
        'regulationPrice': regulationPrice,
        'extensions': extensions,
      };

  @override
  String toString() => 'Amount(${toJson()})';
}
