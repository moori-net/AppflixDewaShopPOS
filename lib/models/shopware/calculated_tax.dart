import 'package:equatable/equatable.dart';

class CalculatedTax extends Equatable {
  final num tax;
  final num taxRate;
  final num price;
  final List extensions;

  const CalculatedTax({
    required this.tax,
    required this.taxRate,
    required this.price,
    this.extensions = const [],
  });

  factory CalculatedTax.fromJson(Map<String, dynamic> json) => CalculatedTax(
        tax: json['tax'],
        taxRate: json['taxRate'],
        price: json['price'],
        extensions: json['extensions'],
      );

  @override
  List<Object?> get props => [tax, taxRate, price, extensions];

  Map<String, dynamic> toJson() => {
        'tax': tax,
        'taxRate': taxRate,
        'price': price,
        'extensions': extensions,
      };

  @override
  String toString() => 'CalculatedTax(${toJson()})';
}
