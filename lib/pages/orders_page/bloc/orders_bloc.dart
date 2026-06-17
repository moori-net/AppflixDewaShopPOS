import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dewa_app/models/shopware/dewa_shop_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

import '/environment_config.dart';
import '/models/full_order.dart';
import '/models/order_category.dart';
import '/models/shopware/attributes/dewa_shop.dart';
import '/models/shopware/attributes/shipping_method.dart';
import '/models/shopware/attributes/state_machine_state.dart';
import '/models/shopware/data.dart';
import '/print_job/bill_print_job.dart';
import '/repositories/deliveryware_repository.dart';
import '/repositories/settings_repo.dart';
import 'orders_event.dart';
import 'orders_state.dart';

export 'orders_state.dart';

class GetShop implements OrdersEvent {}

class GetShopConfig implements OrdersEvent {}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final Logger _log = Logger('OrdersBloc');

  final DeliverywareRepository _repository = GetIt.I<DeliverywareRepository>();
  final SettingsRepository _settings = GetIt.I<SettingsRepository>();

  final player = AudioPlayer();

  final List<FullOrder> orders = [];

  late final Timer _heartbeatTimer;
  late final Timer _refreshTimer;

  final List<OrderCategory> _filter = [];

  bool _startup = true;

  OrdersBloc() : super(OrdersState.initial()) {
    if (shopId == null) {
      _log.info('No shopId found in settings');
      _repository.getShops().then((value) {
        final shop =
            value.where((data) => data.attributes?.isDefault ?? false).first;
        _settings.shopId = shop.id;
      });
    } else {
      _log.info('Found shopId in settings: $shopId');

      _repository.getShops().then((shops) {
        Data<DewaShop>? shop;
        try {
          shop = shops.firstWhere((data) => data.id == shopId);
        } catch (e) {
          _settings.shopId = shops.first.id;
          shop = shops.first;
        }
        if (shop.attributes?.isOpen ?? false) {
          _log.info('Shop is open');
          add(ToggleOpen(
            active: true,
            collectActive: shop.attributes?.collectActive ?? true,
            deliveryActive: shop.attributes?.deliveryActive ?? true,
          ));
          add(GetShop());
        } else {
          _log.info('Shop is closed');
        }
      });
    }

    _heartbeatTimer = Timer.periodic(
        const Duration(seconds: EnvironmentConfig.heartbeatTimer),
        _heartbeatTimerCallback);

    _refreshTimer = Timer.periodic(
        const Duration(seconds: EnvironmentConfig.refreshTimer),
        _refreshTimerCallback);

    // player.setUrl('https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3');
    player.setAsset('assets/audio/ding.mp3');

    on<ToggleOpen>((event, emit) async {
      if (event.active ?? false) {
        emit(state.copyWith(active: event.active));
        await _postShopUpdate();
      }

      if (event.collectActive != null || event.deliveryActive != null) {
        emit(state.copyWith(
          collectActive: event.collectActive ?? state.collectActive,
          deliveryActive: event.deliveryActive ?? state.deliveryActive,
        ));
      }

      await _repository.updateActiveState(
        shopId!,
        active: event.active ?? state.active,
        collectActive: event.collectActive ?? state.collectActive,
        deliveryActive: event.deliveryActive ?? state.deliveryActive,
      );

      add(GetShop());
    });

    on<UpdateFilter>((event, emit) async {
      _filter.clear();
      _filter.addAll(event.filter);
      emit(state.copyWith(orders: filteredOrders));
    });

    on<GetShopConfig>((event, emit) async {
      DewaShopConfig? shopConfig;

      try {
        shopConfig = await _repository.getDewaShopConfig();
      } catch (e) {
        _log.severe(e);
      }

      emit(state.copyWith(loading: false, shopConfig: shopConfig));
    });

    on<GetShop>((event, emit) async {
      DewaShop? shop;
      try {
        shop = await _repository.getDewaShop(shopId!);
      } catch (e) {
        _log.severe(e);

        // get list of shops to search for id
        final list = await _repository.getShops();

        try {
          shop = list.firstWhere((element) => element.id == shopId).attributes;
        } catch (e) {
          _log.severe(e);
          // if no shop by original id is found use first shop in list
          _settings.shopId = list.first.id;
          shop = list.first.attributes;
        }
      }

      emit(state.copyWith(
        isOpen: shop!.isOpen,
        loading: false,
        shop: shop,
        active: shop.active,
        collectActive: shop.collectActive,
        deliveryActive: shop.deliveryActive,
      ));
    });

    on<RefreshOrders>((event, emit) async {
      if (_startup) {
        emit(state.copyWith(loading: true));
        _startup = false;
      }
      if (shopId == null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      final orderWhitelistPaymentMethods =
          state.shopConfig?.orderWhitelistPaymentMethods;

      final result = await _repository.getOrders(shopId!,
          orderWhitelistPaymentMethods: orderWhitelistPaymentMethods);

      orders.clear();
      orders.addAll(result);

      orders.sort((a, b) => b.order!.createdAt!
          .compareTo(a.order!.createdAt!)); // sort by date descending

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    on<ProcessOrder>((event, emit) async {
      final order =
          orders.indexWhere((order) => order.orderId == event.orderId);

      final orderState = await _repository.postProcessOrder(event.orderId);

      orders[order] = orders[order].copyWith(orderState: orderState);

      emit(state.copyWith(loading: false, orders: filteredOrders, error: null));

      onPrintOrder(event.orderId);
    });

    on<PrintOrder>((event, emit) async {
      final order =
          orders.indexWhere((order) => order.orderId == event.orderId);

      printJob() => BillPrintJob(orders[order], state.shop!).print();

      final hasPrinted = await printJob();

      debugPrint('hasPrinted: $hasPrinted');

      if (!hasPrinted) {
        emit(state.copyWith(
            loading: false,
            orders: filteredOrders,
            error: 'Drucker nicht erreichbar, versuche erneut'));
        await Future.delayed(const Duration(seconds: 1)).then((_) async {
          final hasPrintedSecond = await printJob();
          debugPrint('hasPrintedSecond: $hasPrintedSecond');
          if (!hasPrintedSecond) {
            emit(state.copyWith(
                loading: false,
                orders: filteredOrders,
                error:
                    'Drucker nicht erreichbar. Bitte stellen Sie sicher, dass Bluetooth eingeschaltet ist.'));
          }
        });
      }

      emit(state.copyWith(loading: false, orders: filteredOrders, error: null));
    });

    on<SetDeliveryTime>((event, emit) async {
      final order = orders.indexWhere(
          (order) => order.dewaShopOrderId == event.dewaShopOrderId);

      final orderTime = await _repository.updateOrderTime(
          event.dewaShopOrderId, event.minutes);

      orders[order] =
          orders[order].copyWith(desiredTime: orderTime.desiredTime);

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    on<ShipOrder>((event, emit) async {
      final order = orders.indexWhere(
          (order) => order.orderDeliveryId == event.orderDeliveryId);

      final orderDelivery =
          await _repository.postShipOrder(event.orderDeliveryId);

      orders[order] = orders[order].copyWith(deliveryState: orderDelivery);

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    on<PaidOrder>((event, emit) async {
      final order = orders.indexWhere(
          (order) => order.orderTransactionId == event.orderTransactionId);

      final transactionState =
          await _repository.postPaidOrder(event.orderTransactionId);

      orders[order] =
          orders[order].copyWith(transactionState: transactionState);

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    on<CompleteOrder>((event, emit) async {
      final order =
          orders.indexWhere((order) => order.orderId == event.orderId);

      final orderState = await _repository.postCompleteOrder(event.orderId);

      orders[order] = orders[order].copyWith(orderState: orderState);

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    on<CancelOrder>((event, emit) async {
      final order =
          orders.indexWhere((order) => order.orderId == event.orderId);

      final orderState = await _repository.postCancelOrder(event.orderId);

      orders[order] = orders[order].copyWith(orderState: orderState);

      emit(state.copyWith(loading: false, orders: filteredOrders));
    });

    onGetShopConfig();
    onGetShop();
    onRefresh();
  }

  List<FullOrder> get filteredOrders {
    if (_filter.isEmpty) {
      return orders;
    }

    final List<FullOrder> filtered = [];

    for (final order in orders) {
      if (!_filter.contains(OrderCategory.order) &&
          order.orderState!.state == OrderState.open) {
        filtered.add(order);
      } else if (!_filter.contains(OrderCategory.preparation) &&
          order.orderState!.state == OrderState.inProgress &&
          order.deliveryState!.state == OrderState.open) {
        filtered.add(order);
      } else if (!_filter.contains(OrderCategory.delivery) &&
          order.deliveryState!.state == OrderState.shipped &&
          order.shippingMethod!.type == ShippingMethodType.delivery) {
        filtered.add(order);
      } else if (!_filter.contains(OrderCategory.takeaway) &&
          order.deliveryState!.state == OrderState.shipped &&
          order.shippingMethod!.type == ShippingMethodType.pickup) {
        filtered.add(order);
      }
    }

    return filtered;
  }

  String? get shopId => _settings.shopId;

  @override
  Future<void> close() {
    _heartbeatTimer.cancel();
    _refreshTimer.cancel();
    return super.close();
  }

  void onCancelOrder(String orderId) => add(CancelOrder(orderId));

  void onCompleteOrder(String orderId) => add(CompleteOrder(orderId));

  @override
  void onEvent(OrdersEvent event) {
    _log.fine('event: $event');
    super.onEvent(event);
  }

  void onGetShop() => add(GetShop());

  void onGetShopConfig() => add(GetShopConfig());

  void onPaidOrder(String orderTransactionId) =>
      add(PaidOrder(orderTransactionId));

  void onProcessOrder(String orderId) => add(ProcessOrder(orderId));

  void onPrintOrder(String orderId) => add(PrintOrder(orderId));

  void onRefresh() => add(RefreshOrders());

  void onSetDeliveryTime(String dewaShopOrderId, int minutes) =>
      add(SetDeliveryTime(dewaShopOrderId, minutes));

  void onShipOrder(String orderDeliveryId) => add(ShipOrder(orderDeliveryId));

  void onToggleOpen(
          {bool? active, bool? collectActive, bool? deliveryActive}) =>
      add(ToggleOpen(
          active: active,
          collectActive: collectActive,
          deliveryActive: deliveryActive));

  @override
  void onTransition(Transition<OrdersEvent, OrdersState> transition) {
    ///_log.fine('state: ${transition.nextState}');
    super.onTransition(transition);
  }

  void onUpdateFilter(List<OrderCategory> filter) => add(UpdateFilter(filter));

  bool _hasOpenOrders() =>
      orders.any((element) => element.orderState!.state == OrderState.open);

  Future<void> _playSound() async {
    try {
      if (player.playing) {
        await player.seek(const Duration(seconds: 0));
      } else {
        await player.play();
      }
    } catch (e) {
      _log.severe('could not play audio file\n $e');
    }
  }

  Future<void> _postShopUpdate() async {
    try {
      await _repository.postShopUpdate(shopId!);
    } catch (e) {
      _log.severe('Failed to post shop update $e');
    }
  }

  void _refreshTimerCallback(Timer timer) async {
    _log.fine('Refresh Timer callback: updating orders');

    final ordersLength = orders
        .where((element) => element.orderState!.state == OrderState.open)
        .length;

    StreamSubscription? listener;
    listener = stream.listen((OrdersState state) async {
      if (state.orders.isNotEmpty &&
          ordersLength <
              state.orders
                  .where(
                      (element) => element.orderState!.state == OrderState.open)
                  .length) {
        return _playSound().then(
          (value) => listener!.cancel(),
        );
      }
    });

    onRefresh();
    onGetShop();
  }

  void _heartbeatTimerCallback(Timer timer) async {
    if (!state.active) {
      _log.fine('Heartbeat Timer callback: shop is closed');
      return;
    }

    _log.fine('Heartbeat Timer callback: shop is open, sending update...');
    await _postShopUpdate();

    _log.fine('checking for open orders');
    if (_hasOpenOrders()) {
      _log.fine('open orders found, playing sound');
      await _playSound();
    }

    onGetShopConfig();
  }
}
