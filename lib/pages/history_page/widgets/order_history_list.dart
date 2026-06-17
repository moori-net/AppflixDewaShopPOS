import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/util.dart';
import '../../../models/full_order.dart';
import '../bloc/history_bloc.dart';

class OrderHistoryList extends StatefulWidget {
  const OrderHistoryList({super.key});

  @override
  State<OrderHistoryList> createState() => _OrderHistoryListState();
}

class _OrderHistoryListState extends State<OrderHistoryList> {
  late final StreamSubscription<OrderHistoryState> _listener;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            BlocProvider.of<OrderHistoryBloc>(context).onRefresh();

            return BlocProvider.of<OrderHistoryBloc>(context)
                .stream
                .any((element) => element.isLoading == false);
          },
          child: ListView(
            children: [
              for (final order in state.orders)
                ListTile(
                  title: Text(
                      '${order.order!.orderNumber} - ${order.orderCustomer!.firstName} ${order.orderCustomer!.lastName}'),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          '${order.orderAddress!.street}, ${order.orderAddress!.zipcode} ${order.orderAddress!.city}'),
                      Text(
                          '${order.order!.orderDateTime.dateFormat} ${order.order!.orderDateTime.timeFormat}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: order.orderTransaction?.amount == null
                        ? const [Text('Kein Preis')]
                        : [
                            Text(formatPrice(
                                order.orderTransaction!.amount!.totalPrice)),
                            Text(formatPrice(order
                                .orderTransaction!.amount!.calculatedTaxes
                                .map((e) => e.tax)
                                .reduce((value, element) => value + element))),
                          ],
                  ),
                  onLongPress: () => _onShowContextMenu(order),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _listener =
        BlocProvider.of<OrderHistoryBloc>(context).stream.listen((state) {
      if (state.isPrinting) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Beleg wird gedruckt...'),
            duration: Duration(seconds: 1)));
      }

      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler: ${state.error!}'),
          duration: const Duration(seconds: 1),
        ));
      }
    });
    super.initState();
  }

  void _onShowContextMenu(FullOrder order) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          ListTile(
            title: const Text('Beleg drucken'),
            onTap: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );

    if (result == null || !result) return;
    if (!mounted) return;

    BlocProvider.of<OrderHistoryBloc>(context).onPrintBill(order.orderId);
  }
}
