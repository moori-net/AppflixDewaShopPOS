import 'package:dewa_app/models/shopware/dewa_shop_config.dart';

import '/models/shopware/attributes/dewa_shop.dart';
import '/models/full_order.dart';

class OrdersState {
  final bool isOpen;
  final bool active;
  final bool collectActive;
  final bool deliveryActive;

  final List<FullOrder> orders;
  final DewaShop? shop;
  final DewaShopConfig? shopConfig;

  final bool loading;
  final String? error;

  const OrdersState({
    this.isOpen = false,
    this.active = false,
    this.collectActive = false,
    this.deliveryActive = false,
    this.orders = const [],
    this.shop,
    this.shopConfig,
    this.loading = false,
    this.error,
  });

  factory OrdersState.initial() => const OrdersState();

  OrdersState copyWith(
          {bool? isOpen,
          bool? active,
          bool? collectActive,
          bool? deliveryActive,
          List<FullOrder>? orders,
          DewaShop? shop,
          DewaShopConfig? shopConfig,
          bool? loading,
          String? error}) =>
      OrdersState(
        isOpen: isOpen ?? this.isOpen,
        active: active ?? this.active,
        collectActive: collectActive ?? this.collectActive,
        deliveryActive: deliveryActive ?? this.deliveryActive,
        orders: orders ?? this.orders,
        shop: shop ?? this.shop,
        shopConfig: shopConfig ?? this.shopConfig,
        loading: loading ?? this.loading,
        error: error,
      );

  Map<String, dynamic> toJson() => {
        'isOpen': isOpen,
        'active': active,
        'collectActive': collectActive,
        'deliveryActive': deliveryActive,
        'orders': orders,
        'shop': shop?.toJson(),
        'shopConfig': shopConfig?.toJson(),
        'loading': loading,
        'error': error,
      };

  @override
  String toString() => 'OrdersState ${toJson()}';
}
