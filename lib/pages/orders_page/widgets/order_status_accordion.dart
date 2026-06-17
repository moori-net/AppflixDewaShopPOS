import 'package:flutter/material.dart';

import '/models/full_order.dart';
import '/util.dart';

class OrderStatusAccordion extends StatefulWidget {
  final FullOrder order;

  const OrderStatusAccordion({super.key, required this.order});

  @override
  State<OrderStatusAccordion> createState() => _OrderStatusAccordionState();
}

class _OrderStatusAccordionState extends State<OrderStatusAccordion> {
  bool _collapsed = true;

  FullOrder get order => widget.order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline_rounded, color: Colors.black),
          title: Text(
            'Status',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.black, fontSize: 16.0),
          ),
          trailing: IconButton(
            color: Colors.black,
            onPressed: _onToggleAccordion,
            icon: !_collapsed
                ? const Icon(Icons.expand_less_rounded)
                : const Icon(Icons.expand_more_rounded),
          ),
        ),
        if (!_collapsed)
          Column(
            children: [
              ListTile(
                textColor: Colors.black,
                leading:
                    const Icon(Icons.punch_clock_rounded, color: Colors.black),
                title: const Text('Bestellzeit'),
                trailing: Text(
                    order.order?.orderDateTime.toLocal().timeFormat ?? '-'),
              ),
              ListTile(
                textColor: Colors.black,
                leading: const Icon(Icons.timer_rounded, color: Colors.black),
                title: const Text('Gewünschte Lieferzeit'),
                trailing: Text(
                    order.dewaShopOrder?.desiredTime!.toLocal().timeFormat ??
                        '-'),
              ),
            ],
          ),
        if (!_collapsed)
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(Icons.shopping_bag_rounded, color: Colors.black),
            title: Text('Bestellstatus: ${order.orderState!.name}'),
          ),
        if (!_collapsed)
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(Icons.delivery_dining_rounded, color: Colors.black),
            title: Text('Lieferstatus: ${order.deliveryState!.name}'),
          ),
        if (!_collapsed)
          ListTile(
            textColor: Colors.black,
            leading: const Icon(Icons.payment_rounded, color: Colors.black),
            title: Text('Transaktionsstatus: ${order.transactionState!.name}'),
          ),
      ],
    );
  }

  void _onToggleAccordion() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }
}
