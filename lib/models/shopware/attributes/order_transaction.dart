import '../amount.dart';
import 'attributes.dart';

class OrderTransaction extends Attributes {
  final String? versionId;
  final String orderId;
  final String? orderVersionId;
  final String? paymentMethodId;
  final Amount? amount;
  final String? stateId;

  OrderTransaction({
    this.versionId,
    required this.orderId,
    this.orderVersionId,
    this.paymentMethodId,
    this.amount,
    this.stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory OrderTransaction.fromJson(Map json) => OrderTransaction(
        versionId: json['versionId'],
        orderId: json['orderId'],
        orderVersionId: json['orderVersionId'],
        paymentMethodId: json['paymentMethodId'],
        amount: json['amount'] != null ? Amount.fromJson(json['amount']) : null,
        stateId: json['stateId'],
        createdAt: DateTime.parse(json['createdAt'] ?? ''),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      );

  @override
  Map<String, dynamic> toJson() => {
        'versionId': versionId,
        'orderId': orderId,
        'orderVersionId': orderVersionId,
        'paymentMethodId': paymentMethodId,
        'amount': amount?.toJson(),
        'stateId': stateId,
        ...super.toJson(),
      };
}
