import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

import '/models/order_category.dart';
import '/models/shopware/attributes/shipping_method.dart';
import '/models/shopware/attributes/state_machine_state.dart';
import '../bloc/orders_bloc.dart';
import 'category_indicator.dart';
import 'order_card.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late final OrdersBloc _bloc;

  late final StreamSubscription<OrdersState> _ordersListener;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final connectivityResult = snapshot.data as ConnectivityResult?;

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<OrdersBloc>(context).onRefresh();
              },
              child: ListView(
                shrinkWrap: true,
                physics: connectivityResult == ConnectivityResult.none
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: [
                  BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (BuildContext context, OrdersState state) {
                      if (state.loading && state.orders.isEmpty) {
                        return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(64.0),
                              child: CircularProgressIndicator()),
                        );
                      }
                      return Column(
                        children: [
                          CategoryIndicator(
                            numOrders: BlocProvider.of<OrdersBloc>(context)
                                .orders
                                .where((element) =>
                                    element.orderState!.state ==
                                        OrderState.open &&
                                    element.deliveryState!.state ==
                                        OrderState.open)
                                .length,
                            numPreparation: BlocProvider.of<OrdersBloc>(context)
                                .orders
                                .where((element) =>
                                    element.orderState!.state ==
                                        OrderState.inProgress &&
                                    element.deliveryState!.state ==
                                        OrderState.open)
                                .length,
                            numDelivery: BlocProvider.of<OrdersBloc>(context)
                                .orders
                                .where((element) =>
                                    element.orderState!.state ==
                                        OrderState.inProgress &&
                                    element.deliveryState!.state ==
                                        OrderState.shipped &&
                                    element.shippingMethod!.type ==
                                        ShippingMethodType.delivery)
                                .length,
                            numTakeaway: BlocProvider.of<OrdersBloc>(context)
                                .orders
                                .where((element) =>
                                    element.orderState!.state ==
                                        OrderState.inProgress &&
                                    element.deliveryState!.state ==
                                        OrderState.shipped &&
                                    element.shippingMethod!.type ==
                                        ShippingMethodType.pickup)
                                .length,
                            onFilterChanged: (List<OrderCategory> filter) =>
                                BlocProvider.of<OrdersBloc>(context)
                                    .onUpdateFilter(filter),
                          ),
                          for (var order in state.orders)
                            OrderCard(order: order),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            if (connectivityResult == ConnectivityResult.none)
              InkWell(
                onTap: () => Connectivity().checkConnectivity(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.black54),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _ordersListener.cancel();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<OrdersBloc>(context);
    _onRefresh();

    _ordersListener = _bloc.stream.listen((state) {
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    Wakelock.enable();

    super.initState();
  }

  Future<void> _onRefresh() async {
    _bloc.onRefresh();
  }
}
