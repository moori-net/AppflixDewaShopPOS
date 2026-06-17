import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/full_order.dart';
import '/models/shopware/attributes/shipping_method.dart';
import '/models/shopware/attributes/state_machine_state.dart';
import '/theme.dart';
import '/util.dart';
import '../bloc/orders_bloc.dart';
import 'delivery_time_dialog.dart';
import 'order_status_accordion.dart';

class OrderCard extends StatefulWidget {
  late final Color? _color;

  final FullOrder order;

  OrderCard({super.key, required this.order}) : _color = _getColor(order);

  @override
  State<OrderCard> createState() => _OrderCardState();

  static Color _getColor(FullOrder order) {
    if (order.orderState!.state != OrderState.open &&
        order.orderState!.state != OrderState.inProgress) {
      return Colors.grey;
    } else if (order.orderState!.state == OrderState.open) {
      return ordersBlue;
    } else if (order.orderState!.state == OrderState.inProgress &&
        order.deliveryState!.state == OrderState.open) {
      return preparationCoral;
    } else if (order.deliveryState!.state == OrderState.shipped) {
      if (order.shippingMethod!.type == ShippingMethodType.delivery) {
        return deliveryPurple;
      } else {
        return takeawayBeige;
      }
    }

    return Colors.white;
  }
}

class _OrderCardState extends State<OrderCard> {
  bool _expanded = false;
  late final OrdersBloc _bloc;

  FullOrder get order => widget.order;

  ButtonStyle get _buttonStyle => Theme.of(context)
      .elevatedButtonTheme
      .style!
      .copyWith(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.secondary,
        ),
        foregroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.onSecondary,
        ),
        textStyle:
            MaterialStatePropertyAll(Theme.of(context).textTheme.headlineSmall),
      );

  Function() get _onTap => _onExpandCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: widget._color ?? Colors.white,
      clipBehavior: Clip.antiAlias,
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(8.0),
              minVerticalPadding: 0,
              onTap: _onTap,
              leading: SizedBox(
                width: 64.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// order number
                    Text(
                      order.order!.orderNumber,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 14.0, color: Colors.black, height: 0.8),
                    ),

                    /// desired time text
                    Builder(builder: (BuildContext context) {
                      DateTime desiredTime = DateTime.now();

                      if (order.dewaShopOrder?.desiredTime != null) {
                        desiredTime =
                            order.dewaShopOrder!.desiredTime!.toLocal();
                      } else if (order.desiredTime != null) {
                        desiredTime = order.desiredTime!.date;
                      }

                      return Text(
                        '${desiredTime.isSameDay(DateTime.now()) ? "Heute " : "${desiredTime.shortDateFormat} "}${desiredTime.timeFormat}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ],
                ),
              ),
              title: Text(
                order.shippingMethod?.type == null
                    ? 'Keine Angabe'
                    : order.shippingMethod!.type == ShippingMethodType.delivery
                        ? order.orderAddress?.street ?? 'Keine Angabe'
                        : 'Selbstabholung',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.orderCustomer!.firstName} ${order.orderCustomer!.lastName}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    '${order.orderLineItems.fold<int>(0, (previousValue, element) => previousValue + element.quantity)} Produkte (${order.order?.amountTotal != null ? formatPrice(order.order!.amountTotal!) : "Kein Preis"})',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: _onExpandCard,
                icon: _expanded
                    ? const Icon(Icons.expand_less_rounded)
                    : const Icon(Icons.expand_more_rounded),
                color: Colors.black,
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (order.orderState!.state != OrderState.completed &&
                            order.orderState!.state != OrderState.cancelled)
                          ElevatedButton(
                              onPressed: _onCancelOrder,
                              child: Text(
                                'Stornieren',
                                style: Theme.of(context).textTheme.headlineSmall,
                              )
                          )
                        else
                          ElevatedButton(
                              onPressed: _onRemoveOrder,
                              child: const Text('Aus Liste entfernen')),
                        if (order.orderState!.state != OrderState.completed)
                          const Divider(),
                        if (order.orderState!.state == OrderState.open)
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () => _onConfirmOrder(),
                                  style: _buttonStyle,
                                  child: const Text('Bestätigen')))
                        else if (order.deliveryState!.state ==
                                OrderState.shipped &&
                            order.orderState!.state == OrderState.inProgress)
                          if (order.transactionState!.state ==
                                  OrderState.open ||
                              order.transactionState!.state ==
                                  OrderState.unconfirmed)
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: _onPaidOrder,
                                    style: _buttonStyle,
                                    child: const Text('Bezahlt')))
                          else
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: _onCompleteOrder,
                                    style: _buttonStyle,
                                    child: const Text('Abgeschlossen')))
                        else if (order.orderState!.state ==
                                OrderState.inProgress &&
                            order.deliveryState!.state == OrderState.open)
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: _onShipOrder,
                                  style: _buttonStyle,
                                  child: const Text('Versenden')))
                      ],
                    ),
                    const Divider(),
                    ...order.orderLineItems.map((e) => ListTile(
                          textColor: Colors.black,
                          minLeadingWidth: 8.0,
                          contentPadding: const EdgeInsets.all(0.0),
                          leading: Text('${e.quantity}x',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.black, fontSize: 16.0)),
                          title: Text(
                              '${e.label} - ${e.totalPrice != null ? formatPrice(e.totalPrice!) : "Kein Preis"}'),
                          subtitle: e.payload?.dewaShop != null &&
                                  e.payload!.dewaShop.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...e.payload!.dewaShop.map(
                                      (e) => Text(
                                        '${e.name}: ${e.value.join(", ")}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        )),
                    if (order.phoneNumber != null)
                      ListTile(
                        textColor: Colors.black,
                        leading: const Icon(Icons.contact_phone_rounded, color: Colors.black),
                        title: Text(order.phoneNumber.toString()),
                      ),
                    if (order.dewaShopOrder?.comment != null)
                      ListTile(
                        textColor: Colors.black,
                        leading: const Icon(Icons.comment_rounded, color: Colors.black),
                        title: Text(order.dewaShopOrder!.comment!),
                      ),
                    ListTile(
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      leading: order.paymentMethod!.distinguishableName ==
                              'Barzahlung'
                          ? const Icon(Icons.money_rounded)
                          : const Icon(Icons.credit_card_rounded),
                      title: Text(
                          'Zahlmethode: ${order.paymentMethod!.distinguishableName}'),
                      subtitle: (order.transactionState!.state ==
                              OrderState.unconfirmed)
                          ? const Text('Die Zahlung wurde noch nicht bestätigt')
                          : (order.transactionState!.state == OrderState.open)
                              ? Text(
                                  'Die Bestellung wird bei ${order.shippingMethod!.type == ShippingMethodType.delivery ? "Lieferung" : "Abholung"} bezahlt',
                                )
                              : const Text(
                                  'Die Bestellung wurde bereits bezahlt'),
                    ),
                    const Divider(),
                    OrderStatusAccordion(order: order),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                              onPressed: _onPrintOrder,
                              child: Text(
                                'Nur Drucken',
                                style: Theme.of(context).textTheme.headlineSmall,
                              )
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<OrdersBloc>(context);
    super.initState();
  }

  Future<bool?> _questionDialog(String question) async {
    return await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Nein'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ja'),
          ),
        ],
      ),
    );
  }

  void _onCancelOrder() async {
    final result = await _questionDialog('Bestellung wirklich stornieren?');
    if (result == null || !result) return;

    _bloc.onCancelOrder(widget.order.orderId);
  }

  void _onPrintOrder() async {
    _bloc.onPrintOrder(widget.order.orderId);
  }

  void _onCompleteOrder() async {
    final result = await _questionDialog('Bestellung wirklich abschließen?');
    if (!(result ?? false)) return;

    _bloc.onCompleteOrder(widget.order.orderId);
  }

  void _onConfirmOrder() async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => DeliveryTimeDialog(
        order: widget.order,
        bloc: _bloc,
      ),
    );
    if (result == null || !result) return;

    _bloc.onProcessOrder(widget.order.orderId);
  }

  void _onExpandCard() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _onPaidOrder() async {
    final result = await _questionDialog('Bestellung wirklich bezahlt?');
    if (!(result ?? false)) return;

    _bloc.onPaidOrder(widget.order.orderTransactionId);

    /// If order is delivered and paid, its also completed
    _bloc.onCompleteOrder(widget.order.orderId);
  }

  void _onRemoveOrder() {
    _bloc.onRefresh();
  }

  void _onShipOrder() async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) => DeliveryTimeDialog(
        order: widget.order,
        bloc: _bloc,
        label: 'Bestellung versenden',
      ),
    );

    if (result == null || !result) return;

    _bloc.onShipOrder(order.orderDeliveryId);
  }
}
