import '/models/order_category.dart';

class CancelOrder implements OrdersEvent {
  final String orderId;

  CancelOrder(this.orderId);

  @override
  String toString() => 'CancelOrder(orderId: $orderId)';
}

class CompleteOrder implements OrdersEvent {
  final String orderId;

  CompleteOrder(this.orderId);

  @override
  String toString() => 'CompleteOrder(orderId: $orderId)';
}

abstract class OrdersEvent {}

class PaidOrder implements OrdersEvent {
  final String orderTransactionId;

  PaidOrder(this.orderTransactionId);

  @override
  String toString() => 'PaidOrder(orderTransactionId: $orderTransactionId)';
}

class ProcessOrder implements OrdersEvent {
  final String orderId;

  ProcessOrder(this.orderId);

  @override
  String toString() => 'ProcessOrder(orderId: $orderId)';
}

class PrintOrder implements OrdersEvent {
  final String orderId;

  PrintOrder(this.orderId);
}

class RefreshOrders implements OrdersEvent {}

class SetDeliveryTime implements OrdersEvent {
  final String dewaShopOrderId;
  final int minutes;

  SetDeliveryTime(this.dewaShopOrderId, this.minutes);

  @override
  String toString() =>
      'SetDeliveryTime(dewaShopOrderId: $dewaShopOrderId, minutes: $minutes)';
}

class ShipOrder implements OrdersEvent {
  final String orderDeliveryId;

  ShipOrder(this.orderDeliveryId);

  @override
  String toString() => 'ShipOrder(orderDeliveryId: $orderDeliveryId)';
}

class ToggleOpen implements OrdersEvent {
  final bool? active;
  final bool? collectActive;
  final bool? deliveryActive;

  ToggleOpen({this.active, this.collectActive, this.deliveryActive});

  @override
  String toString() =>
      'ToggleOpen(active: $active, collectActive: $collectActive, deliveryActive: $deliveryActive)';
}

class UpdateFilter implements OrdersEvent {
  final List<OrderCategory> filter;

  UpdateFilter(this.filter);

  @override
  String toString() => 'UpdateFilter(filter: $filter)';
}
