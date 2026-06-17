import 'dart:async';

import 'package:flutter/material.dart';

import '/models/full_order.dart';
import '/util.dart';
import '../bloc/orders_bloc.dart';

class DeliveryTimeDialog extends StatelessWidget {
  final FullOrder order;
  final OrdersBloc bloc;
  final String label;

  const DeliveryTimeDialog({
    super.key,
    required this.order,
    required this.bloc,
    this.label = 'Bestellung bestätigen',
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(16.0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      title: Text(label),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var time = 0; time <= 45; time += 15)
              TextButton(
                onPressed: () => _onSetDeliveryTime(context, time),
                child: Text(time.toString()),
              ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var time = 45; time <= 90; time += 15)
              TextButton(
                onPressed: () => _onSetDeliveryTime(context, time),
                child: Text(time.toString()),
              ),
          ],
        ),
        const Divider(),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(label),
        ),
      ],
    );
  }

  void _onSetDeliveryTime(BuildContext context, int minutes) async {
    StreamSubscription? subscription;
    FullOrder? newOrder;
    subscription = bloc.stream.listen((state) {
      try {
        newOrder = state.orders.singleWhere(
            (element) => element.dewaShopOrderId == order.dewaShopOrderId);
      } catch (e) {
        /// order not found
        /// its probably already completed
        return;
      }

      if (newOrder?.desiredTime != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Lieferzeit auf ${newOrder!.desiredTime!.date.toLocal().timeFormat} gesetzt')));
        subscription!.cancel();
      }
    });

    bloc.onSetDeliveryTime(order.dewaShopOrderId, minutes);
  }
}
