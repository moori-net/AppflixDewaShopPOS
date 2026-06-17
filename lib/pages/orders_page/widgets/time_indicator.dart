import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/util.dart';
import '../bloc/orders_bloc.dart';

class TimeIndicator extends StatefulWidget {
  const TimeIndicator({super.key});

  @override
  State<TimeIndicator> createState() => _TimeIndicatorState();
}

class _TimeIndicatorState extends State<TimeIndicator> {
  static DateTime time = DateTime.now();

  late final Timer timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) => state.active
          ? StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, snapshot) => snapshot.data ==
                      ConnectivityResult.none
                  ? const SizedBox()
                  : ListTile(
                      minLeadingWidth: 16.0,
                      leading: Tooltip(
                        message: state.active &&
                                (state.collectActive || state.deliveryActive)
                            ? 'Restaurant geöffnet und Lieferung und/oder Abholung möglich'
                            : state.active
                                ? 'Restaurant geöffnet aber Lieferung und Abholung deaktiviert'
                                : 'Restaurant geschlossen',
                        child: Icon(
                          Icons.circle,
                          size: 16.0,
                          color: state.active &&
                                  (state.collectActive || state.deliveryActive)
                              ? Colors.green
                              : state.active
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      title: Text(
                        'Heutige Bestellungen'.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      trailing: Text(
                        time.timeFormat,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0.0,
                      ),
                      tileColor: Theme.of(context).canvasColor,
                      dense: true,
                    ),
            )
          : const SizedBox(),
    );
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), _onUpdateTimer);
    super.initState();
  }

  void _onUpdateTimer(Timer timer) {
    if (DateTime.now().isSameMinute(time)) return;
    if (mounted) setState(() => time = DateTime.now());
  }
}
