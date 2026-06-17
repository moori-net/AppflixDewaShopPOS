import 'currency.dart';
import 'delivery_time.dart';
import 'dewa_deliverer.dart';
import 'dewa_printer.dart';
import 'dewa_shop.dart';
import 'dewa_shop_order.dart';
import 'order.dart';
import 'order_address.dart';
import 'order_customer.dart';
import 'order_delivery.dart';
import 'order_line_item.dart';
import 'order_transaction.dart';
import 'payment_method.dart';
import 'sales_channel.dart';
import 'shipping_method.dart';
import 'state_machine_state.dart';

class Attributes {
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Map<String, dynamic> rawJson;

  const Attributes(
      {required this.createdAt,
      this.updatedAt,
      this.rawJson = const {}});

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => 'Attributes(${toJson()}';

  static Attributes fromJson(String type, Map<String, dynamic> json) {
    switch (type) {
      case 'order':
        return Order.fromJson(json);
      case 'dewa_shop_order':
        return DewaShopOrder.fromJson(json);
      case 'delivery_time':
        return DeliveryTime.fromJson(json);
      case 'dewa_deliverer':
        return DewaDeliverer.fromJson(json);
      case 'dewa_printer':
        return DewaPrinter.fromJson(json);
      case 'state_machine_state':
        return StateMachineState.fromJson(json);
      case 'currency':
        return Currency.fromJson(json);
      case 'order_address':
        return OrderAddress.fromJson(json);
      case 'shipping_method':
        return ShippingMethod.fromJson(json);
      case 'dewa_shop':
        return DewaShop.fromJson(json);
      case 'order_customer':
        return OrderCustomer.fromJson(json);
      case 'payment_method':
        return PaymentMethod.fromJson(json);
      case 'order_delivery':
        return OrderDelivery.fromJson(json);
      case 'order_transaction':
        return OrderTransaction.fromJson(json);
      case 'order_line_item':
        return OrderLineItem.fromJson(json);
      case 'sales_channel':
        return SalesChannel.fromJson(json);
      default:
        return Attributes(
          createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
          updatedAt: json['updatedAt'] == null
              ? null
              : DateTime.tryParse(json['updatedAt'] ?? ''),
          rawJson: json,
        );
    }
  }
}
