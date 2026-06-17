import 'shopware/attributes/dewa_shop_order.dart';
import 'shopware/attributes/order.dart';
import 'shopware/attributes/order_address.dart';
import 'shopware/attributes/order_customer.dart';
import 'shopware/attributes/order_delivery.dart';
import 'shopware/attributes/order_line_item.dart';
import 'shopware/attributes/order_transaction.dart';
import 'shopware/attributes/payment_method.dart';
import 'shopware/attributes/shipping_method.dart';
import 'shopware/attributes/state_machine_state.dart';
import 'shopware/desired_time.dart';

class FullOrder {
  DewaShopOrder? dewaShopOrder;
  Order? order;
  OrderCustomer? orderCustomer;
  OrderAddress? orderAddress;
  OrderTransaction? orderTransaction;
  OrderDelivery? orderDelivery;
  PaymentMethod? paymentMethod;
  ShippingMethod? shippingMethod;
  List<OrderLineItem> orderLineItems;
  StateMachineState? orderState;
  StateMachineState? deliveryState;
  StateMachineState? transactionState;

  String dewaShopOrderId;
  String orderId;
  String orderDeliveryId;
  String orderTransactionId;

  DesiredTime? desiredTime;

  FullOrder({
    this.dewaShopOrder,
    this.order,
    this.orderCustomer,
    this.orderAddress,
    this.orderTransaction,
    this.paymentMethod,
    this.orderDelivery,
    this.shippingMethod,
    this.orderLineItems = const [],
    this.orderState,
    this.deliveryState,
    this.transactionState,
    required this.dewaShopOrderId,
    required this.orderId,
    required this.orderDeliveryId,
    required this.orderTransactionId,
    this.desiredTime,
  });

  FullOrder copyWith({
    DewaShopOrder? dewaShopOrder,
    Order? order,
    OrderCustomer? orderCustomer,
    OrderAddress? orderAddress,
    OrderTransaction? orderTransaction,
    OrderDelivery? orderDelivery,
    PaymentMethod? paymentMethod,
    ShippingMethod? shippingMethod,
    List<OrderLineItem>? orderLineItems,
    StateMachineState? orderState,
    StateMachineState? deliveryState,
    StateMachineState? transactionState,
    String? dewaShopOrderId,
    String? orderId,
    DesiredTime? desiredTime,
    String? orderDeliveryId,
    String? orderTransactionId,
  }) =>
      FullOrder(
        dewaShopOrder: dewaShopOrder ?? this.dewaShopOrder,
        order: order ?? this.order,
        orderCustomer: orderCustomer ?? this.orderCustomer,
        orderAddress: orderAddress ?? this.orderAddress,
        orderTransaction: orderTransaction ?? this.orderTransaction,
        orderDelivery: orderDelivery ?? this.orderDelivery,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        shippingMethod: shippingMethod ?? this.shippingMethod,
        orderLineItems: orderLineItems ?? this.orderLineItems,
        orderState: orderState ?? this.orderState,
        deliveryState: deliveryState ?? this.deliveryState,
        transactionState: transactionState ?? this.transactionState,
        dewaShopOrderId: dewaShopOrderId ?? this.dewaShopOrderId,
        orderId: orderId ?? this.orderId,
        desiredTime: desiredTime ?? this.desiredTime,
        orderDeliveryId: orderDeliveryId ?? this.orderDeliveryId,
        orderTransactionId: orderTransactionId ?? this.orderTransactionId,
      );

  Map<String, dynamic> toJson() => {
        'dewaShopOrder': dewaShopOrder?.toJson(),
        'order': order?.toJson(),
        'orderCustomer': orderCustomer?.toJson(),
        'orderAddress': orderAddress?.toJson(),
        'orderDelivery': orderDelivery?.toJson(),
        'orderTransaction': orderTransaction?.toJson(),
        'paymentMethod': paymentMethod?.toJson(),
        'shippingMethod': shippingMethod?.toJson(),
        'orderLineItems': orderLineItems.map((e) => e.toJson()).toList(),
        'orderState': orderState?.toJson(),
        'deliveryState': deliveryState?.toJson(),
        'transactionState': transactionState?.toJson(),
        'dewaShopOrderId': dewaShopOrderId,
        'orderId': orderId,
        'orderDeliveryId': orderDeliveryId,
        'orderTransactionId': orderTransactionId,
        'desiredTime': desiredTime?.toJson(),
      };

  @override
  String toString() => 'FullOrder(${toJson()})';

  String? get phoneNumber {
    return orderCustomer!.phoneNumber ?? orderAddress!.phoneNumber;
  }
}
