import 'package:bloc/bloc.dart';
import 'package:dewa_app/print_job/interval_print_job.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

import '/models/full_order.dart';
import '/models/shopware/attributes/dewa_shop.dart';
import '/print_job/bill_print_job.dart';
import '/repositories/deliveryware_repository.dart';
import '/repositories/settings_repo.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final Logger _log = Logger('OrderHistoryBloc');

  final DeliverywareRepository _repository = GetIt.I<DeliverywareRepository>();
  final SettingsRepository _settings = GetIt.I<SettingsRepository>();

  OrderHistoryBloc() : super(OrderHistoryState.initial()) {
    if (shopId == null) {
      _log.info('No shopId found in settings');
      _repository.getShops().then((value) {
        final shop = value.firstWhere(
              (data) => data.attributes?.isDefault ?? false,
        );
        _settings.shopId = shop.id;
      });
    }

    on<RefreshOrderHistory>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      if (shopId == null) {
        await Future.delayed(const Duration(seconds: 5));
      }

      final orders = await _repository.getOrders(
        shopId!,
        showCompletedOnly: true,
        startDate: state.startDate,
        endDate: state.endDate,
      );

      orders.sort(
            (a, b) => b.order!.orderDateTime.compareTo(a.order!.orderDateTime),
      );

      emit(state.copyWith(orders: orders, isLoading: false));
    });

    on<SetDateRange>((event, emit) {
      emit(state.copyWith(startDate: event.from, endDate: event.to));
      add(const RefreshOrderHistory());
    });

    on<PrintCurrentHistoryState>((event, emit) async {
      emit(state.copyWith(isPrinting: true));

      final shop = await _getShop(emit);

      if (shop == null) {
        return;
      }

      final hasPrinted = await IntervalPrintJob(
        state.orders,
        shop,
        startDate: state.startDate,
        endDate: state.endDate,
      ).print();

      debugPrint('hasPrinted: $hasPrinted');

      if (!hasPrinted) {
        emit(
          state.copyWith(
            isPrinting: false,
            error: 'Drucker nicht erreichbar, versuche erneut',
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        emit(state.copyWith(isPrinting: true));

        final hasPrintedSecond = await IntervalPrintJob(
          state.orders,
          shop,
          startDate: state.startDate,
          endDate: state.endDate,
        ).print();

        debugPrint('hasPrintedSecond: $hasPrintedSecond');

        if (!hasPrintedSecond) {
          if (emit.isDone) {
            return;
          }

          emit(
            state.copyWith(
              isPrinting: false,
              error:
              'Drucker nicht erreichbar. Bitte stellen Sie sicher, dass Bluetooth eingeschaltet ist.',
            ),
          );

          return;
        }
      }

      emit(state.copyWith(isPrinting: false));
    });

    on<PrintBill>((event, emit) async {
      emit(state.copyWith(isPrinting: true));

      FullOrder? order;

      try {
        order = state.orders.singleWhere(
              (element) => element.orderId == event.orderId,
        );
      } catch (e) {
        emit(
          state.copyWith(
            isPrinting: false,
            error: 'Bestellung nicht gefunden',
          ),
        );
        return;
      }

      final shop = await _getShop(emit);

      if (shop == null) {
        return;
      }

      final hasPrinted = await BillPrintJob(order, shop).print();

      debugPrint('hasPrinted: $hasPrinted');

      if (!hasPrinted) {
        emit(
          state.copyWith(
            isPrinting: false,
            error: 'Drucker nicht erreichbar, versuche erneut',
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        emit(state.copyWith(isPrinting: true));

        final hasPrintedSecond = await BillPrintJob(order, shop).print();

        debugPrint('hasPrintedSecond: $hasPrintedSecond');

        if (!hasPrintedSecond) {
          if (emit.isDone) {
            return;
          }

          emit(
            state.copyWith(
              isPrinting: false,
              error:
              'Drucker nicht erreichbar. Bitte stellen Sie sicher, dass Bluetooth eingeschaltet ist.',
            ),
          );

          return;
        }
      }

      emit(state.copyWith(isPrinting: false));
    });

    on<SwitchRangeMode>((event, emit) {
      emit(
        state.copyWith(
          showRange: !state.showRange,
          endDate: DateTime(
            state.startDate!.year,
            state.startDate!.month,
            state.startDate!.day,
            23,
            59,
            59,
          ),
        ),
      );

      add(const RefreshOrderHistory());
    });
  }

  String? get shopId => _settings.shopId;

  Future<DewaShop?> _getShop(Emitter<OrderHistoryState> emit) async {
    try {
      return await _repository.getDewaShop(shopId!);
    } catch (e) {
      _log.severe('Failed to get shop', e);

      try {
        return await _repository.getDewaShop(shopId!);
      } catch (e) {
        _log.severe('Failed to get shop', e);

        emit(
          state.copyWith(
            isPrinting: false,
            error: e.toString(),
          ),
        );

        return null;
      }
    }
  }

  @override
  Future<void> close() {
    _log.fine('close()');
    return super.close();
  }

  @override
  void onEvent(OrderHistoryEvent event) {
    _log.fine('onEvent: $event');
    super.onEvent(event);
  }

  void onPrintBill(String orderId) => add(PrintBill(orderId));

  void onPrintCurrentHistory() => add(const PrintCurrentHistoryState());

  void onRefresh() => add(const RefreshOrderHistory());

  void onSetDateRange(DateTime from, DateTime to) {
    add(SetDateRange(from: from, to: to));
  }

  void onSwitchRangeMode() => add(const SwitchRangeMode());

  @override
  void onTransition(
      Transition<OrderHistoryEvent, OrderHistoryState> transition,
      ) {
    _log.fine('nextState: ${transition.nextState}');
    super.onTransition(transition);
  }
}

abstract class OrderHistoryEvent {
  const OrderHistoryEvent();
}

class OrderHistoryState {
  final List<FullOrder> orders;
  final DateTime? startDate;
  final DateTime? endDate;

  final bool isLoading;
  final bool isPrinting;
  final bool showRange;
  final String? error;

  const OrderHistoryState({
    this.orders = const [],
    this.startDate,
    this.endDate,
    this.isLoading = false,
    this.isPrinting = false,
    this.showRange = false,
    this.error,
  });

  factory OrderHistoryState.initial() {
    final now = DateTime.now();

    return OrderHistoryState(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  OrderHistoryState copyWith({
    List<FullOrder>? orders,
    DateTime? startDate,
    DateTime? endDate,
    bool? isLoading,
    bool? isPrinting,
    bool? showRange,
    String? error,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      isPrinting: isPrinting ?? this.isPrinting,
      showRange: showRange ?? this.showRange,
      error: error,
    );
  }

  Map<String, dynamic> toJson() => {
    'orders': orders,
    'startDate': startDate,
    'endDate': endDate,
    'isLoading': isLoading,
    'isPrinting': isPrinting,
    'showRange': showRange,
    'error': error,
  };

  @override
  String toString() => 'OrderHistoryState(${toJson()})';
}

class PrintBill extends OrderHistoryEvent {
  final String orderId;

  const PrintBill(this.orderId);

  @override
  String toString() => 'PrintBill($orderId)';
}

class PrintCurrentHistoryState extends OrderHistoryEvent {
  const PrintCurrentHistoryState();
}

class RefreshOrderHistory extends OrderHistoryEvent {
  const RefreshOrderHistory();
}

class SetDateRange extends OrderHistoryEvent {
  final DateTime from;
  final DateTime to;

  const SetDateRange({
    required this.from,
    required this.to,
  });

  @override
  String toString() => 'SetDateRange($from, $to)';
}

class SwitchRangeMode extends OrderHistoryEvent {
  const SwitchRangeMode();
}
